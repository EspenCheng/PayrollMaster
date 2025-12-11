# 薪资管理系统命名规范速查表

## 📋 各层命名规范总览

| 层级 | 命名规范 | 示例 | 用途 |
|------|----------|------|------|
| 🗄️ **数据库** | snake_case | `employee_id`, `base_salary`, `created_at` | 表名、字段名、索引名 |
| 🌐 **API响应** | camelCase | `employeeId`, `baseSalary`, `createdAt` | JSON数据传输 |
| 💻 **Python代码** | camelCase | `calculatePayroll`, `userPermissions`, `getPayrollStatistics` | 函数名、变量名、类方法 |
| ⚛️ **前端代码** | camelCase | `employeeId`, `baseSalary`, `createdAt` | JavaScript/TypeScript变量 |

---

## 🔍 快速识别方法

### 方法1：代码注释标识

```python
# 数据库模型 (snake_case)
class Employee(SQLModel, table=True):
    employeeId: str = Field(...)  # 数据库字段
    department_id: Optional[int] = Field(...)  # 数据库字段
    created_at: datetime = Field(...)  # 数据库字段

# API响应模型 (camelCase)
class EmployeeResponse(SQLModel):
    employeeId: str  # API字段
    departmentId: Optional[int]  # API字段
    createdAt: datetime  # API字段

# Python业务逻辑 (camelCase)
def calculatePayroll(employeeId: int):  # 函数参数使用camelCase
    # 函数逻辑使用camelCase
    base_salary = getEmployeeSalary(employeeId)  # 局部变量
```

### 方法2：文件命名约定

```
models/
├── db/                    # 数据库模型 (snake_case)
│   ├── employee.py
│   └── payroll_record.py
├── api/                   # API模型 (camelCase)
│   ├── employee_response.py
│   └── payroll_response.py
└── business/              # 业务逻辑 (camelCase)
    ├── payrollCalculator.py
    └── employeeManager.py
```

### 方法3：变量名前缀约定

```python
# 数据库相关变量 (snake_case)
db_employee = Employee()  # db_前缀
employee_id = 123         # 蛇形命名
payroll_record = {...}    # 蛇形命名

# API相关变量 (camelCase)
apiEmployee = {...}       # api前缀
employeeId = 123          # 驼峰命名
payrollResponse = {...}   # 驼峰命名

# 业务逻辑变量 (camelCase)
calcResult = calculate()  # calc前缀
userPermissions = [...]   # 驼峰命名
```

---

## 🎨 颜色标识方案（IDE支持）

### VSCode配置
```json
// .vscode/settings.json
{
  "editor.tokenColorCustomizations": {
    "[*]": {
      "textMateRules": [
        {
          "name": "Database fields (snake_case)",
          "match": "\\b[a-z_]+(?:_[a-z_]+)*\\b",
          "foreground": "#e06c75"
        },
        {
          "name": "API fields (camelCase)",
          "match": "\\b[a-zA-Z]+(?:[A-Z][a-z]*)*\\b",
          "foreground": "#98c379"
        }
      ]
    }
  }
}
```

### PyCharm配置
```
File > Settings > Editor > Color Scheme > Python
- Database fields: Red color
- API fields: Green color
- Business logic: Blue color
```

---

## 📝 命名规范检查工具

### ESLint配置（前端）
```json
// .eslintrc.js
module.exports = {
  rules: {
    // 强制驼峰命名
    "camelcase": ["error", {
      "properties": "always",
      "ignoreDestructuring": false
    }]
  }
}
```

### Pylint配置（后端）
```ini
# .pylintrc
[FORMAT]
# 允许蛇形命名（数据库字段）
good-names=i,j,k,ex,Run,_,employee_id,base_salary,created_at

# 强制驼峰命名（业务逻辑）
bad-names=foo,bar,baz,toto,tutu,tata
```

---

## 🔄 数据流中的命名转换

### 1. 数据库 → API
```python
# 数据库模型 (snake_case)
db_employee = Employee(
    employeeId="RYJM-0000137269",
    department_id=1,
    base_salary=8000,
    created_at=datetime.now()
)

# 转换为API响应 (camelCase)
api_response = EmployeeResponse(
    employeeId=db_employee.employeeId,
    departmentId=db_employee.department_id,
    baseSalary=db_employee.base_salary,
    createdAt=db_employee.created_at
)
```

### 2. API → 前端
```typescript
// 前端接收 (camelCase)
const employee: EmployeeResponse = await fetch('/api/employees/1')
console.log(employee.employeeId)  // ✅ 正确
console.log(employee.employeeId)  // ❌ 错误
```

### 3. 前端 → API → 数据库
```typescript
// 前端发送 (camelCase)
const newEmployee = {
  employeeId: "EMP002",
  departmentId: 2,
  baseSalary: 9000
}

// API接收后转换为数据库格式
db_employee = Employee(
    employeeId=newEmployee.employeeId,
    department_id=newEmployee.departmentId,
    base_salary=newEmployee.baseSalary
)
```

---

## ⚡ 快速记忆口诀

**"DB用下划线，API驼峰名，代码逻辑驼峰走"**

- **DB** (Database) → snake_case → `employee_id`
- **API** → camelCase → `employeeId`
- **Code** (代码) → camelCase → `calculatePayroll`

---

## 🛠️ 自动化工具推荐

### 1. 命名规范检查器
```bash
# 安装命名检查工具
pip install pylint

# 检查Python代码命名
pylint --good-names="employee_id,base_salary" your_module.py
```

### 2. 代码格式化工具
```bash
# Python代码格式化（自动保持命名规范）
black your_module.py

# 前端代码格式化
prettier --write "src/**/*.ts"
```

### 3. 类型定义文件生成
```python
# 自动生成TypeScript类型定义
# 从API响应模型生成前端类型
```

---

## 📚 最佳实践

### ✅ 推荐做法
1. **明确标识**：在代码注释中明确标注使用的命名规范
2. **分层开发**：不同层级的文件使用不同的命名约定
3. **自动化检查**：使用工具自动检查命名规范
4. **团队约定**：制定团队统一的命名规范文档

### ❌ 避免做法
1. **混用命名**：不要在同一个文件中混用不同的命名规范
2. **忽略规范**：不要为了方便而忽略命名规范
3. **不注释**：不要在复杂的代码中省略命名规范说明

---

**记住：命名规范是为了提高代码可读性和维护性，严格遵守是保证代码质量的基础！**
