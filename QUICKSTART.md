# PayrollMaster 快速启动指南

## 📦 环境状态

### ✅ 已完成的安装
- **Python 3.12.3** - 虚拟环境位于 `backend/venv/`
- **Node.js v22.20.0** + npm 11.6.1
- **PostgreSQL 18.0** - 可通过 pgAdmin 管理
- **Git 2.51.2**
- **Docker 28.4.0**
- **Next.js 14.2.18** (全局)
- **Tailwind CSS 3.4.17** (全局)
- **前端依赖** - 已安装到 `frontend/`

### 🚧 正在安装
- **后端 Python 包** - 正在从精简版 requirements 安装 20 个核心包
  - FastAPI, SQLModel, SQLAlchemy, psycopg2-binary
  - uvicorn, redis, python-jose, passlib
  - 以及其他必需包...

## 🚀 启动步骤

### 1. 等待 Python 包安装完成
```bash
# 检查安装状态
cd backend
source venv/Scripts/activate
pip list | grep fastapi
```

### 2. 创建数据库
使用 pgAdmin 或命令行：
```bash
# 使用 psql
psql -U postgres
CREATE DATABASE payrollmaster;
\q
```

### 3. 启动后端服务
```bash
cd backend
source venv/Scripts/activate
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```
访问: http://localhost:8000/docs

### 4. 启动前端服务 (新终端)
```bash
cd frontend
npm run dev
```
访问: http://localhost:3000

### 5. 运行测试
```bash
cd backend
source venv/Scripts/activate
pytest tests/ -v
```

## 📁 项目结构
```
PayrollMaster/
├── backend/                 # FastAPI 后端
│   ├── src/
│   │   ├── core/           # 配置和数据库
│   │   ├── models/         # 数据模型
│   │   └── api/            # API 路由
│   ├── tests/              # 测试
│   └── main.py             # 应用入口
├── frontend/               # Next.js 前端
│   ├── src/app/            # 页面和组件
│   ├── public/             # 静态文件
│   └── package.json        # 依赖
├── .env                    # 环境变量
└── docker-compose.yml      # Docker 配置
```

## 🔧 重要文件
- **`.env`** - 环境变量配置
- **`backend/requirements-minimal.txt`** - Python 依赖 (20个核心包)
- **`frontend/package.json`** - Node.js 依赖

## 📚 pgAdmin 使用
- 启动: 开始菜单 → PostgreSQL → pgAdmin
- 默认端口: 5050
- 连接信息:
  - 主机: localhost
  - 端口: 5432
  - 用户名: postgres
  - 密码: (安装时设置的密码)

## 🐛 故障排除

### Python 包安装失败
```bash
# 重试安装
cd backend
source venv/Scripts/activate
pip install -r requirements-minimal.txt --timeout 300
```

### 端口被占用
```bash
# 查看端口
netstat -ano | findstr :8000
netstat -ano | findstr :3000
```

### 数据库连接失败
- 检查 PostgreSQL 服务是否运行
- 验证 `.env` 文件中的数据库连接字符串
- 确认数据库存在

## 📞 服务地址
- **后端 API**: http://localhost:8000
- **API 文档**: http://localhost:8000/docs
- **前端应用**: http://localhost:3000
- **pgAdmin**: http://localhost:5050

## 🎯 下一步
安装完成后，您可以：
1. 查看 API 文档: http://localhost:8000/docs
2. 访问前端应用: http://localhost:3000
3. 开始开发 PayrollMaster 功能
4. 使用 pgAdmin 管理数据库
