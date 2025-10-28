# 使用Python 3.10，与requirements-lock.txt生成环境一致
FROM python:3.10-slim-bookworm

WORKDIR /app

RUN mkdir -p /app/data /app/logs

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# 使用官方Debian源
RUN echo 'deb http://deb.debian.org/debian bookworm main' > /etc/apt/sources.list && \
    echo 'deb-src http://deb.debian.org/debian bookworm main' >> /etc/apt/sources.list && \
    echo 'deb http://deb.debian.org/debian bookworm-updates main' >> /etc/apt/sources.list && \
    echo 'deb-src http://deb.debian.org/debian bookworm-updates main' >> /etc/apt/sources.list && \
    echo 'deb http://deb.debian.org/debian-security bookworm-security main' >> /etc/apt/sources.list && \
    echo 'deb-src http://deb.debian.org/debian-security bookworm-security main' >> /etc/apt/sources.list

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    wkhtmltopdf \
    xvfb \
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
    fonts-liberation \
    pandoc \
    procps \
    && rm -rf /var/lib/apt/lists/*

# 启动Xvfb虚拟显示器
RUN echo '#!/bin/bash\nXvfb :99 -screen 0 1024x768x24 -ac +extension GLX &\nexport DISPLAY=:99\nexec "$@"' > /usr/local/bin/start-xvfb.sh \
    && chmod +x /usr/local/bin/start-xvfb.sh

# 升级pip到最新版本
RUN pip install --upgrade pip

# 复制依赖文件
COPY requirements-lock.txt .

# 使用官方PyPI源安装依赖
# 先安装基础构建工具
RUN pip install --no-cache-dir wheel setuptools

# 安装requirements-lock.txt中的所有依赖
RUN pip install --no-cache-dir -r requirements-lock.txt

# 复制项目代码
COPY . .

# 安装项目本身
RUN pip install -e .

# 复制日志配置文件
COPY config/ ./config/

EXPOSE 8501

CMD ["python", "-m", "streamlit", "run", "web/app.py", "--server.address=0.0.0.0", "--server.port=8501"]
