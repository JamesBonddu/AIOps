app.run_server(host="0.0.0.0", 
                url_base_pathname='/dash/',  # 设置 Dash 应用的 URL 前缀
                requests_pathname_prefix='/dash/',  # 设置请求路径前缀
                assets_folder='static',  # 静态文件目录
                assets_url_path='/dash/static'  # 静态文件路径前缀
                debug=True)