# Excel文件格式规范 - PayrollMaster薪资系统

## 概述

本文档详细说明了PayrollMaster系统中Excel文件的格式要求，包括导入和导出文件的结构、字段映射和数据验证规则。

**重要提醒**：所有Excel文件均采用**双层表头**格式，即前两行作为表头，第3行开始才是实际数据。

---

## 1. 员工数据导入格式

### 1.1 文件结构

```
┌──────────────────────────────────────────────────────────────────────┐
│ 第1行 │ 英文字段名  │ employeeId │ name │ department │ position │ ... │
├───────┼────────────┼────────────┼──────┼────────────┼──────────┼─────┤
│ 第2行 │ 中文字段名  │ 员工工号   │ 姓名 │ 部门       │ 职位     │ ... │
├───────┼────────────┼────────────┼──────┼────────────┼──────────┼─────┤
│ 第3行 │ ────────── │ ──────────┼──────┼────────────┼──────────┼─────┤
│ 第4行 │ 实际数据   │ EMP001    │ 张三 │ 技术部     │ 高级工程  │ ... │
│ 第5行 │ 实际数据   │ EMP002    │ 李四 │ 市场部     │ 市场专   │ ... │
└───────┴────────────┴────────────┴──────┴────────────┴──────────┴─────┘
```

### 1.2 字段说明

#### 英文字段名 → 数据库字段映射

| 英文字段名 | 数据库字段名 | 中文字段名 | 数据类型 | 必填 | 说明 |
|------------|--------------|------------|----------|------|------|
| employeeId | employee_id | 员工工号 | string | ✓ | 唯一标识，5-20字符 |
| name | name | 姓名 | string | ✓ | 员工真实姓名 |
| department | department | 部门 | string | ✓ | 所属部门 |
| position | position | 职位 | string | ✓ | 职位名称 |
| basicSalary | basic_salary | 基本薪资 | decimal | ✓ | 月基本工资，≥0 |
| hireDate | hire_date | 入职日期 | date | ✓ | YYYY-MM-DD格式 |
| bankAccount | bank_account | 银行账号 | string | - | 银行卡号 |
| idCard | id_card | 身份证号 | string | - | 18位身份证号 |
| phone | phone | 联系电话 | string | - | 11位手机号 |
| email | email | 邮箱 | string | - | 有效邮箱地址 |
| attendanceDays | attendance_days | 出勤天数 | integer | - | 本月出勤天数 |
| overtimeHours | overtime_hours | 加班小时数 | decimal | - | 本月加班小时 |
| lateCount | late_count | 迟到次数 | integer | - | 本月迟到次数 |
| sickLeaveDays | sick_leave_days | 病假天数 | integer | - | 本月病假天数 |
| personalLeaveDays | personal_leave_days | 事假天数 | integer | - | 本月事假天数 |

### 1.3 示例文件内容

```csv
employeeId,name,department,position,basicSalary,hireDate,bankAccount,phone,email,attendanceDays,overtimeHours,lateCount,sickLeaveDays,personalLeaveDays
员工工号,姓名,部门,职位,基本薪资,入职日期,银行账号,联系电话,邮箱,出勤天数,加班小时数,迟到次数,病假天数,事假天数
EMP001,张三,技术部,高级工程师,15000.00,2020-01-15,6222 **** **** 1234,138****1234,zhangsan@company.com,22,10.5,1,0,1
EMP002,李四,市场部,市场专员,12000.00,2021-06-01,6222 **** **** 5678,139****5678,lisi@company.com,21,5.0,0,2,0
```

### 1.4 数据验证规则

#### 必填字段验证
- employeeId：不能为空，必须唯一，长度5-20字符，仅允许字母和数字
- name：不能为空，长度2-50字符
- department：不能为空，长度2-30字符
- position：不能为空，长度2-30字符
- basicSalary：不能为空，必须≥0，保留两位小数
- hireDate：不能为空，必须为有效日期，不能是未来日期

#### 数据格式验证
- phone：11位数字，可包含分隔符（如：138-1234-5678）
- email：必须符合RFC 5322标准格式
- bankAccount：可以是纯数字或包含分隔符
- idCard：18位身份证号，最后一位可以是X
- attendanceDays：0-31之间的整数
- overtimeHours：≥0的数值，保留一位小数
- lateCount：≥0的整数
- sickLeaveDays：0-31之间的整数
- personalLeaveDays：0-31之间的整数

