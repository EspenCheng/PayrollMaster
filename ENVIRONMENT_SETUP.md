# PayrollMaster 环境配置指南

## 📊 环境检查结果

### ✅ 符合要求
- **Python**: 3.12.3 (要求: 3.11+) ✅
- **Node.js**: v22.20.0 (要求: 16+) ✅
- **npm**: 11.6.1 ✅
- **PostgreSQL**: 18.0 (要求: 12+) ✅
- **Git**: 2.51.2 ✅
- **Docker**: 28.4.0 ✅
- **Playwright**: 1.56.1 ✅

### ❌ 需要安装
- **Redis**: 用于缓存
- **Python包**: FastAPI, SQLModel, SQLAlchemy, pytest
- **Node包**: Next.js, Tailwind CSS

### ⚠️ 需要配置
- **PostgreSQL数据库**: 需要创建数据库和用户
- **项目结构**: 需要创建backend和frontend目录

## 🚀 快速开始

### 方案1: Docker沙箱环境 (推荐)

```bash
# 1. 启动所有服务
docker-compose up -d

# 2. 检查服务状态
docker-compose ps

# 3. 查看日志
docker-compose logs -f

# 4. 停止服务
docker-compose down
```

服务地址:
- 后端API: http://localhost:8000
- 前端应用: http://localhost:3000
- PostgreSQL: localhost:5432
- Redis: localhost:6379

### 方案2: 本地开发环境

#### 步骤1: 创建项目结构
```bash
mkdir -p backend/{src/{models,services,api,core},tests,scripts}
mkdir -p frontend/{src/{components,pages,services},tests,public}
```

#### 步骤2: 设置后端
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

#### 步骤3: 设置前端
```bash
cd frontend
npx create-next-app@latest . --typescript --tailwind --app
npm install @tanstack/react-query axios zustand
```

#### 步骤4: 配置数据库
```bash
# 创建数据库
createdb payrollmaster

# 创建用户 (可选)
psql payrollmaster
```

#### 步骤5: 启动服务
```bash
# 后端
cd backend && uvicorn main:app --reload

# 前端 (新终端)
cd frontend && npm run dev
```

## 🔧 环境变量

创建 `.env` 文件:
```env
DATABASE_URL=postgresql://postgres:password@localhost:5432/payrollmaster
REDIS_URL=redis://localhost:6379/0
JWT_SECRET_KEY=your-secret-key
API_HOST=localhost
API_PORT=8000
NEXT_PUBLIC_API_URL=http://localhost:8000/api/v1
```

## 📦 依赖清单

### 后端依赖 (backend/requirements.txt)
```
fastapi==0.104.1
sqlmodel==0.0.8
sqlalchemy==2.0.23
psycopg2-binary==2.9.9
pytest==7.4.3
uvicorn==0.24.0
python-multipart==0.0.6
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
redis==5.0.1
alembic==1.13.1
openpyxl==3.1.2
pandas==2.1.4
```

### 前端依赖 (frontend/package.json)
```json
{
  "dependencies": {
    "next": "14.0.0",
    "react": "^18.2.0",
    "tailwindcss": "^3.3.0",
    "@tanstack/react-query": "^5.0.0",
    "axios": "^1.6.0",
    "zustand": "^4.4.0"
  },
  "devDependencies": {
    "@testing-library/react": "^13.4.0",
    "jest": "^29.7.0",
    "typescript": "^5.3.0"
  }
}
```

## 🧪 测试环境

### 后端测试
```bash
cd backend
pytest tests/ -v --cov=src
```

### 前端测试
```bash
cd frontend
npm test
```

### 端到端测试
```bash
# 安装Playwright
npx playwright install

# 运行测试
npx playwright test
```

## 🔍 故障排除

### PostgreSQL连接失败
- 检查PostgreSQL服务是否运行
- 验证用户名和密码
- 确保端口5432未被占用

### Redis连接失败
- 启动Redis服务: `redis-server`
- 检查端口6379

### 端口占用
```bash
# 查看端口占用
netstat -ano | findstr :8000
netstat -ano | findstr :3000

# 杀死进程
taskkill /PID <PID> /F
```

## 📚 更多信息

- [FastAPI文档](https://fastapi.tiangolo.com/)
- [Next.js文档](https://nextjs.org/docs)
- [SQLModel文档](https://sqlmodel.tiangolo.com/)
- [PostgreSQL文档](https://www.postgresql.org/docs/)
