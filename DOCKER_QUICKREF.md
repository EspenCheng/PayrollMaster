# 🐳 Docker 开发快速参考

## 🚀 一键启动

```bash
bash start-dev.sh
```

## 📱 访问地址

| 服务 | 地址 | 登录信息 |
|------|------|----------|
| 前端 | http://localhost:3000 | - |
| 后端 API | http://localhost:8000 | - |
| API 文档 | http://localhost:8000/docs | - |
| pgAdmin | http://localhost:5050 | admin@payroll.com / admin123 |

## 🔧 常用命令

### 启动
```bash
# 后台启动
docker-compose -f docker-compose.dev.yml up -d

# 前台启动 (带日志)
docker-compose -f docker-compose.dev.yml up
```

### 停止
```bash
# 停止服务
docker-compose -f docker-compose.dev.yml down

# 完全清理 (删除数据)
docker-compose -f docker-compose.dev.yml down -v
```

### 重启
```bash
# 重启所有
docker-compose -f docker-compose.dev.yml restart

# 重启特定服务
docker-compose -f docker-compose.dev.yml restart backend frontend
```

### 查看状态
```bash
# 查看容器状态
docker-compose -f docker-compose.dev.yml ps

# 查看日志
docker-compose -f docker-compose.dev.yml logs -f backend
```

### 进入容器
```bash
# 进入后端容器
docker exec -it payroll-backend-dev bash

# 进入前端容器
docker exec -it payroll-frontend-dev sh
```

## 💾 数据备份

```bash
# 备份数据库
docker exec -it payroll-postgres-dev pg_dump -U payroll payrollmaster > backup.sql

# 恢复数据库
docker exec -i payroll-postgres-dev psql -U payroll payrollmaster < backup.sql
```

## 🧹 清理环境

```bash
# 清理未使用的镜像
docker image prune -a

# 清理未使用的卷
docker volume prune

# 完全重置 (删除所有容器、镜像、数据)
docker-compose -f docker-compose.dev.yml down -v --rmi all --remove-orphans
```

## 🔍 故障排除

### 端口被占用
```bash
# 查看端口占用
netstat -ano | findstr :3000
netstat -ano | findstr :8000
netstat -ano | findstr :5432
```

### 容器启动失败
```bash
# 查看所有日志
docker-compose -f docker-compose.dev.yml logs

# 重建镜像
docker-compose -f docker-compose.dev.yml up --build --force-recreate
```

### 数据库连接失败
```bash
# 检查 PostgreSQL 状态
docker-compose -f docker-compose.dev.yml ps postgres

# 手动连接测试
docker exec -it payroll-postgres-dev psql -U payroll -d payrollmaster
```

## 📊 资源监控

```bash
# 查看容器资源使用
docker stats

# 查看磁盘使用
docker system df
```

## 🔄 开发工作流

1. **启动服务** → `bash start-dev.sh`
2. **浏览器访问** → http://localhost:3000
3. **编辑代码** → 本地编辑器修改
4. **自动重启** → 热重载自动生效
5. **查看日志** → `docker-compose -f docker-compose.dev.yml logs -f`
6. **测试 API** → http://localhost:8000/docs
7. **管理数据库** → http://localhost:5050

## ✅ 检查清单

- [ ] Docker Desktop 已启动
- [ ] 端口 3000, 8000, 5050, 5432, 6379 未被占用
- [ ] 运行 `bash start-dev.sh` 成功
- [ ] 浏览器可以访问 http://localhost:3000
- [ ] API 文档可以访问 http://localhost:8000/docs

## 💡 小贴士

1. **首次启动较慢** - 需要下载和构建镜像 (约 2-5 分钟)
2. **保持终端开启** - 查看实时日志输出
3. **修改代码自动生效** - 无需手动重启
4. **数据持久化** - Docker 卷自动保存数据
5. **团队协作** - 每个人的环境完全一致

---

**详细文档**: [DOCKER_DEV_GUIDE.md](./DOCKER_DEV_GUIDE.md)
