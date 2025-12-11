#!/bin/bash
set -e

echo "🚀 开始设置PayrollMaster开发环境..."

# 1. 创建项目结构
echo "📁 创建项目目录结构..."
mkdir -p backend/{src/{models,services,api,core},tests,scripts}
mkdir -p frontend/{src/{components,pages,services},tests,public}
mkdir -p docs

# 2. 安装Redis（Windows/Mac/Linux）
echo "📦 安装Redis..."
if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y redis-server
elif command -v brew &> /dev/null; then
    brew install redis
else
    echo "⚠️  请手动安装Redis或使用Docker"
fi

# 3. 设置Python虚拟环境
echo "🐍 设置Python虚拟环境..."
cd backend
python -m venv venv
source venv/bin/activate 2>/dev/null || source venv/Scripts/activate
pip install --upgrade pip

# 安装后端依赖
cat > requirements.txt << 'EOF'
fastapi==0.104.1
sqlmodel==0.0.8
sqlalchemy==2.0.23
psycopg2-binary==2.9.9
pytest==7.4.3
pytest-asyncio==0.21.1
uvicorn==0.24.0
python-multipart==0.0.6
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-dotenv==1.0.0
redis==5.0.1
alembic==1.13.1
openpyxl==3.1.2
pandas==2.1.4
EOF

pip install -r requirements.txt
echo "✅ 后端依赖安装完成"
cd ..

# 4. 初始化Next.js项目
echo "⚛️  初始化Next.js项目..."
cd frontend
npx create-next-app@latest . --typescript --tailwind --app --no-src-dir --import-alias "@/*"
npm install @tanstack/react-query axios zustand
npm install -D @testing-library/react @testing-library/jest-dom jest
echo "✅ 前端项目初始化完成"
cd ..

# 5. 创建环境变量模板
cat > .env.example << 'EOF'
# 数据库配置
DATABASE_URL=postgresql://postgres:password@localhost:5432/payrollmaster

# Redis配置
REDIS_URL=redis://localhost:6379/0

# JWT配置
JWT_SECRET_KEY=your-secret-key-change-in-production
JWT_ALGORITHM=HS256
JWT_EXPIRE_MINUTES=60

# API配置
API_HOST=localhost
API_PORT=8000

# 前端配置
NEXT_PUBLIC_API_URL=http://localhost:8000/api/v1
EOF

echo "✅ 环境设置完成！"
echo ""
echo "📝 下一步操作："
echo "1. 复制 .env.example 为 .env 并配置数据库密码"
echo "2. 创建PostgreSQL数据库: createdb payrollmaster"
echo "3. 启动Redis: redis-server"
echo "4. 运行数据库迁移: cd backend && alembic upgrade head"
echo "5. 启动开发服务器:"
echo "   - 后端: cd backend && uvicorn main:app --reload"
echo "   - 前端: cd frontend && npm run dev"
