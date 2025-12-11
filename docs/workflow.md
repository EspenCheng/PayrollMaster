# 混合开发工作流指南

## 🎯 概述

PayrollMaster 采用"本地文档 + Docker沙箱"的混合开发模式，这种模式结合了本地编辑的便利性和容器化开发的环境一致性优势。

## ✨ 核心优势

### 本地优势
- **文档管理**：离线访问、快速搜索、全文检索
- **编辑体验**：使用熟悉的编辑器（VS Code、WebStorm等）
- **性能**：本地文件系统I/O更快
- **版本控制**：Git操作更流畅

### 容器优势
- **环境隔离**：不污染本地系统
- **一致性**：所有团队成员使用相同环境
- **快速启动**：一键启动所有服务
- **热重载**：代码修改自动生效

## 🚀 快速开始

### 步骤1：阅读文档
在本地打开项目文档，了解需求和规范：
```bash
# 在Windows资源管理器中浏览
specs/
├── spec.md                    # 功能规格说明书
├── plan.md                    # 实施计划
├── tasks.md                   # 任务清单
├── model.md              # 数据模型设计
├── research.md                # 技术研究报告
├── contracts/
│   └── api.md       # API端点规范
└── guides/
    ├── excel-format.md   # Excel格式规范
    ├── frontend-architecture.md # 前端架构设计
    └── python-standards.md # Python编码规范
```

### 步骤2：启动开发环境
打开Git Bash或PowerShell，执行：
```bash
bash start-dev.sh
```

等待服务启动（约1-2分钟首次启动较慢）：
```
[+] Running 5/5
 ✔ Container payroll-postgres-dev  Created
 ✔ Container payroll-redis-dev     Created
 ✔ Container payroll-backend-dev   Created
 ✔ Container payroll-frontend-dev  Created
 ✔ Container payroll-pgadmin-dev   Created

✅ 所有服务已启动
🌐 前端: http://localhost:3000
🔌 后端: http://localhost:8000
📊 pgAdmin: http://localhost:5050
```

### 步骤3：本地开发
在VS Code或任何编辑器中修改代码：

```bash
# 后端开发
backend/
├── src/
│   ├── api/
│   ├── models/
│   └── core/
└── main.py

# 前端开发
frontend/
├── src/
│   ├── app/
│   ├── components/
│   └── lib/
└── package.json
```

**文件会自动同步到容器**，无需手动操作！

### 步骤4：浏览器验证
- **前端界面**：http://localhost:3000
- **API文档**：http://localhost:8000/docs
- **数据库管理**：http://localhost:5050
  - 邮箱：admin@payroll.com
  - 密码：admin123

## 🔄 开发工作流详解

### 典型开发场景：实现"薪资计算"功能

#### 1. 需求分析
```markdown
# 阅读 specs/spec.md
## 薪资计算模块
- 输入：员工ID、月份、绩效系数
- 输出：基本工资、奖金、扣除、实发工资
- 计算规则：...
```

#### 2. 设计评审
```markdown
# 查看 specs/contracts/api.md
POST /api/employees/{id}/calculate-salary
{
  "month": "2025-01",
  "performance_factor": 1.2
}
```

#### 3. 编写测试
```python
# backend/tests/test_salary_calculation.py
def test_calculate_salary_basic():
    # TDD：先写测试
    pass
```

#### 4. 编码实现
```python
# backend/src/api/salary.py
@router.post("/employees/{id}/calculate-salary")
async def calculate_salary(id: int, request: SalaryRequest):
    # 实现逻辑
    pass
```

**修改代码后**：
- 容器自动检测文件变化
- FastAPI自动重启（约0.5秒）
- 浏览器刷新查看结果

