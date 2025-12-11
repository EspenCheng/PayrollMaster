#!/bin/bash

echo "🚀 启动 PayrollMaster 开发环境 (Docker)"
echo "=========================================="
echo ""

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker 未运行，请启动 Docker Desktop"
    exit 1
fi

echo "✅ Docker 已运行"
echo ""

# 启动服务
echo "🔄 正在启动服务..."
echo "   - PostgreSQL (端口 5432)"
echo "   - Redis (端口 6379)"
echo "   - pgAdmin (端口 5050)"
echo "   - Backend API (端口 8000)"
echo "   - Frontend (端口 3000)"
echo ""

# 使用开发配置启动
docker-compose -f docker-compose.dev.yml up --build

echo ""
echo "✅ 开发环境已启动！"
echo ""
echo "📱 访问地址:"
echo "   - 前端应用:  http://localhost:3000"
echo "   - 后端 API:  http://localhost:8000"
echo "   - API 文档:  http://localhost:8000/docs"
echo "   - pgAdmin:   http://localhost:5050"
echo ""
echo "💡 提示:"
echo "   - 修改代码后会自动热重载"
echo "   - 按 Ctrl+C 停止所有服务"
echo "   - 使用 'docker-compose -f docker-compose.dev.yml down' 完全清理"
echo ""
