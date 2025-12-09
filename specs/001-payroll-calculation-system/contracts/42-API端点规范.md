# API端点规范 - PayrollMaster薪资自动核算系统

## 概述

本文档定义了PayrollMaster系统的REST API端点规范，基于OpenAPI 3.0标准。使用FastAPI框架实现，所有端点都支持JSON格式数据传输。

## 基础信息

- **Base URL**: `http://localhost:8000/api/v1`
- **认证方式**: JWT Bearer Token
- **内容类型**: `application/json`
- **字符编码**: UTF-8

## 通用响应格式

### 成功响应

```json
{
  "success": true,
  "data": { ... },
  "message": "操作成功",
  "timestamp": "2025-12-09T10:30:00Z"
}
```

### 错误响应

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "数据验证失败",
    "details": {
      "field": "email",
      "reason": "邮箱格式不正确"
    }
  },
  "timestamp": "2025-12-09T10:30:00Z"
}
```

## 1. 用户认证 (Authentication)

### 1.1 用户登录

**端点**: `POST /auth/login`

**请求体**:
```json
{
  "username": "admin",
  "password": "password123"
}
```

**响应**:
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "bearer",
    "expires_in": 3600,
    "user": {
      "id": 1,
      "username": "admin",
      "role": "admin",
      "full_name": "系统管理员"
    }
  }
}
```

**状态码**:
- `200`: 登录成功
- `401`: 用户名或密码错误
- `422`: 请求参数验证失败

### 1.2 用户注销

**端点**: `POST /auth/logout`

**请求头**: `Authorization: Bearer {token}`

**响应**:
```json
{
  "success": true,
  "message": "注销成功"
}
```

### 1.3 获取当前用户信息

**端点**: `GET /auth/me`

**响应**:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "username": "admin",
    "email": "admin@company.com",
    "role": "admin",
    "full_name": "系统管理员",
    "last_login": "2025-12-09T10:00:00Z"
  }
}
```

## 2. 员工管理 (Employees)

### 2.1 获取员工列表

**端点**: `GET /employees`

**查询参数**:
- `page`: 页码 (默认: 1)
- `size`: 每页数量 (默认: 20, 最大: 100)
- `department`: 部门筛选
- `search`: 搜索关键词（姓名或工号）

**响应**:
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 1,
        "employee_id": "EMP001",
        "name": "张三",
        "department": "技术部",
        "position": "高级工程师",
        "basic_salary": 15000.00,
        "hire_date": "2020-01-15"
      }
    ],
    "pagination": {
      "page": 1,
      "size": 20,
      "total": 100,
      "pages": 5
    }
  }
}
```

### 2.2 获取单个员工详情

**端点**: `GET /employees/{employee_id}`

**响应**:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "employee_id": "EMP001",
    "name": "张三",
    "department": "技术部",
    "position": "高级工程师",
    "basic_salary": 15000.00,
    "hire_date": "2020-01-15",
    "bank_account": "6222 **** **** 1234",
    "phone": "138****1234",
    "attendance_days": 22,
    "overtime_hours": 10.5,
    "late_count": 1,
    "sick_leave_days": 0,
    "personal_leave_days": 1
  }
}
```

### 2.3 创建员工

**端点**: `POST /employees`

**请求体**:
```json
{
  "employee_id": "EMP002",
  "name": "李四",
  "department": "市场部",
  "position": "市场专员",
  "basic_salary": 12000.00,
  "hire_date": "2021-06-01",
  "bank_account": "6222 **** **** 5678",
  "phone": "139****5678",
  "email": "lisi@company.com"
}
```

### 2.4 更新员工信息

**端点**: `PUT /employees/{employee_id}`

### 2.5 删除员工

**端点**: `DELETE /employees/{employee_id}`

## 3. Excel导入 (Excel Import)

### 3.1 上传Excel文件

**端点**: `POST /import/excel`

**请求**: `multipart/form-data`

**表单字段**:
- `file`: Excel文件 (.xlsx/.xls)
- `type`: 导入类型 (employee/attendance)

**⚠️ Excel文件格式要求**：
Excel文件必须采用双层表头格式：

```
第1行（英文字段名）： employeeId | name | department | position | basicSalary
第2行（中文字段名）： 员工工号   | 姓名  | 部门       | 职位     | 基本薪资
第3行开始：           实际数据   | ...  | ...        | ...      | ...
```

**字段映射规则**：
- 第1行英文字段名用于系统内部字段映射
- 第2行中文字段名仅用于界面显示
- 从第3行开始解析实际数据

**示例Excel文件结构**：
```csv
employeeId,name,department,position,basicSalary,hireDate
员工工号,姓名,部门,职位,基本薪资,入职日期
EMP001,张三,技术部,高级工程师,15000,2020-01-15
EMP002,李四,市场部,市场专员,12000,2021-06-01
```

**响应**:
```json
{
  "success": true,
  "data": {
    "upload_id": "uuid-string",
    "file_name": "员工数据.xlsx",
    "total_rows": 150,
    "valid_rows": 148,
    "invalid_rows": 2,
    "errors": [
      {
        "row": 25,
        "field": "employee_id",
        "message": "员工ID已存在"
      },
      {
        "row": 67,
        "field": "basic_salary",
        "message": "基本薪资必须为正数"
      }
    ]
  }
}
```

### 3.2 确认导入

**端点**: `POST /import/excel/{upload_id}/confirm`

**响应**:
```json
{
  "success": true,
  "data": {
    "imported_count": 148,
    "skipped_count": 2,
    "message": "成功导入148条记录"
  }
}
```

### 3.3 下载错误报告

**端点**: `GET /import/excel/{upload_id}/error-report`

**响应**: Excel文件下载

## 4. 薪资规则管理 (Payroll Rules)

### 4.1 获取规则列表

**端点**: `GET /payroll/rules`

**响应**:
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "rule_name": "绩效奖金",
      "rule_type": "bonus",
      "calculation_type": "percentage",
      "value": 10.0,
      "description": "按基本薪资的10%计算绩效奖金",
      "is_active": true
    }
  ]
}
```

