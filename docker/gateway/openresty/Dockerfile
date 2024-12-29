# 使用官方的 OpenResty 镜像作为基础镜像
FROM openresty/openresty:latest

# 安装 LuaRocks（可选，如果你需要使用 LuaRocks 安装 Lua 模块）
RUN apt-get update && apt-get install -y luarocks

# 通过 LuaRocks 安装 lua-resty-http
RUN luarocks install lua-resty-http

# 暴露 80 端口
EXPOSE 80

# 启动 OpenResty
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]