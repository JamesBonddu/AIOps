-- /etc/nginx/conf.d/validate_token.lua

local http = require "resty.http"
local cjson = require "cjson"
local ngx_shared = ngx.shared

-- 创建共享内存字典来存储token验证结果
local dict = ngx_shared.tokens 
if not dict then
    dict = ngx_shared.DICT
end

-- 从请求头中获取 Authorization 头
local auth_header = ngx.req.get_headers()["authorization"]
if not auth_header then
    ngx.log(ngx.ERR, "Missing Authorization header")
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say("Missing Authorization header")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- 检查 Authorization 头是否以 "Bearer " 开头
local prefix = "Bearer "
if not auth_header:find(prefix, 1, true) then
    ngx.log(ngx.ERR, "Invalid Authorization header format")
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say("Invalid Authorization header format")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- 提取 Bearer 后面的字符串
local id_token = auth_header:sub(#prefix + 1)

-- 检查缓存中是否存在有效的验证结果
local cache_value = dict:get(id_token)
local current_time = ngx.time()

if cache_value then
    local cached_exp = tonumber(cache_value)
    -- 检查是否在有效期内（减去10秒的缓冲时间）
    if current_time < (cached_exp - 10) then
        ngx.log(ngx.INFO, "Token is valid (cached)")
        -- token仍然有效，直接通过验证
        ngx.log(ngx.INFO, "Login successful (cached token)")
        return
    else
        ngx.log(ngx.INFO, "Cached token expired")
    end
end

-- 如果没有缓存或缓存已过期，发送请求到 Google Token 验证 API
local httpc = http.new()

if not httpc then
    ngx.log(ngx.ERR, "Failed to create HTTP client")
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    ngx.say("Failed to create HTTP client")
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

ngx.log(ngx.INFO, "Sending token verification request to Google API")
local res, err = httpc:request_uri("https://oauth2.googleapis.com/tokeninfo", {
    method = "POST",
    body = "id_token=" .. id_token,
    headers = {
        ["Content-Type"] = "application/x-www-form-urlencoded"
    },
    ssl_verify = false 
})

if not res then
    ngx.log(ngx.ERR, "Failed to verify token: " .. err)
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    ngx.say("Failed to verify token: ", err)
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

-- 检查响应状态码
if res.status ~= 200 then
    ngx.log(ngx.ERR, "Invalid token, Google API returned status: " .. res.status)
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say("Invalid token")
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- 解析响应体
local response_body = cjson.decode(res.body)
local exp = tonumber(response_body.exp)

if not exp then
    ngx.log(ngx.ERR, "Invalid response format from Google API")
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    ngx.say("Invalid response format")
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

-- 将过期时间存储到共享内存中
dict:set(id_token, exp)

ngx.log(ngx.INFO, "Token verified and cached, expires at: " .. exp)

-- 记录登录成功的日志
ngx.log(ngx.INFO, "Login successful, token verified and cached")