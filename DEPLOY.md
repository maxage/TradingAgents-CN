# TradingAgents-CN 零代码部署指南

## 概述

现在您可以使用预构建的Docker镜像进行零代码部署，无需git clone整个项目！

## 快速部署步骤

### 1. 创建部署目录
```bash
mkdir tradingagents-deploy
cd tradingagents-deploy
```

### 2. 创建必要的目录
```bash
mkdir -p logs config
```

### 3. 下载配置文件
只需要下载以下文件：
- `docker-compose.yml` - Docker编排配置
- `.env` - 环境变量配置（需要自己创建）

### 4. 创建环境配置文件
创建 `.env` 文件，包含您的API密钥等配置：

```env
# API配置
OPENAI_API_KEY=your_openai_api_key_here
DASHSCOPE_API_KEY=your_dashscope_api_key_here
GOOGLE_API_KEY=your_google_api_key_here

# 其他配置...
```

### 5. 启动服务
```bash
# 启动基础服务
docker-compose up -d

# 或者启动包含管理界面的完整服务
docker-compose --profile management up -d
```

## 服务访问地址

- **主应用**: http://localhost:8501
- **Redis管理**: http://localhost:8081
- **MongoDB管理**: http://localhost:8082 (需要使用 --profile management 启动)

## 主要改动

1. **使用预构建镜像**: `ghcr.io/maxage/tradingagents-cn:latest`
2. **移除代码映射**: 代码已包含在Docker镜像中
3. **保留数据映射**: 日志和配置目录仍映射到本地
4. **简化MongoDB初始化**: 可选的初始化脚本

## 优势

- ✅ **零代码部署**: 无需git clone项目
- ✅ **快速启动**: 只需配置文件即可运行
- ✅ **自动更新**: 拉取最新镜像即可更新
- ✅ **环境隔离**: 完全容器化部署
- ✅ **数据持久化**: 日志和配置数据保存在本地

## 更新应用

```bash
# 拉取最新镜像
docker-compose pull

# 重启服务
docker-compose up -d
```

## 故障排除

### 查看日志
```bash
# 查看所有服务日志
docker-compose logs

# 查看特定服务日志
docker-compose logs web
docker-compose logs mongodb
docker-compose logs redis
```

### 重启服务
```bash
# 重启所有服务
docker-compose restart

# 重启特定服务
docker-compose restart web
```

### 清理和重建
```bash
# 停止并删除容器
docker-compose down

# 重新启动
docker-compose up -d
```
