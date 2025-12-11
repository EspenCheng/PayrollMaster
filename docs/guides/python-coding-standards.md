# Python代码命名规范 - PayrollMaster项目

## 📋 更新概览

**更新日期**: 2025-12-09  
**功能分支**: `001-payroll-calculation-system`  
**更新类型**: Python代码命名规范统一

---

## ⚠️ 重要变更

### 命名规范变更

**变更前** (Python传统风格):
```python
employee_id = "RYJM-0000137269"
basic_salary = 15000.00
hire_date = "2020-01-15"
def parse_employee_excel():
    field_mappings = {}
    chinese_names = {}
```

**变更后** (统一驼峰命名):
```python
employeeId = "RYJM-0000137269"
hireDate = "2020-01-15"
def parseEmployeeExcel():
    fieldMappings = {}
    chineseNames = {}
```

---

## ✅ 已更新文档

### 1. 数据模型设计 (`data-model.md`)
- ✅ Employee模型：所有字段名使用camelCase
- ✅ PayrollRule模型：所有字段名使用camelCase
- ✅ SalaryCalculation模型：所有字段名使用camelCase
- ✅ User模型：所有字段名使用camelCase
- ✅ SystemLog模型：所有字段名使用camelCase
- ✅ DataBackup模型：所有字段名使用camelCase
- ✅ 字段映射表：EMPLOYEE_FIELD_MAPPING更新
- ✅ Excel解析示例：函数名和变量名更新

### 2. Excel格式规范 (`excel-format-spec.md`)
- ✅ ExcelParser类：方法名更新
- ✅ EmployeeValidator类：变量名更新
- ✅ 字段映射表：数据库字段名更新
- ✅ 验证规则：VALIDATION_RULES键名更新

---

## 📊 具体变更列表

### Employee模型字段变更

| 变更前 (snake_case) | 变更后 (camelCase) |
|---------------------|--------------------|
| employee_id | employeeId |
| hire_date | hireDate |
| bank_account | bankAccount |
| id_card | idCard |
| attendance_days | attendanceDays |
| sick_leave_days | sickLeaveDays |
| personal_leave_days | personalLeaveDays |
| created_at | createdAt |
| updated_at | updatedAt |
| salary_calculations | salaryCalculations |

### SalaryCalculation模型字段变更

| 变更前 (snake_case) | 变更后 (camelCase) |
|---------------------|--------------------|
| employee_id | employeeId |
| calculation_date | calculationDate |
| performance_bonus | performanceBonus |
| overtime_pay | overtimePay |
| gross_pay | grossPay |
| total_deductions | totalDeductions |
| personal_income_tax | personalIncomeTax |
| only_child_allowance | onlyChildAllowance |
| women_health_allowance | womenHealthAllowance |
| net_pay | netPay |
| confirmed_by | confirmedBy |
| confirmed_at | confirmedAt |

### 函数名变更

| 变更前 | 变更后 |
|--------|--------|
| parse_employee_excel() | parseEmployeeExcel() |
| _parse_headers() | parseHeaders() |
| _parse_data() | parseData() |

### 变量名变更

| 变更前 | 变更后 |
|--------|--------|
| field_mappings | fieldMappings |
| chinese_names | chineseNames |
| english_name | englishName |
| chinese_name | chineseName |
| db_field | dbField |
| employee_data | employeeData |
| row_data | rowData |
| cell_value | cellValue |
| required_fields | requiredFields |
| employee_id | employeeId |

---

## 🎯 适用范围

### 适用的代码类型
- ✅ SQLModel模型字段名
- ✅ 函数名
- ✅ 变量名
- ✅ 方法名
- ✅ 字典键名（自定义）
- ✅ 类属性名

### 不适用的场景
- ⚠️ Python内置函数和关键字
- ⚠️ 第三方库要求的命名（如SQLAlchemy的某些约定）
- ⚠️ 数据库列名（如果使用snake_case惯例）
- ⚠️ JSON字段名（根据API契约决定）
- ✅ Excel字段名（保持原样，外部系统规定）

---

## 📝 最佳实践

### 1. 类名
```python
# 使用PascalCase
class EmployeeService:
    pass

class PayrollCalculator:
    pass
```

### 2. 函数和方法名
```python
# 使用camelCase
def calculateSalary():
    pass

def parseEmployeeExcel():
    pass
```

### 3. 变量名
```python
# 使用camelCase
employeeId = "RYJM-0000137269"
fieldMappings = {}
```

### 4. 常量
```python
# 使用UPPER_SNAKE_CASE（保持Python传统）
MAX_FILE_SIZE = 100 * 1024 * 1024
DEFAULT_PAGE_SIZE = 20
```

### 5. 私有成员
```python
# 使用_leading_underscore + camelCase
class EmployeeService:
    def _validateInput(self):
        pass
    
    def _processData(self):
        pass
```

---

## 🔍 验证规则

### 命名检查清单

#### ✅ 正确示例
```python
class EmployeeService:
        fieldMappings = {}

employeeId = "RYJM-0000137269"
```

#### ❌ 错误示例
```python
class employeeService:  # 类名应使用PascalCase
    def calculate_salary(self, employee_id: str, basic_salary: float) -> float:  # 应使用camelCase
        field_mappings = {}  # 应使用camelCase
        return basic_salary  # 应使用camelCase
```

---

## 🚀 迁移指南

### 对于已有代码

1. **批量重命名**
   ```bash
   # 使用工具如PyCharm的Rename功能
   # 或使用sed命令进行批量替换
   find . -name "*.py" -exec sed -i 's/employee_id/employeeId/g' {} \;
   ```

2. **手动检查**
   - 确认所有变量名已更新
   - 检查函数调用是否需要更新
   - 更新引用这些变量的其他代码

3. **测试验证**
   - 运行单元测试确保功能正常
   - 检查API契约是否需要调整
   - 验证JSON序列化/反序列化

### 对于新代码

- 严格遵循camelCase命名规范
- 使用IDE的代码检查功能
- 提交前进行代码审查

---

## 📚 相关文档

| 文档 | 路径 | 说明 |
|------|------|------|
| 数据模型设计 | `data-model.md` | 所有模型字段已更新 |
| Excel格式规范 | `excel-format-spec.md` | 所有示例代码已更新 |

---

## ✨ 总结

本次更新统一了项目中的Python代码命名规范：

✅ **提高一致性**: 所有Python代码使用统一的camelCase命名  
✅ **跨语言统一**: 与JavaScript/TypeScript保持一致  
✅ **提高可读性**: camelCase在混合语言项目中更易阅读  
✅ **完整覆盖**: 更新了所有相关文档和示例代码  

所有文档中的Python代码已更新完成，可直接用于开发！ 🎉
