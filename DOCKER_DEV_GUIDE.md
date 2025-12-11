# 🐳 Docker 开发环境指南

## 🎯 概述

PayrollMaster 支持完全在 Docker 容器中开发的模式，您的本地电脑只需安装 Docker，然后通过浏览器访问开发进度。

## ✨ 优势

1. **环境一致性** - 所有开发者使用完全相同的环境
2. **零配置** - 不需要在本地安装 Python、Node.js 等
3. **隔离性** - 不污染本地系统
4. **热重载** - 修改代码后自动重启服务
5. **易于部署** - 开发环境 = 生产环境

## 🚀 快速开始

### 前置要求

- **Docker Desktop** - [下载地址](https://www.docker.com/products/docker-desktop/)
- **Git** - 用于克隆代码

### 启动步骤

1. **启动 Docker Desktop**

2. **在项目根目录执行**:
   ```bash
   # 方式1: 使用启动脚本 (推荐)
   bash start-dev.sh

   # 方式2: 直接使用 docker-compose
   docker-compose -f docker-compose.dev.yml up --build
   ```

3. **等待启动完成** (首次启动需要下载和构建镜像，约 2-5 分钟)

4. **在浏览器中访问**:
   - 前端应用: http://localhost:3000
   - 后端 API: http://localhost:8000
   - API 文档: http://localhost:8000/docs
   - pgAdmin: http://localhost:5050

## 📱 访问地址

| 服务 | 地址 | 说明 |
|------|------|------|
| 前端应用 | http://localhost:3000 | Next.js 开发服务器 |
| 后端 API | http://localhost:8000 | FastAPI 应用 |
| API 文档 | http://localhost:8000/docs | Swagger UI |
| pgAdmin | http://localhost:5050 | 数据库管理界面 |

### pgAdmin 登录信息
- **邮箱**: admin@payroll.com
- **密码**: admin123
- **服务器**: postgres
- **端口**: 5432

## 💻 开发工作流

### 1. 编辑代码

您可以在本地使用任何编辑器修改代码：
- VS Code
- WebStorm
- Sublime Text
- Vim

### 2. 热重载

代码修改后会自动触发重启：
- **后端** (Python): 使用 `uvicorn --reload`
- **前端** (TypeScript): 使用 Next.js 开发服务器

### 3. 查看日志

```bash
# 查看所有服务日志
docker-compose -f docker-compose.dev.yml logs -f

# 查看特定服务日志
docker-compose -f docker-compose.dev.yml logs -f backend
docker-compose -f docker-compose.dev.yml logs -f frontend
```

### 4. 调试

#### 后端调试
```bash
# 进入后端容器
docker exec -it payroll-backend-dev bash

# 在容器内运行 Python 命令
python main.py
```

#### 前端调试
```bash
# 进入前端容器
docker exec -it payroll-frontend-dev sh

# 查看构建日志
cat /app/.next/trace
```

## 🔧 常用命令

### 启动服务
```bash
# 启动所有服务 (后台运行)
docker-compose -f docker-compose.dev.yml up -d

# 启动并查看日志
docker-compose -f docker-compose.dev.yml up
```

### 停止服务
```bash
# 停止所有服务
docker-compose -f docker-compose.dev.yml down

# 停止并删除数据卷
docker-compose -f docker-compose.dev.yml down -v
```

### 重启服务
```bash
# 重启特定服务
docker-compose -f docker-compose.dev.yml restart backend
docker-compose -f docker-compose.dev.yml restart frontend
```

### 清理环境
```bash
# 完全清理 (删除所有容器、镜像、数据)
docker-compose -f docker-compose.dev.yml down -v --rmi all --remove-orphans
```

### 查看状态
```bash
# 查看运行中的容器
docker-compose -f docker-compose.dev.yml ps

# 查看资源使用
docker stats
```

## 🗄️ 数据持久化

以下数据会被持久化到 Docker 卷中：

- **PostgreSQL 数据**: `postgres_dev_data` 卷
- **Redis 数据**: `redis_dev_data` 卷
- **pgAdmin 配置**: `pgadmin_dev_data` 卷

### 备份数据
```bash
# 备份 PostgreSQL 数据库
docker exec -it payroll-postgres-dev pg_dump -U payroll payrollmaster > backup.sql

# 恢复 PostgreSQL 数据库
docker exec -i payroll-postgres-dev psql -U payroll payrollmaster < backup.sql
```

## 🐛 故障排除

### 问题 1: 端口被占用
```bash
# 查看端口占用
netstat -ano | findstr :3000
netstat -ano | findstr :8000

# 停止占用端口的进程
taskkill /PID <PID> /F
```

### 问题 2: Docker Desktop 未运行
- 启动 Docker Desktop 应用
- 等待 Docker 图标变为运行状态

### 问题 3: 容器启动失败
```bash
# 查看容器日志
docker-compose -f docker-compose.dev.yml logs backend
docker-compose -f docker-compose.dev.yml logs frontend

# 重建镜像
docker-compose -f docker-compose.dev.yml up --build --force-recreate
```

### 问题 4: 数据库连接失败
```bash
# 检查 PostgreSQL 容器状态
docker-compose -f docker-compose.dev.yml ps postgres

# 重启 PostgreSQL
docker-compose -f docker-compose.dev.yml restart postgres
```

### 问题 5: 修改代码后没有热重载
- 确保文件挂载正确
- 检查容器日志看是否有错误
- 重启相关容器:
  ```bash
  docker-compose -f docker-compose.dev.yml restart backend
  docker-compose -f docker-compose.dev.yml restart frontend
  ```

## 📂 文件结构

```
PayrollMaster/
├── docker-compose.dev.yml    # 开发环境配置
├── start-dev.sh             # 启动脚本
├── backend/
│   ├── Dockerfile.dev       # 后端开发镜像
│   ├── requirements-core.txt
│   └── src/
├── frontend/
│   ├── Dockerfile.dev       # 前端开发镜像
│   ├── package.json
│   └── src/
└── scripts/
    └── init-db.sql          # 数据库初始化脚本
```

## 🎓 最佳实践

1. **使用 VS Code Remote Containers**
   - 安装 "Remote - Containers" 扩展
   - 可以在容器内直接开发

2. **配置 Git 忽略**
   ```gitignore
   # Docker 相关
   .docker/
   docker-compose.override.yml

   # 数据卷
   postgres_dev_data/
   redis_dev_data/
   pgadmin_dev_data/
   ```

3. **定期清理**
   ```bash
   # 清理未使用的镜像
   docker image prune -a

   # 清理未使用的卷
   docker volume prune
   ```

4. **多项目隔离**
   - 每个项目使用不同的端口范围
   - 使用不同的网络名称

## 🔄 与本地开发对比

| 特性 | Docker 开发 | 本地开发 |
|------|-------------|----------|
| 环境配置 | 简单 (仅需 Docker) | 复杂 (需安装多个工具) |
| 环境一致性 | 100% 一致 | 可能不一致 |
| 依赖管理 | 自动 | 手动 |
| 资源占用 | 较高 | 较低 |
| 启动速度 | 第一次慢，后续快 | 快 |
| 调试体验 | 稍复杂 | 简单 |

## 🎯 下一步

1. ✅ 启动 Docker 开发环境
2. ✅ 在浏览器中访问应用
3. ✅ 开始编辑代码 (支持热重载)
4. ✅ 使用 pgAdmin 管理数据库
5. ✅ 查看 API 文档

## 💡 提示

- 首次启动需要构建镜像，请耐心等待
- 建议将 Docker Desktop 设置为开机自启
- 使用 `docker system df` 查看磁盘使用情况
- 开发时保持终端窗口打开以查看日志

## 🆘 获取帮助

如果遇到问题：
1. 查看容器日志: `docker-compose -f docker-compose.dev.yml logs`
2. 检查 Docker Desktop 是否正常运行
3. 重启 Docker Desktop
4. 查看 [Docker 官方文档](https://docs.docker.com/)

---

**Happy Coding! 🎉**
