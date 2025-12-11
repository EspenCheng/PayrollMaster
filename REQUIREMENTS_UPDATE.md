# 依赖包安装问题解决方案

## 问题描述
初始的 `requirements.txt` 包含了 120+ 个包（包括很多不必要的包如 matplotlib、PyQt5、pandasgui 等），导致：
- 下载时间过长
- 网络超时错误
- 安装失败

## 解决方案
创建了精简版 `requirements-minimal.txt`，只包含 PayrollMaster 必需的核心包：

### 核心框架
- **fastapi** (0.124.0) - Web 框架
- **uvicorn** (0.38.0) - ASGI 服务器

### 数据库
- **sqlmodel** (0.0.27) - ORM (SQLAlchemy + Pydantic)
- **sqlalchemy** (2.0.36) - SQL 工具包
- **psycopg2-binary** (2.9.11) - PostgreSQL 适配器

### 安全与认证
- **python-jose** (3.5.0) - JWT 令牌处理
- **passlib** (1.7.4) - 密码哈希
- **python-multipart** (0.0.20) - 文件上传支持

### 配置与缓存
- **python-dotenv** (1.2.1) - 环境变量管理
- **redis** (5.0.1) - 缓存系统

### 数据库迁移
- **alembic** (1.14.0) - 数据库迁移工具

### Excel 处理
- **openpyxl** (3.1.2) - Excel 文件读写

### 数据处理
- **pandas** (2.2.2) - 数据分析

### 测试
- **pytest** (9.0.2) - 测试框架
- **pytest-asyncio** (1.3.0) - 异步测试支持
- **httpx** (0.28.1) - HTTP 客户端

### 其他
- **starlette** (0.50.0) - CORS 支持
- **email-validator** (2.2.0) - 邮箱验证

## 总计
从 120+ 个包减少到 **20 个核心包**，大幅减少安装时间和网络负担。

## 安装命令
```bash
cd backend
source venv/Scripts/activate
pip install -r requirements-minimal.txt
```

## 后续
如果需要额外的包，可以单独安装，例如：
```bash
pip install package_name
```