#### 业务逻辑验证
- hireDate不能晚于当前日期
- attendanceDays + sickLeaveDays + personalLeaveDays ≤ 当月总天数
- 基本薪资应在合理范围内（根据职位和部门）

---

## 2. 考勤数据导入格式

### 2.1 字段映射

| 英文字段名 | 数据库字段名 | 中文字段名 | 数据类型 | 必填 | 说明 |
|------------|--------------|------------|----------|------|------|
| employeeId | employee_id | 员工工号 | string | ✓ | 对应员工表 |
| date | date | 日期 | date | ✓ | YYYY-MM-DD格式 |
| attendanceStatus | attendance_status | 出勤状态 | string | ✓ | 正常/迟到/缺勤/病假/事假 |
| overtimeHours | overtime_hours | 加班小时 | decimal | - | 当日加班小时数 |
| lateMinutes | late_minutes | 迟到分钟 | integer | - | 迟到分钟数 |
| notes | notes | 备注 | string | - | 考勤备注信息 |

### 2.2 示例文件内容

```csv
employeeId,date,attendanceStatus,overtimeHours,lateMinutes,notes
员工工号,日期,出勤状态,加班小时数,迟到分钟数,备注
EMP001,2025-12-01,正常,2.0,0,
EMP001,2025-12-02,迟到,0,30,交通堵塞
EMP001,2025-12-03,病假,0,0,医院证明
```

---

## 3. 薪资计算结果导出格式

### 3.1 导出文件结构

**工作表1：薪资明细表 (payrollCalculationResult)**

| 英文字段名 | 中文字段名 | 数据来源 | 格式 |
|------------|------------|----------|------|
| employeeId | 员工工号 | Employee.employee_id | string |
| employeeName | 员工姓名 | Employee.name | string |
| department | 部门 | Employee.department | string |
| position | 职位 | Employee.position | string |
| basicSalary | 基本薪资 | SalaryCalculation.basic_salary | currency |
| performanceBonus | 绩效奖金 | SalaryCalculation.performance_bonus | currency |
| overtimePay | 加班费 | SalaryCalculation.overtime_pay | currency |
| otherBonus | 其他奖金 | SalaryCalculation.other_bonus | currency |
| lateDeduction | 迟到扣款 | SalaryCalculation.late_deduction | currency |
| sickLeaveDeduction | 病假扣款 | SalaryCalculation.sick_leave_deduction | currency |
| personalLeaveDeduction | 事假扣款 | SalaryCalculation.personal_leave_deduction | currency |
| pensionInsurance | 养老保险 | SalaryCalculation.pension_insurance | currency |
| medicalInsurance | 医疗保险 | SalaryCalculation.medical_insurance | currency |
| unemploymentInsurance | 失业保险 | SalaryCalculation.unemployment_insurance | currency |
| housingFund | 住房公积金 | SalaryCalculation.housing_fund | currency |
| grossPay | 应发工资 | SalaryCalculation.gross_pay | currency |
| totalDeductions | 扣除合计 | SalaryCalculation.total_deductions | currency |
| personalIncomeTax | 个人所得税 | SalaryCalculation.personal_income_tax | currency |
| onlyChildAllowance | 独生子女费 | SalaryCalculation.only_child_allowance | currency |
| womenHealthAllowance | 女工卫生费 | SalaryCalculation.women_health_allowance | currency |
| netPay | 实发工资 | SalaryCalculation.net_pay | currency |
| calculationDate | 计算日期 | SalaryCalculation.calculation_date | date |
| status | 状态 | SalaryCalculation.status | string |

**工作表2：部门汇总表 (departmentSummary)**

| 中文字段名 | 说明 |
|------------|------|
| 部门 | 部门名称 |
| 人数 | 该部门员工总数 |
| 应发工资合计 | 该部门所有员工应发工资总和 |
| 实发工资合计 | 该部门所有员工实发工资总和 |
| 平均工资 | 该部门平均工资 |
| 社保合计 | 该部门社保总支出 |
| 税费合计 | 该部门个人所得税总计 |

### 3.2 示例导出数据

