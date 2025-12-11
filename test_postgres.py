import psycopg2
import time

print("=" * 50)
print("测试 PostgreSQL 连接")
print("=" * 50)

# 测试本地 PostgreSQL
print("\n1. 测试本地 PostgreSQL:")
print("   主机: localhost")
print("   端口: 5432")
print("   用户: postgres")

try:
    conn = psycopg2.connect(
        host='localhost',
        port=5432,
        user='postgres',
        password='',  # 空密码
        database='postgres'
    )
    cursor = conn.cursor()
    cursor.execute('SELECT version();')
    version = cursor.fetchone()
    print(f"   ✅ 连接成功!")
    print(f"   版本: {version[0]}")
    cursor.close()
    conn.close()
except Exception as e:
    print(f"   ❌ 连接失败")
    print(f"   错误: {e}")

# 测试 Docker PostgreSQL (如果容器在运行)
print("\n2. 测试 Docker PostgreSQL:")
print("   主机: localhost")
print("   端口: 5432")
print("   用户: payroll")
print("   密码: payroll123")
print("   数据库: payrollmaster")

try:
    conn = psycopg2.connect(
        host='localhost',
        port=5432,
        user='payroll',
        password='payroll123',
        database='payrollmaster'
    )
    cursor = conn.cursor()
    cursor.execute('SELECT version();')
    version = cursor.fetchone()
    print(f"   ✅ 连接成功!")
    print(f"   版本: {version[0]}")
    cursor.close()
    conn.close()
except Exception as e:
    print(f"   ❌ 连接失败 (Docker 容器可能未启动)")
    print(f"   错误: {e}")

print("\n" + "=" * 50)
print("测试完成")
print("=" * 50)
