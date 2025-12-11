#!/bin/bash

echo "=========================================="
echo "   PayrollMaster 环境检查脚本"
echo "=========================================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查函数
check_version() {
    local name=$1
    local current=$2
    local required=$3
    local is_greater=$4
    
    if [ "$is_greater" = "true" ]; then
        if [ "$current" -ge "$required" ]; then
            echo -e "${GREEN}✅ $name${NC}: $current (要求: $required+)"
            return 0
        else
            echo -e "${RED}❌ $name${NC}: $current (要求: $required+)"
            return 1
        fi
    else
        echo -e "${GREEN}✅ $name${NC}: $current"
        return 0
    fi
}

# 检查组件
echo "📋 检查核心组件..."
check_version "Python" "3.12" "3.11" "true" || PYTHON_OK=1
check_version "Node.js" "22.20.0" "16.0.0" "true" || NODE_OK=1
check_version "npm" "11.6.1" "9.0.0" "true" || NPM_OK=1
check_version "PostgreSQL" "18.0" "12.0" "true" || POSTGRES_OK=1
check_version "Git" "2.51.2" "2.0.0" "true" || GIT_OK=1

echo ""
echo "🔧 检查工具..."
command -v docker &> /dev/null && echo -e "${GREEN}✅ Docker${NC}: 已安装" || echo -e "${YELLOW}⚠️  Docker${NC}: 未安装"
command -v redis-server &> /dev/null && echo -e "${GREEN}✅ Redis${NC}: 已安装" || echo -e "${YELLOW}⚠️  Redis${NC}: 未安装"

echo ""
echo "🐍 检查Python包..."
pip show fastapi &> /dev/null && echo -e "${GREEN}✅ FastAPI${NC}: 已安装" || echo -e "${YELLOW}⚠️  FastAPI${NC}: 未安装"
pip show sqlmodel &> /dev/null && echo -e "${GREEN}✅ SQLModel${NC}: 已安装" || echo -e "${YELLOW}⚠️  SQLModel${NC}: 未安装"
pip show pytest &> /dev/null && echo -e "${GREEN}✅ pytest${NC}: 已安装" || echo -e "${YELLOW}⚠️  pytest${NC}: 未安装"

echo ""
echo "⚛️  检查Node.js包..."
npm list -g next &> /dev/null && echo -e "${GREEN}✅ Next.js${NC}: 已安装" || echo -e "${YELLOW}⚠️  Next.js${NC}: 未安装"
npm list -g tailwindcss &> /dev/null && echo -e "${GREEN}✅ Tailwind CSS${NC}: 已安装" || echo -e "${YELLOW}⚠️  Tailwind CSS${NC}: 未安装"

echo ""
echo "🗄️  检查数据库连接..."
if pg_isready -h localhost -p 5432 &> /dev/null; then
    echo -e "${GREEN}✅ PostgreSQL${NC}: 端口5432可访问"
else
    echo -e "${RED}❌ PostgreSQL${NC}: 端口5432无法访问"
fi

if command -v redis-cli &> /dev/null && redis-cli ping &> /dev/null; then
    echo -e "${GREEN}✅ Redis${NC}: 端口6379可访问"
else
    echo -e "${RED}❌ Redis${NC}: 端口6379无法访问"
fi

echo ""
echo "📁 检查项目结构..."
[ -d "backend" ] && echo -e "${GREEN}✅ backend目录${NC}: 存在" || echo -e "${YELLOW}⚠️  backend目录${NC}: 不存在"
[ -d "frontend" ] && echo -e "${GREEN}✅ frontend目录${NC}: 存在" || echo -e "${YELLOW}⚠️  frontend目录${NC}: 不存在"
[ -f ".env" ] && echo -e "${GREEN}✅ .env文件${NC}: 存在" || echo -e "${YELLOW}⚠️  .env文件${NC}: 不存在"

echo ""
echo "=========================================="
echo "💡 建议操作:"
echo "1. 运行: bash setup-environment.sh"
echo "2. 或使用: docker-compose up -d"
echo "3. 查看: ENVIRONMENT_SETUP.md"
echo "=========================================="