```
第1行：employeeId, employeeName, department, position, basicSalary, performanceBonus, ...
第2行：员工工号, 员工姓名, 部门, 职位, 基本薪资, 绩效奖金, ...
第3行：─────────────────────────────────────────────────────────────────────────────────
第4行：EMP001, 张三, 技术部, 高级工程师, 15000.00, 1500.00, ...
第5行：EMP002, 李四, 市场部, 市场专员, 12000.00, 1200.00, ...
```

---

## 4. Excel模板文件

### 4.1 员工数据导入模板

**文件位置**: `excel-templates/import/employee-template.xlsx`

**模板内容**:
```csv
employeeId,name,department,position,basicSalary,hireDate,bankAccount,phone,email,attendanceDays,overtimeHours,lateCount,sickLeaveDays,personalLeaveDays
员工工号,姓名,部门,职位,基本薪资,入职日期,银行账号,联系电话,邮箱,出勤天数,加班小时数,迟到次数,病假天数,事假天数
,,,,,,,,,,,
```

**使用说明**:
1. 下载模板文件
2. 在第4行开始填写实际数据
3. 不要修改表头（第1-2行）
4. 保留空行会导致验证失败

### 4.2 考勤数据导入模板

**文件位置**: `excel-templates/import/attendance-template.xlsx`

**模板内容**:
```csv
employeeId,date,attendanceStatus,overtimeHours,lateMinutes,notes
员工工号,日期,出勤状态,加班小时数,迟到分钟数,备注
,,,,,
```

---

## 5. 错误处理与验证

### 5.1 常见错误类型

#### 格式错误
| 错误代码 | 错误描述 | 解决方案 |
|----------|----------|----------|
| FMT_001 | Excel文件格式不支持 | 使用.xlsx或.xls格式 |
| FMT_002 | 文件为空或损坏 | 检查文件是否完整 |
| FMT_003 | 缺少必要的工作表 | 确保文件包含正确的工作表 |

#### 表头错误
| 错误代码 | 错误描述 | 解决方案 |
|----------|----------|----------|
| HDR_001 | 缺少英文字段名行 | 确保第1行包含英文字段名 |
| HDR_002 | 缺少中文字段名行 | 确保第2行包含中文字段名 |
| HDR_003 | 字段名不匹配 | 使用标准字段名，检查拼写 |
| HDR_004 | 缺少必填字段 | 确保必填字段存在 |

#### 数据错误
| 错误代码 | 错误描述 | 解决方案 |
|----------|----------|----------|
| DATA_001 | 必填字段为空 | 补充所有必填字段 |
| DATA_002 | 数据格式错误 | 检查数据类型和格式 |
| DATA_003 | 数值超出范围 | 检查数值是否在允许范围内 |
| DATA_004 | 日期格式错误 | 使用YYYY-MM-DD格式 |
| DATA_005 | 员工工号重复 | 修改重复的员工工号 |
| DATA_006 | 邮箱格式错误 | 使用有效邮箱格式 |
| DATA_007 | 身份证号格式错误 | 检查身份证号格式 |

### 5.2 错误报告格式

