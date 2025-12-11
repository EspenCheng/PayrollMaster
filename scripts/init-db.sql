-- PayrollMaster 数据库初始化脚本

-- 创建数据库用户 (如果不存在)
CREATE USER payroll WITH PASSWORD 'payroll123';

-- 创建数据库 (如果不存在)
CREATE DATABASE payrollmaster OWNER payroll;

-- 连接到数据库
\c payrollmaster;

-- 授予权限
GRANT ALL PRIVILEGES ON DATABASE payrollmaster TO payroll;

-- 创建扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 创建注释
COMMENT ON DATABASE payrollmaster IS 'PayrollMaster 企业薪酬管理系统';