### 4.2 创建规则

**端点**: `POST /payroll/rules`

**请求体**:
```json
{
  "rule_name": "交通补贴",
  "rule_type": "bonus",
  "calculation_type": "fixed",
  "value": 500.00,
  "description": "每月交通补贴500元",
  "is_active": true
}
```

### 4.3 更新规则

**端点**: `PUT /payroll/rules/{rule_id}`

### 4.4 删除规则

**端点**: `DELETE /payroll/rules/{rule_id}`

## 5. 薪资计算 (Payroll Calculation)

### 5.1 执行薪资计算

**端点**: `POST /payroll/calculate`

**请求体**:
```json
{
  "calculation_date": "2025-12-31",
  "department": "技术部",
  "rules": [1, 2, 3],
  "dry_run": false
}
```

**响应**:
```json
{
  "success": true,
  "data": {
    "calculation_id": "uuid-string",
    "calculation_date": "2025-12-31",
    "employee_count": 25,
    "total_gross_pay": 450000.00,
    "total_net_pay": 380000.00,
    "status": "completed",
    "duration_seconds": 15.3,
    "created_at": "2025-12-09T10:30:00Z"
  }
}
```

### 5.2 获取计算进度

**端点**: `GET /payroll/calculate/{calculation_id}/status`

**响应**:
```json
{
  "success": true,
  "data": {
    "calculation_id": "uuid-string",
    "status": "running",
    "progress": 60,
    "processed": 15,
    "total": 25,
    "current_employee": "张三"
  }
}
```

### 5.3 获取计算结果列表

**端点**: `GET /payroll/calculations`

**查询参数**:
- `calculation_date`: 计算日期
- `department`: 部门筛选
- `page`: 页码
- `size`: 每页数量

**响应**:
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 1,
        "employee_id": "EMP001",
        "employee_name": "张三",
        "department": "技术部",
        "basic_salary": 15000.00,
        "gross_pay": 16500.00,
        "total_deductions": 2500.00,
        "net_pay": 13500.00,
        "status": "confirmed"
      }
    ],
    "pagination": {
      "page": 1,
      "size": 20,
      "total": 25,
      "pages": 2
    }
  }
}
```

### 5.4 获取计算结果详情

**端点**: `GET /payroll/calculations/{calculation_id}`

**响应**:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "employee_id": "EMP001",
    "employee_name": "张三",
    "calculation_date": "2025-12-31",

    "basic_salary": 15000.00,
    "performance_bonus": 1500.00,
    "overtime_pay": 0.00,
    "other_bonus": 0.00,

    "late_deduction": 100.00,
    "sick_leave_deduction": 0.00,
    "personal_leave_deduction": 0.00,
    "other_deduction": 0.00,

    "pension_insurance": 600.00,
    "medical_insurance": 150.00,
    "unemployment_insurance": 30.00,
    "housing_fund": 900.00,

    "gross_pay": 16500.00,
    "total_deductions": 1780.00,

    "personal_income_tax": 450.00,

    "only_child_allowance": 0.00,
    "women_health_allowance": 0.00,

    "net_pay": 14270.00,

    "status": "confirmed",
    "confirmed_by": "admin",
    "confirmed_at": "2025-12-09T11:00:00Z"
  }
}
```

### 5.5 确认计算结果

**端点**: `POST /payroll/calculations/{calculation_id}/confirm`

**请求体**:
```json
{
  "notes": "2025年12月薪资"
}
```

### 5.6 重新计算

**端点**: `POST /payroll/calculations/{calculation_id}/recalculate`

## 6. 报表导出 (Reports Export)

### 6.1 导出员工基础信息报表

**端点**: `GET /reports/employees/export`

**查询参数**:
- `department`: 部门筛选
- `format`: 格式 (xlsx/csv)

**响应**: Excel文件下载

### 6.2 导出薪资计算结果报表

**端点**: `GET /reports/payroll/export`

**查询参数**:
- `calculation_date`: 计算日期
- `department`: 部门筛选
- `format`: 格式 (xlsx/csv)

**响应**: Excel文件下载

### 6.3 导出自定义报表