**响应示例**:
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "数据验证失败",
    "details": {
      "total_rows": 150,
      "valid_rows": 148,
      "invalid_rows": 2,
      "errors": [
        {
          "row": 25,
          "field": "employeeId",
          "value": "EMP001",
          "message": "员工工号已存在",
          "code": "DATA_005"
        },
        {
          "row": 67,
          "field": "basicSalary",
          "value": "-1000",
          "message": "基本薪资必须为正数",
          "code": "DATA_003"
        }
      ]
    }
  }
}
```

### 5.3 错误行定位

- **行号计算**: 数据行号 = Excel行号 - 2（第1-2行是表头）
- **字段定位**: 根据错误信息中的field字段定位到具体列
- **值显示**: 显示导致错误的原始值

---

## 6. 最佳实践

### 6.1 文件准备

1. **使用标准模板**
   - 下载官方提供的Excel模板
   - 不要修改表头结构
   - 在模板基础上填充数据

2. **数据清理**
   - 删除空行和空列
   - 统一数据格式（日期、金额等）
   - 检查特殊字符和编码

3. **数据验证**
   - 导入前先在Excel中验证公式
   - 使用条件格式高亮错误数据
   - 进行小批量测试

### 6.2 数据填写规范

1. **员工工号**
   - 使用字母+数字的组合
   - 避免使用特殊字符
   - 保持唯一性

2. **日期格式**
   - 统一使用YYYY-MM-DD格式
   - 不要使用MM/DD/YYYY或DD/MM/YYYY
   - 确保日期有效（不是2月30日等）

3. **金额字段**
   - 使用数字格式，不要包含货币符号
   - 保留两位小数
   - 不能为负数（除扣款外）

4. **文本字段**
   - 不要包含换行符
   - 控制长度在规定范围内
   - 避免全角/半角混用

### 6.3 导入流程

1. **上传前检查**
   - ✓ 文件格式正确（.xlsx/.xls）
   - ✓ 双层表头完整
   - ✓ 必填字段存在
   - ✓ 数据格式初步验证

2. **上传后验证**
   - 系统自动验证所有字段
   - 生成错误报告
   - 显示验证统计

3. **错误修正**
   - 根据错误报告修正数据
   - 重新上传文件
   - 重复直到验证通过

4. **确认导入**
   - 预览验证通过的数据
   - 确认无误后提交
   - 系统执行最终导入

---

## 7. 技术实现

### 7.1 前端处理

**文件上传组件**:
```typescript
const ExcelUploader = () => {
  const handleFileUpload = async (file: File) => {
    // 1. 验证文件格式
    const isValidFormat = ['.xlsx', '.xls'].some(ext =>
      file.name.toLowerCase().endsWith(ext)
    )
    if (!isValidFormat) {
      throw new Error('FMT_001: 不支持的文件格式')
    }

    // 2. 创建FormData
    const formData = new FormData()
    formData.append('file', file)
    formData.append('type', 'employee')

    // 3. 上传文件
    const response = await fetch('/api/import/excel', {
      method: 'POST',
      body: formData
    })

    // 4. 处理响应
    const result = await response.json()
    return result
  }

  return (
    // 上传组件UI
  )
}
```

### 7.2 后端解析

**Excel解析服务**:
```python
from openpyxl import load_workbook
from typing import Dict, List, Tuple

class ExcelParser:
    @staticmethod
    def parseEmployeeExcel(filePath: str) -> Tuple[List[Dict], Dict]:
        """
        解析员工Excel文件
        返回: (数据列表, 字段映射)
        """
        workbook = load_workbook(filePath, read_only=True)
        worksheet = workbook.active

        # 读取表头（第1-2行）
        headers = ExcelParser.parseHeaders(worksheet)

        # 读取数据（第3行开始）
        data = ExcelParser.parseData(worksheet, headers)

        return data, headers

    @staticmethod
    def parseHeaders(worksheet) -> Dict[str, str]:
        """解析表头，返回英文字段名到中文字段名的映射"""
        headers = {}
        for col in range(1, worksheet.maxColumn + 1):
            english = worksheet.cell(row=1, column=col).value
            chinese = worksheet.cell(row=2, column=col).value
            if english and chinese:
                headers[english] = chinese
        return headers

    @staticmethod
    def parseData(worksheet, headers: Dict[str, str]) -> List[Dict]:
        """解析数据行"""
        data = []
        for row in range(3, worksheet.maxRow + 1):
            rowData = {}
            for englishName, chineseName in headers.items():
                cellValue = worksheet.cell(row=row, column=list(headers.keys()).index(englishName) + 1).value
                dbField = EMPLOYEE_FIELD_MAPPING.get(englishName)
                if dbField:
                    rowData[dbField] = cellValue

            if any(rowData.values()):  # 跳过空行
                data.append(rowData)

        return data
```

### 7.3 数据验证

**验证器**:
```python
from typing import Dict, Any, List
import re

class EmployeeValidator:
    @staticmethod
    def validate(data: Dict[str, Any]) -> List[str]:
        """验证员工数据，返回错误列表"""
        errors = []

        # 必填字段验证
        requiredFields = ['employeeId', 'name', 'department', 'position', 'basicSalary', 'hireDate']
        for field in requiredFields:
            if not data.get(field):
                errors.append(f"必填字段 {field} 不能为空")

        # 员工工号验证
        employeeId = data.get('employeeId', '')
        if not re.match(r'^[A-Za-z0-9]{5,20}$', employeeId):
            errors.append("员工工号格式不正确，应为5-20位字母或数字")

        # 邮箱验证
        email = data.get('email')
        if email and not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', email):
            errors.append("邮箱格式不正确")

        # 薪资验证
        basicSalary = data.get('basicSalary')
        if basicSalary and (not isinstance(basicSalary, (int, float)) or basicSalary < 0):
            errors.append("基本薪资必须为非负数")

        return errors
