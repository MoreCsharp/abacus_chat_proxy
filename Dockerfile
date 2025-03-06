# 使用官方 Python 3.9 镜像作为基础镜像 (你可以根据需要选择其他版本, 比如 3.7, 3.8 等)
FROM python:3.9-slim-buster

# 设置工作目录为 /app
WORKDIR /app

# 将当前目录下的所有文件复制到容器的 /app 目录下
COPY . /app

# 安装依赖
# 使用 --no-cache-dir 选项可以减小镜像大小，避免缓存带来的问题
# 我们不需要创建和激活虚拟环境，因为 Docker 容器本身就是一个隔离的环境
RUN pip3 install --no-cache-dir -r requirements.txt

# 暴露端口 (根据你的应用修改，脚本中提到的是 9876)
EXPOSE 9876

# 定义环境变量 (如果你的 app.py 需要)
# 例如: ENV FLASK_ENV=production
# ENV DATABASE_URL=...

# 运行 Flask 应用 (使用 gunicorn 作为生产环境的 WSGI 服务器)
# 脚本中是直接使用 `python3 app.py` 启动, 这里改用 gunicorn
# 如果你坚持使用 `python3 app.py`，请删除下面这行，并取消下一行（CMD 那行）的注释
# RUN pip3 install gunicorn
# CMD ["gunicorn", "--bind", "0.0.0.0:9876", "app:app"]

# 如果你确定要使用 `python3 app.py` 来启动，请取消下面这行的注释，并删除上面两行（RUN 和 CMD）
CMD ["python3", "app.py"]

# 添加对信号的处理，使容器可以优雅地停止（可选，但推荐）
STOPSIGNAL SIGTERM
