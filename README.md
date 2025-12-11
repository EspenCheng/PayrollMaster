# PayrollMaster 薪资管理系统

一个现代化的薪资计算和管理系统，基于FastAPI + Next.js构建。

## 🚀 技术栈

### 后端
- **Python 3.11+** - 基于FastAPI 0.104+
- **SQLModel** - Pydantic + SQLAlchemy
- **PostgreSQL** - 关系型数据库
- **Redis** - 缓存和会话存储

### 前端
- **Next.js 14+** (App Router)
- **React 18+**
- **Tailwind CSS 3.4+**
- **TypeScript**

### 开发工具
- **Docker & Docker Compose** - 容器化部署
- **pgAdmin** - PostgreSQL管理工具
- **pytest** - 测试框架
- **Ruff** - 代码检查

## 📦 项目结构

```
PayrollMaster/
├── backend/                 # FastAPI 后端
│   ├── src/
│   │   ├── core/           # 配置和数据库
│   │   ├── models/         # 数据模型
│   │   ├── schemas/        # Pydantic模型
│   │   ├── api/            # API路由
│   │   └── services/       # 业务逻辑
│   ├── tests/              # 测试文件
│   └── main.py             # 应用入口
├── frontend/               # Next.js 前端
│   ├── src/app/            # App Router页面
│   ├── src/components/     # React组件
│   └── src/lib/            # 工具库
├── docs/                   # 项目文档
├── specs/                  # 需求规格说明
├── scripts/                # 工具脚本
└── docker-compose.yml      # Docker配置
```

## 🛠️ 快速开始

### 环境要求
- Python 3.11+
- Node.js 18+
- PostgreSQL 14+
- Docker & Docker Compose

### 安装步骤

1. **克隆仓库**
   ```bash
   git clone https://github.com/EspenCheng/PayrollMaster.git
   cd PayrollMaster
   ```

2. **启动开发环境**
   ```bash
   # 使用Docker Compose
   docker-compose up -d

   # 或使用脚本
   ./start-dev.sh
   ```

3. **访问应用**
   - 前端应用: http://localhost:3000
   - API文档: http://localhost:8000/docs
   - pgAdmin: http://localhost:5050

详细安装说明请参考 [QUICKSTART.md](./QUICKSTART.md)

## 📚 文档

- [快速启动指南](./QUICKSTART.md) - 快速搭建开发环境
- [开发工作流](./docs/DEVELOPMENT_WORKFLOW.md) - 开发规范和流程
- [环境配置](./ENVIRONMENT_SETUP.md) - 环境变量说明
- [Docker开发指南](./DOCKER_DEV_GUIDE.md) - Docker使用说明

## 🎯 功能特性

- ✅ 薪资计算引擎
- ✅ 员工信息管理
- ✅ Excel数据导入/导出
- ✅ 报表生成
- ✅ 权限管理
- ✅ API文档完整

## 🧪 测试

```bash
# 运行后端测试
cd backend
pytest tests/ -v

# 代码检查
ruff check .
```

## 📄 许可证

本项目采用 MIT 许可证。

## 👥 贡献

欢迎提交 Pull Request 和 Issue！

## 📧 联系方式

如有问题，请通过 GitHub Issues 联系我们。