```

---

## 8. FAQ

### Q1: 为什么Excel文件要使用双层表头？

**A**: 双层表头设计有以下几个优势：
1. **用户友好**: 中文字段名更直观，便于用户理解
2. **系统兼容**: 英文字段名便于系统内部处理和字段映射
3. **国际化**: 为未来多语言支持预留空间
4. **标准化**: 符合企业级应用的数据管理规范

### Q2: 可以修改英文字段名吗？

**A**: 不建议修改。英文字段名是系统内部字段映射的关键，修改后需要同步更新映射表。建议使用官方提供的模板文件。

### Q3: Excel文件最大支持多少行？

**A**:
- .xlsx格式：最大1,048,576行（建议不超过10,000行）
- .xls格式：最大65,536行
- 考虑到性能，推荐单次导入不超过1,000条记录

### Q4: 如何处理大量数据导入？

**A**: 对于大量数据，建议：
1. 分批导入（每批500-1000条记录）
2. 使用.xlsx格式获得更好性能
3. 确保服务器内存充足
4. 使用异步导入避免超时

### Q5: 导入过程中断怎么办？

**A**: 系统采用两步确认机制：
1. 第一步：上传并验证数据（不写入数据库）
2. 第二步：确认后才写入数据库

如果第一步中断，只需重新上传文件即可。如果第二步中断，数据不会写入，可以重新确认。

### Q6: 如何导出特定格式的报表？

**A**: 系统支持多种导出格式：
- **完整报表**: 包含所有字段和所有员工
- **部门报表**: 按部门筛选导出
- **个人报表**: 单个员工的所有历史记录
- **汇总报表**: 按部门或时间维度的汇总数据

导出时可选择Excel、CSV或PDF格式。

---

## 9. 更新日志

| 版本 | 日期 | 更新内容 |
|------|------|----------|
| v1.0 | 2025-12-09 | 初始版本，定义双层表头格式和字段映射 |

---

## 10. 附录

### 附录A: 完整字段映射表

```python
EMPLOYEE_FIELD_MAPPING = {
    # 基本信息
    'employeeId': 'employeeId',
    'name': 'name',
    'department': 'department',
    'position': 'position',
    'basicSalary': 'basicSalary',
    'hireDate': 'hireDate',

    # 银行和证件
    'bankAccount': 'bankAccount',
    'idCard': 'idCard',
    'phone': 'phone',
    'email': 'email',

    # 考勤数据
    'attendanceDays': 'attendanceDays',
    'overtimeHours': 'overtimeHours',
    'lateCount': 'lateCount',
    'sickLeaveDays': 'sickLeaveDays',
    'personalLeaveDays': 'personalLeaveDays',
}

CHINESE_FIELD_NAMES = {
    'employeeId': '员工工号',
    'name': '姓名',
    'department': '部门',
    'position': '职位',
    'basicSalary': '基本薪资',
    'hireDate': '入职日期',
    'bankAccount': '银行账号',
    'idCard': '身份证号',
    'phone': '联系电话',
    'email': '邮箱',
    'attendanceDays': '出勤天数',
    'overtimeHours': '加班小时数',
    'lateCount': '迟到次数',
    'sickLeaveDays': '病假天数',
    'personalLeaveDays': '事假天数',
}
```

### 附录B: 正则表达式验证规则

```python
# 验证规则
VALIDATION_RULES = {
    'employeeId': r'^[A-Za-z0-9]{5,20}$',
    'phone': r'^1[3-9]\d{9}$|^(\d{3}-?\d{4}-?\d{4})$',
    'email': r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    'idCard': r'^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$',
    'bankAccount': r'^\d{16,19}$|^(\d{4}-?\d{4}-?\d{4}-?\d{4})$',
}
```

---

**文档版本**: v1.0
**最后更新**: 2025-12-09
**作者**: PayrollMaster开发团队
**状态**: 正式版
