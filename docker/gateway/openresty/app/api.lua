-- 示例：输出 "Hello, Lua!"
ngx.say("Hello, Lua!")

-- 获取请求的 URI
local uri = ngx.var.uri
ngx.log(ngx.INFO, "Request URI: " .. uri)

-- 返回 JSON 响应
ngx.header["Content-Type"] = "application/json"
ngx.say('{"message": "This is a Lua response"}')