**端点**: `POST /reports/custom`

**请求体**:
```json
{
  "report_type": "payroll_summary",
  "date_range": {
    "start": "2025-12-01",
    "end": "2025-12-31"
  },
  "department": "技术部",
  "columns": [
    "employee_id",
    "name",
    "department",
    "basic_salary",
    "gross_pay",
    "net_pay"
  ],
  "format": "xlsx"
}
```

## 7. 用户管理 (User Management)

### 7.1 获取用户列表

**端点**: `GET /users`

### 7.2 创建用户

**端点**: `POST /users`

**请求体**:
```json
{
  "username": "accountant001",
  "email": "accountant@company.com",
  "password": "password123",
  "full_name": "薪资核算员",
  "role": "accountant"
}
```

### 7.3 更新用户

**端点**: `PUT /users/{user_id}`

### 7.4 删除用户

**端点**: `DELETE /users/{user_id}`

### 7.5 重置用户密码

**端点**: `POST /users/{user_id}/reset-password`

## 8. 数据备份 (Data Backup)

### 8.1 创建备份

**端点**: `POST /backup`

**请求体**:
```json
{
  "backup_type": "manual",
  "include_logs": true
}
```

**响应**:
```json
{
  "success": true,
  "data": {
    "backup_id": "uuid-string",
    "backup_name": "manual-backup-2025-12-09",
    "status": "pending",
    "message": "备份任务已创建"
  }
}
```

### 8.2 获取备份列表

**端点**: `GET /backup`

**响应**:
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "backup_name": "automatic-backup-2025-12-08",
      "backup_type": "automatic",
      "file_size": 10485760,
      "status": "success",
      "created_at": "2025-12-08T02:00:00Z"
    }
  ]
}
```

### 8.3 下载备份文件

**端点**: `GET /backup/{backup_id}/download`

### 8.4 恢复数据

**端点**: `POST /backup/{backup_id}/restore`

## 9. 系统日志 (System Logs)

### 9.1 获取日志列表

**端点**: `GET /logs`

**查询参数**:
- `user_id`: 用户ID筛选
- `action`: 操作类型筛选
- `start_date`: 开始日期
- `end_date`: 结束日期
- `page`: 页码
- `size`: 每页数量

**响应**:
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 1,
        "user_id": 1,
        "user_name": "admin",
        "action": "CREATE",
        "resource_type": "Employee",
        "resource_id": 1,
        "details": "创建员工：张三",
        "ip_address": "192.168.1.100",
        "created_at": "2025-12-09T10:30:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "size": 50,
      "total": 1000,
      "pages": 20
    }
  }
}
```

## 错误代码

| 错误代码 | HTTP状态码 | 描述 |
|---------|-----------|------|
| AUTH_001 | 401 | 未认证或Token无效 |
| AUTH_002 | 403 | 权限不足 |
| AUTH_003 | 401 | Token已过期 |
| VAL_001 | 422 | 请求参数验证失败 |
| VAL_002 | 422 | 数据格式错误 |
| EMP_001 | 404 | 员工不存在 |
| EMP_002 | 409 | 员工ID已存在 |
| CAL_001 | 400 | 薪资计算配置错误 |
| CAL_002 | 409 | 计算任务已在进行中 |
| IMP_001 | 400 | Excel文件格式错误 |
| IMP_002 | 422 | Excel数据验证失败 |
| REP_001 | 404 | 报表不存在 |
| USR_001 | 404 | 用户不存在 |
| USR_002 | 409 | 用户名已存在 |
| USR_003 | 409 | 邮箱已存在 |
| BAK_001 | 404 | 备份文件不存在 |
| BAK_002 | 500 | 备份创建失败 |
| SYS_001 | 500 | 系统内部错误 |
| SYS_002 | 503 | 服务不可用 |

## 认证和授权

### JWT Token结构

Header:
```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

Payload:
```json
{
  "sub": "1",
  "username": "admin",
  "role": "admin",
  "exp": 1702108800
}
```

### 角色权限矩阵

| 功能 | admin | manager | accountant | employee |
|-----|-------|---------|------------|----------|
| 用户管理 | ✓ | ✗ | ✗ | ✗ |
| 薪资规则配置 | ✓ | ✓ | ✓ | ✗ |
| 薪资计算 | ✓ | ✓ | ✓ | ✗ |
| 查看所有薪资 | ✓ | ✓ | ✓ | ✗ |
| 查看本人薪资 | ✓ | ✓ | ✓ | ✓ |
| 数据备份 | ✓ | ✗ | ✗ | ✗ |
| 报表导出 | ✓ | ✓ | ✓ | ✗ |

## 限流和配额

- **登录尝试**: 每分钟最多5次
- **API调用**: 匿名用户每小时100次，认证用户每小时1000次
- **文件上传**: 最大100MB
- **并发计算**: 同时最多3个薪资计算任务

## 版本控制

- **当前版本**: v1.0
- **API版本路径**: `/api/v1`
- **弃用策略**: 新版本发布后，旧版本至少保留6个月
- **变更通知**: 重大变更提前30天通知