#### 5. 数据库操作
通过pgAdmin (http://localhost:5050)：
1. 连接数据库（已预配置）
2. 查看表结构
3. 执行SQL查询验证数据

## 📊 服务访问地址

| 服务 | 地址 | 用途 | 登录信息 |
|------|------|------|----------|
| 前端应用 | http://localhost:3000 | Next.js开发服务器 | - |
| 后端API | http://localhost:8000 | FastAPI应用 | - |
| API文档 | http://localhost:8000/docs | Swagger UI | - |
| pgAdmin | http://localhost:5050 | 数据库管理 | admin@payroll.com / admin123 |

## 🛠️ 常用命令

### 环境管理
```bash
# 启动所有服务
bash start-dev.sh

# 后台启动
docker-compose -f docker-compose.dev.yml up -d

# 停止所有服务
docker-compose -f docker-compose.dev.yml down

# 重启所有服务
docker-compose -f docker-compose.dev.yml restart

# 查看运行状态
docker-compose -f docker-compose.dev.yml ps

# 查看实时日志
docker-compose -f docker-compose.dev.yml logs -f
```

### 单个服务管理
```bash
# 重启后端
docker-compose -f docker-compose.dev.yml restart backend

# 查看前端日志
docker-compose -f docker-compose.dev.yml logs -f frontend

# 进入后端容器
docker exec -it payroll-backend-dev bash

# 进入前端容器
docker exec -it payroll-frontend-dev sh
```

### 数据库操作
```bash
# 进入PostgreSQL容器
docker exec -it payroll-postgres-dev psql -U payroll -d payrollmaster

# 备份数据库
docker exec -it payroll-postgres-dev pg_dump -U payroll payrollmaster > backup.sql

# 恢复数据库
docker exec -i payroll-postgres-dev psql -U payroll payrollmaster < backup.sql
```

### 清理环境
```bash
# 停止并删除数据卷（谨慎使用）
docker-compose -f docker-compose.dev.yml down -v

# 完全清理（删除所有容器、镜像、数据）
docker-compose -f docker-compose.dev.yml down -v --rmi all --remove-orphans

# 清理未使用的镜像
docker image prune -a

# 清理未使用的卷
docker volume prune
```

## 🔍 故障排除

### 端口被占用
```bash
# 检查端口占用
netstat -ano | findstr :3000
netstat -ano | findstr :8000
netstat -ano | findstr :5432

# 停止占用端口的进程
taskkill /PID <PID> /F
```

### 容器启动失败
```bash
# 查看所有服务日志
docker-compose -f docker-compose.dev.yml logs

# 查看特定服务日志
docker-compose -f docker-compose.dev.yml logs backend

# 重建镜像
docker-compose -f docker-compose.dev.yml up --build --force-recreate
```

### 数据库连接失败
```bash
# 检查PostgreSQL状态
docker-compose -f docker-compose.dev.yml ps postgres

# 测试数据库连接
docker exec -it payroll-postgres-dev pg_isready -U payroll
```

### 热重载不生效
```bash
# 检查卷挂载
docker-compose -f docker-compose.dev.yml config

# 重启相关服务
docker-compose -f docker-compose.dev.yml restart backend frontend
```

### Docker Desktop未运行
- 启动Docker Desktop应用
- 等待Docker图标变为运行状态
- 确保有足够内存（建议8GB以上）

## 📁 文件同步机制

### 卷挂载配置
```yaml
# docker-compose.dev.yml
volumes:
  - ./backend:/app        # 后端代码（双向同步）
  - ./frontend:/app       # 前端代码（双向同步）
  - postgres_dev_data:/var/lib/postgresql/data  # 数据库数据
  - redis_dev_data:/data  # Redis数据
```

### 同步特性
- **本地 → 容器**：文件修改立即同步
- **容器 → 本地**：容器内生成的文件同步到本地
- **实时性**：通常<1秒延迟
- **一致性**：双向同步确保文件一致

## 🔐 数据库连接信息

### Docker PostgreSQL
- **主机**：postgres (容器内) / localhost (外部)
- **端口**：5432
- **数据库**：payrollmaster
- **用户**：payroll
- **密码**：payroll123

### 本地PostgreSQL
- **主机**：localhost
- **端口**：5432
- **用户**：postgres
- **数据库**：postgres
- **状态**：需要密码（推荐使用Docker版本）

## 🎓 最佳实践

### 1. 开发习惯
- **每日开始**：`bash start-dev.sh` 启动环境
- **代码修改**：使用本地编辑器，自动同步
- **实时验证**：浏览器随时查看效果
- **每日结束**：清理环境，释放资源

### 2. 文档管理
- **需求文档**：本地存储，支持离线访问
- **API文档**：通过 http://localhost:8000/docs 查看
- **设计文档**：定期同步到Git仓库
- **开发笔记**：本地记录，便于搜索

### 3. 调试技巧
- **后端调试**：查看容器日志 `docker-compose logs backend`
- **前端调试**：浏览器开发者工具 (F12)
- **数据库调试**：pgAdmin界面或SQL查询
- **网络调试**：Postman测试API接口

### 4. 性能优化
- **减少重启**：批量修改代码，一次性测试
- **合理分配**：确保Docker Desktop有足够资源
- **及时清理**：定期清理未使用的镜像和卷
- **监控资源**：使用 `docker stats` 查看资源使用

## 💡 效率提升技巧

### 1. 浏览器书签
将以下地址保存为书签：
- http://localhost:3000 (前端)
- http://localhost:8000/docs (API文档)
- http://localhost:5050 (pgAdmin)

### 2. 终端别名
在 `.bashrc` 或 `.zshrc` 中添加：
```bash
alias pm-start='bash start-dev.sh'
alias pm-stop='docker-compose -f docker-compose.dev.yml down'
alias pm-logs='docker-compose -f docker-compose.dev.yml logs -f'
alias pm-restart='docker-compose -f docker-compose.dev.yml restart'
```

### 3. VS Code扩展
推荐安装：
- Docker
- Remote - Containers
- PostgreSQL
- Thunder Client (API测试)

### 4. 快速操作
```bash
# 一键启动 + 打开浏览器
bash start-dev.sh && start http://localhost:3000

# 一键查看所有日志
docker-compose -f docker-compose.dev.yml logs -f --tail=100
```

## 📚 相关文档

- [环境配置指南](./setup.md) - 环境要求和安装说明
- [Docker开发指南](./docker.md) - Docker开发环境详细指南
- [项目宪章](../.specify/memory/constitution.md) - 开发最高准则和规范

## 🆘 获取帮助

### 文档查阅
1. 首先查看本指南的故障排除部分
2. 查看 [Docker开发指南](./docker.md)
3. 查看项目宪章 `../.specify/memory/constitution.md`

### 日志分析
```bash
# 查看所有服务日志
docker-compose -f docker-compose.dev.yml logs

# 实时查看日志
docker-compose -f docker-compose.dev.yml logs -f

# 查看特定服务日志
docker-compose -f docker-compose.dev.yml logs backend
docker-compose -f docker-compose.dev.yml logs frontend
docker-compose -f docker-compose.dev.yml logs postgres
```

### 环境重置
```bash
# 停止所有服务
docker-compose -f docker-compose.dev.yml down -v

# 重新启动
bash start-dev.sh
```

### 社区资源
- [Docker官方文档](https://docs.docker.com/)
- [FastAPI文档](https://fastapi.tiangolo.com/)
- [Next.js文档](https://nextjs.org/docs)

---

## ✅ 快速检查清单

开始开发前，确认以下项目：

- [ ] Docker Desktop 已启动并运行
- [ ] 执行 `bash start-dev.sh` 成功启动所有服务
- [ ] 浏览器可以访问 http://localhost:3000
- [ ] API文档可以访问 http://localhost:8000/docs
- [ ] pgAdmin可以访问 http://localhost:5050
- [ ] 本地编辑器可以正常修改代码
- [ ] 代码修改后能在浏览器中看到效果

---

**Happy Coding! 🎉**

采用混合开发模式，享受本地编辑的便捷和容器化开发的一致性！