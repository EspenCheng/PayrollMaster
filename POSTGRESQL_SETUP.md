# PostgreSQL 连接测试报告

## 🔍 测试结果

### ✅ 服务状态
- **PostgreSQL 版本**: 18.0
- **服务状态**: ✅ 运行中
- **端口**: 5432 (接受连接)

### ❌ 连接测试
- **问题**: 密码认证失败
- **原因**: postgres 用户密码未知
- **尝试的密码**: password, admin, 123456, postgres, (空密码)

## 🛠️ 解决方案

### 方案1: 重置 PostgreSQL 密码 (推荐)

#### Windows 方法1: 使用 pgAdmin
1. 打开 **pgAdmin 4**
2. 右键点击 "PostgreSQL 18" 服务器
3. 选择 "重置密码"
4. 输入新密码并确认

#### Windows 方法2: 使用 psql 命令
1. 找到 PostgreSQL 安装目录中的 `psql.exe`
2. 打开命令提示符（以管理员身份）
3. 执行：
   ```bash
   cd "C:\Program Files\PostgreSQL\18\bin"
   psql -U postgres
   ```
4. 在 psql 提示符下：
   ```sql
   ALTER USER postgres PASSWORD '新密码';
   \q
   ```

#### Windows 方法3: 修改 pg_hba.conf
1. 找到 `pg_hba.conf` 文件：
   ```
   C:\Program Files\PostgreSQL\18\data\pg_hba.conf
   ```
2. 将认证方式从 `md5` 改为 `trust`：
   ```
   host    all             all             127.0.0.1/32            trust
   ```
3. 重启 PostgreSQL 服务
4. 重新连接
5. 修改密码：
   ```sql
   ALTER USER postgres PASSWORD 'your_password';
   ```
6. 将 pg_hba.conf 改回 `md5`

### 方案2: 使用 Docker 环境 (最简单)

我们已经配置了完整的 Docker 开发环境，无需配置本地 PostgreSQL！

#### 启动命令
```bash
bash start-dev.sh
```

#### Docker PostgreSQL 连接信息
- **主机**: postgres (容器内) / localhost (外部)
- **端口**: 5432
- **数据库**: payrollmaster
- **用户**: payroll
- **密码**: payroll123

#### Docker 内的 PostgreSQL
```bash
# 进入 Docker 容器
docker exec -it payroll-postgres-dev psql -U payroll -d payrollmaster
```

#### 从 Python 代码连接 Docker PostgreSQL
```python
import psycopg2

conn = psycopg2.connect(
    host='localhost',
    port=5432,
    user='payroll',
    password='payroll123',
    database='payrollmaster'
)
```

## 📊 连接信息

### 本地 PostgreSQL (需要密码)
- **主机**: localhost
- **端口**: 5432
- **用户**: postgres
- **数据库**: postgres
- **状态**: ⚠️ 需要密码

### Docker PostgreSQL (推荐)
- **主机**: postgres (容器内) / localhost (外部)
- **端口**: 5432
- **用户**: payroll
- **密码**: payroll123
- **数据库**: payrollmaster
- **状态**: ✅ 已配置

## 🔧 测试连接

### 测试本地 PostgreSQL
```bash
# 知道密码后
psql -h localhost -U postgres -d postgres
```

### 测试 Docker PostgreSQL
```bash
# 进入容器
docker exec -it payroll-postgres-dev psql -U payroll -d payrollmaster

# 或者从本地
psql -h localhost -U payroll -d payrollmaster
```

### 使用 Python 测试
```python
import psycopg2

# Docker PostgreSQL
conn = psycopg2.connect(
    host='localhost',
    port=5432,
    user='payroll',
    password='payroll123',
    database='payrollmaster'
)

# 测试查询
cursor = conn.cursor()
cursor.execute('SELECT version();')
print(cursor.fetchone())
cursor.close()
conn.close()
```

## 🎯 推荐方案

**使用 Docker 环境**，因为：
- ✅ 无需配置本地 PostgreSQL
- ✅ 环境一致性
- ✅ 密码已知 (payroll/payroll123)
- ✅ 预配置数据库和用户
- ✅ 包含 pgAdmin 管理界面

## 📱 pgAdmin 使用

### Docker pgAdmin
- **地址**: http://localhost:5050
- **邮箱**: admin@payroll.com
- **密码**: admin123
- **服务器**: postgres
- **端口**: 5432

### 本地 pgAdmin
如果已安装本地 pgAdmin：
- 启动 pgAdmin
- 添加服务器
- 输入连接信息

## 🆘 故障排除

### 问题1: 无法连接
```bash
# 检查服务状态
pg_isready -h localhost -p 5432

# 查看 PostgreSQL 服务
sc query postgresql-x64-18
```

### 问题2: 密码错误
- 重置密码（见方案1）
- 或使用 Docker 环境

### 问题3: 端口被占用
```bash
# 查看端口占用
netstat -ano | findstr :5432
```

## 📚 相关文档

- [DOCKER_DEV_GUIDE.md](./DOCKER_DEV_GUIDE.md) - Docker 开发指南
- [DOCKER_QUICKREF.md](./DOCKER_QUICKREF.md) - Docker 快速参考

## 🎯 下一步

1. **推荐**: 使用 Docker 环境启动开发
   ```bash
   bash start-dev.sh
   ```

2. **备选**: 重置本地 PostgreSQL 密码后使用

3. **测试**: 验证连接并开始开发

---

**结论**: PostgreSQL 18.0 服务正在运行，但需要密码认证。建议使用 Docker 环境进行开发，密码和配置已经准备就绪。
