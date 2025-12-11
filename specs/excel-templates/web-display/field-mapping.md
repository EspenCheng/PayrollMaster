# 字段映射关系文档

## 概述

本文档说明Excel导入/导出字段与Web界面展示字段之间的映射关系，确保数据在整个系统中的一致性和准确性。

## 模板文件说明

### 导入模板: dataSubmissionReport.xlsx
**路径**: `excel-templates/import/dataSubmissionReport.xlsx`
**用途**: 数据提报模板，用于导入员工基础信息和考勤数据
**工作表**: Sheet1
**说明**: 该模板包含了完整的员工基础信息和考勤数据字段，支持批量导入薪资计算所需的全部数据。

### 导出模板: dataExportReport.xlsx
**路径**: `excel-templates/export/dataExportReport.xlsx`
**用途**: 数据导出模板，用于导出员工基础信息
**工作表**: Sheet1
**说明**: 该模板包含员工基础信息字段，用于导出员工基础数据。

### 导出模板: payrollCalculationResult.xlsx
**路径**: `excel-templates/export/payrollCalculationResult.xlsx`
**用途**: 薪资计算结果导出模板，用于导出完整的薪资计算结果
**工作表**: payrollCalculationResult
**说明**: 该模板包含了完整的薪资计算结果字段，支持导出所有员工的薪资明细和汇总信息。

### 字段映射关系
本映射文档详细说明了dataSubmissionReport.xlsx（导入）、dataExportReport.xlsx（导出）和payrollCalculationResult.xlsx（导出）中的字段与Web界面展示字段之间的映射关系。

## 映射关系说明

### 映射类型

1. **直接映射**: Excel字段直接对应Web字段，数据类型和名称完全一致
2. **计算映射**: Excel字段经过计算后显示为Web字段，需要应用计算公式
3. **组合映射**: 多个Excel字段组合形成Web字段
4. **转换映射**: Excel字段经过数据类型转换后显示为Web字段

## 员工基础信息映射

| Excel字段名 | Web字段名 | 中文显示名称 | 映射类型 | 转换规则 | 备注 |
|------------|-----------|-------------|----------|----------|------|
| mdnb_employee.number | employeeId | 员工编码 | 直接映射 | - | 唯一标识 |
| mdnb_employee.name | employeeName | 员工姓名 | 直接映射 | - | - |
| mdnb_department.number | departmentId | 部门编码 | 直接映射 | - | - |
| mdnb_department.name | departmentName | 部门名称 | 直接映射 | - | - |
| department_classification | departmentType | 部门类别 | 直接映射 | - | - |
| sub_department | departmentSubType | 部门二级类别 | 直接映射 | - | - |
| mdnb_employee.job | employeeJob | 岗位工种 | 直接映射 | - | - |
| mdnb_employee.job_type | jobType | 岗位类别 | 直接映射 | - | - |
| mdnb_employee.post | jobPosition | 职务类别 | 直接映射 | - | - |
| mdnb_employee.seniority | groupWorkYears | 集团工龄 | 直接映射 | - | - |
| mdnb_employee.undergroundWorkYears | undergroundWorkYears | 入井年限 | 直接映射 | - | - |

## 薪资标准映射

| Excel字段名 | Web字段名 | 中文显示名称 | 映射类型 | 转换规则 | 备注 |
|------------|-----------|-------------|----------|----------|------|
| mdnb_textfield1 | salarySystem | 工资薪制 | 直接映射 | - | 日薪/月薪 |
| mdnb_amountfield2 | positionSalaryBase | 岗位工资基值 | 直接映射 | - | 默认700 |
| mdnb_decimalfield1 | positionCoefficient | 岗位系数 | 直接映射 | - | 1.0-6.0 |
| mdnb_decimalfield2 | techPositionAdjustCoefficient | 专业技术人员岗位调节系数 | 直接映射 | - | 1.0/1.1/1.2 |
| mdnb_decimalfield3 | undergroundHealthCoefficient | 井下职业健康岗位工资系数 | 直接映射 | - | 1.0/1.2/1.4/1.6/1.8 |
| mdnb_textfield2 | senioritySalaryStandard | 年功工资标准 | 直接映射 | - | 新标准/旧标准 |

## 考勤数据映射

### 考勤工数字段

| Excel字段名 | Web字段名 | 中文显示名称 | 映射类型 | 显示格式 | 验证规则 |
|------------|-----------|-------------|----------|----------|----------|
| mdnb_decimalfield5 | systemWorkDays | 制度工日工数 | 直接映射 | 整数 | 0-25 |
| mdnb_decimalfield22 | businessTripDays | 公出工数 | 直接映射 | 整数 | 0-25 |
| mdnb_decimalfield19 | trainingDays | 学习工数 | 直接映射 | 整数 | 0-25 |
| mdnb_decimalfield8 | paidAnnualLeave | 带薪年休假 | 直接映射 | 整数 | 0-15 |
| mdnb_decimalfield9 | marriageLeave | 婚假 | 直接映射 | 整数 | 0-25 |
| mdnb_decimalfield14 | familyVisitLeave | 探亲假 | 直接映射 | 整数 | 0-25 |
| mdnb_decimalfield10 | propertyLeave | 有资产假 | 直接映射 | 整数 | 0-25 |
| mdnb_decimalfield17 | nursingLeave | 哺乳假 | 直接映射 | 整数 | 0-25 |
| mdnb_decimalfield13 | bereavementLeave | 丧假 | 直接映射 | 整数 | 0-25 |
| mdnb_decimalfield12 | sickLeave | 病假 | 直接映射 | 整数 | 0-25 |
| mdnb_decimalfield20 | otherPaidLeave | 其他有资假 | 直接映射 | 整数 | 0-25 |
| mdnb_amountfield4 | otherPaidLeaveSalary | 其他有资假工资 | 直接映射 | 货币格式 | ≥0 |
| mdnb_textfield5 | paidLeaveRemarks | 有资假备注 | 直接映射 | 文本 | - |
| mdnb_decimalfield18 | personalLeave | 事假 | 直接映射 | 整数 | 0-25 |
| mdnb_decimalfield21 | absence | 旷工 | 直接映射 | 整数 | 0-25 |
| mdnb_decimalfield26 | undergroundDays | 下井工数 | 直接映射 | 整数 | 0-31 |
| mdnb_decimalfield27 | nightShiftDays | 前夜班工数 | 直接映射 | 整数 | 0-31 |
| mdnb_decimalfield24 | lateNightShiftDays | 后夜班工数 | 直接映射 | 整数 | 0-31 |
| mdnb_decimalfield28 | groundProductionNightDays | 地面生产夜班工数 | 直接映射 | 整数 | 0-31 |
| mdnb_decimalfield25 | groundNonProductionNightDays | 地面非生产夜班工数 | 直接映射 | 整数 | 0-31 |
| mdnb_decimalfield29 | onDutyDays | 值班天数 | 直接映射 | 整数 | 0-31 |
| mdnb_decimalfield7 | weekendWorkDays | 公休日出勤工数 | 直接映射 | 整数 | 0-4 |
| mdnb_decimalfield11 | holidayWorkDays | 节假日出勤工数 | 直接映射 | 整数 | 0-5 |

### 考勤统计字段

| Web字段名 | 计算公式 | 显示格式 | 说明 |
|-----------|----------|----------|------|
| overtimeWorkDays | weekendWorkDays + holidayWorkDays | 整数 | 加班工数总计 |
| ptoDays | paidAnnualLeave + trainingDays + marriageLeave + familyVisitLeave + propertyLeave + bereavementLeave + sickLeave + otherPaidLeave | 整数 | 有资假工数总计 |

## 绩效数据映射

| Excel字段名 | Web字段名 | 中文显示名称 | 映射类型 | 显示格式 |
|------------|-----------|-------------|----------|----------|
| mdnb_amountfield25 | performanceAllocation | 绩效分配金额 | 直接映射 | 货币格式 |
| mdnb_amountfield26 | performanceSupplement | 绩效补发金额 | 直接映射 | 货币格式 |
| mdnb_amountfield27 | assessmentDeduction | 考核奖扣工资 | 直接映射 | 货币格式(可负) |

## 津贴补贴映射

| Excel字段名 | Web字段名 | 中文显示名称 | 映射类型 | 显示格式 |
|------------|-----------|-------------|----------|----------|
| mdnb_decimalfield4 | undergroundAdjustedYears | 井下折算调整工龄 | 直接映射 | 整数 |
| mdnb_amountfield3 | dutyAllowanceStandard | 值班津贴标准 | 直接映射 | 货币格式 |
| mdnb_amountfield58 | undergroundAllowanceStandard | 入井津贴标准 | 直接映射 | 货币格式 |
| mdnb_amountfield1 | retainedSalary | 保留工资 | 直接映射 | 货币格式 |
| mdnb_amountfield64 | supplementSalary | 补差工资 | 直接映射 | 货币格式 |
| mdnb_amountfield30 | highAltitudeAllowance | 高温高空津贴 | 直接映射 | 货币格式 |
| mdnb_amountfield31 | fieldWorkAllowance | 野外施工津贴 | 直接映射 | 货币格式 |
| mdnb_amountfield32 | hazardousAllowance | 有毒有害津贴 | 直接映射 | 货币格式 |
| mdnb_amountfield33 | weldingAllowance | 电焊津贴 | 直接映射 | 货币格式 |
| mdnb_amountfield34 | halalFoodAllowance | 回族伙食津贴 | 直接映射 | 货币格式 |
| mdnb_amountfield35 | transportAllowance | 交通补助 | 直接映射 | 货币格式 |
| mdnb_amountfield36 | communicationAllowance | 通讯补助 | 直接映射 | 货币格式 |
| mdnb_amountfield38 | otherAllowances | 其他津补贴 | 直接映射 | 货币格式 |

## 计件工资映射

| Excel字段名 | Web字段名 | 中文显示名称 | 映射类型 | 显示格式 |
|------------|-----------|-------------|----------|----------|
| mdnb_decimalfield200 | workPoints | 工分 | 直接映射 | 整数 |
| mdnb_decimalfield300 | unitPrice | 单价 | 直接映射 | 数值(5位小数) |
| mdnb_amountfield300 | pieceworkSalary | 计件工资 | 直接映射 | 货币格式 |

## 奖励扣罚映射

| Excel字段名 | Web字段名 | 中文显示名称 | 映射类型 | 显示格式 |
|------------|-----------|-------------|----------|----------|
| mdnb_amountfield40 | striverSpecialIncentive | 奋斗者专项激励 | 直接映射 | 货币格式 |
| mdnb_amountfield41 | contributionIncome | 贡献收入 | 直接映射 | 货币格式 |
| mdnb_amountfield39 | penaltyDeduction | 扣罚工资 | 直接映射 | 货币格式(可负) |
| mdnb_textfield6 | penaltyDeductionRemarks | 扣罚工资备注 | 直接映射 | 文本 |

## 系统计算字段映射

### 基础核算字段

| Web字段名 | 计算公式 | 显示格式 | 说明 |
|-----------|----------|----------|------|
| dailySalary | positionSalaryBase × positionCoefficient × techPositionAdjustCoefficient ÷ 21.75 | 货币格式 | 日资 |
| positionSalary | salarySystem === '日薪' ? dailySalary × systemWorkDays : positionSalaryBase × positionCoefficient × techPositionAdjustCoefficient | 货币格式 | 岗位工资 |
| undergroundHealthSalary | positionSalary × (undergroundHealthCoefficient - 1) | 货币格式 | 井下职业健康岗位工资 |
| senioritySalary | 根据senioritySalaryStandard和groupWorkYears计算 | 货币格式 | 年功工资 |
| overtimeSalaryTotal | dailySalary × weekendWorkDays × 2 + dailySalary × holidayWorkDays × 3 | 货币格式 | 加班工资合计 |
| annualLeaveSalary | dailySalary × paidAnnualLeave | 货币格式 | 年休假工资 |
| trainingSalary | dailySalary × trainingDays | 货币格式 | 培训工资 |
| marriageLeaveSalary | dailySalary × marriageLeave | 货币格式 | 婚假工资 |
| familyVisitLeaveSalary | dailySalary × familyVisitLeave | 货币格式 | 探亲假工资 |
| propertyLeaveSalary | dailySalary × propertyLeave | 货币格式 | 有资产假工资 |
| bereavementLeaveSalary | dailySalary × bereavementLeave | 货币格式 | 丧假工资 |
| sickLeaveSalary | dailySalary × sickLeave × 病假工资系数 | 货币格式 | 病假工资 |
| workInjuryLeaveSalary | dailySalary × workInjuryLeave | 货币格式 | 工伤假工资 |
| undergroundAllowance | undergroundDays × undergroundAllowanceStandard | 货币格式 | 下井津贴 |
| nightShiftAllowance | nightShiftDays × 18 + lateNightShiftDays × 20 | 货币格式 | 夜班津贴 |
| dutyAllowance | onDutyDays × dutyAllowanceStandard | 货币格式 | 值班津贴 |

### 合计项目字段

| Web字段名 | 计算公式 | 显示格式 | 说明 |
|-----------|----------|----------|------|
| paidLeaveSalaryTotal | annualLeaveSalary + trainingSalary + marriageLeaveSalary + familyVisitLeaveSalary + propertyLeaveSalary + bereavementLeaveSalary + sickLeaveSalary + workInjuryLeaveSalary + otherPaidLeaveSalary | 货币格式 | 带薪假类工资合计 |
| auxiliarySalaryTotal | retainedSalary + supplementSalary + undergroundAllowance + nightShiftAllowance + dutyAllowance + highAltitudeAllowance + fieldWorkAllowance + hazardousAllowance + weldingAllowance + halalFoodAllowance + transportAllowance + communicationAllowance + otherAllowances | 货币格式 | 辅助工资合计 |
| performanceSalaryTotal | performanceAllocation + performanceSupplement + assessmentDeduction + pieceworkSalary | 货币格式 | 绩效工资合计 |
| grossSalary | positionSalary + undergroundHealthSalary + senioritySalary + overtimeSalaryTotal + paidLeaveSalaryTotal + auxiliarySalaryTotal + performanceSalaryTotal + striverSpecialIncentive + contributionIncome + penaltyDeduction | 货币格式 | 应领工资 |
| personalDeductionTotal | pensionInsurancePersonal + medicalInsurancePersonal + unemploymentInsurancePersonal + housingFundPersonal + annuityPersonal + mutualAidPersonal | 货币格式 | 个人代扣代缴合计 |
| netSalary | grossSalary - personalDeductionTotal - personalIncomeTax + oneChildAllowance + femaleHygieneAllowance | 货币格式 | 实领工资 |

## 数据类型转换规则

### 数值类型转换

| 原类型 | 目标类型 | 转换规则 | 示例 |
|--------|----------|----------|------|
| 整数 | 货币格式 | 保留2位小数，千分位分隔符 | 1234 → 1,234.00 |
| 浮点数 | 货币格式 | 保留2位小数，千分位分隔符 | 1234.5 → 1,234.50 |
| 浮点数(5位小数) | 数值格式 | 保留5位小数 | 12.34567 → 12.34567 |
| 数值 | 百分比 | 保留1位小数，加%符号 | 0.15 → 15.0% |

### 字符串类型转换

| 原类型 | 目标类型 | 转换规则 | 示例 |
|--------|----------|----------|------|
| 字符串 | 日期 | YYYY-MM-DD格式 | 2024-12-07 |
| 字符串 | 布尔值 | 是/否显示 | "true" → "是" |
| 枚举值 | 中文显示 | 映射表转换 | "日薪" → "日薪制" |

### 颜色标识规则

| 数值范围 | 颜色标识 | 说明 |
|----------|----------|------|
| > 0 | 黑色 (#000000) | 正数 |
| < 0 | 红色 (#DC3545) | 负数 |
| = 0 | 灰色 (#6C757D) | 零值 |
| null/undefined | 浅灰色 (#E9ECEF) | 空值 |

## 字段验证映射

### Excel导入验证

| 字段名 | 验证规则 | 错误提示 |
|--------|----------|----------|
| employeeId | 非空且唯一 | 员工编码不能为空且不能重复 |
| employeeName | 非空 | 员工姓名不能为空 |
| idCardNumber | 身份证格式 | 身份证号格式不正确 |
| salarySystem | 枚举验证(日薪/月薪) | 工资薪制只能是日薪或月薪 |
| positionCoefficient | 范围验证(1.0-6.0) | 岗位系数必须在1.0-6.0之间 |
| undergroundCoefficient | 枚举验证 | 井下系数只能是1.0、1.2、1.4、1.6、1.8 |

### Web界面验证

| 字段名 | 验证规则 | 错误提示 |
|--------|----------|----------|
| grossSalary | 必须≥0 | 应发工资不能为负数 |
| netSalary | 必须≥0 | 实发工资不能为负数 |
| systemWorkDays | 范围验证(0-25) | 制度工日工数不能超过25天 |
| undergroundDays | 范围验证(0-31) | 下井工数不能超过31天 |

## 映射更新机制

###
当Excel模板字段发生变化 自动1. 检测字段映射关系
时，系统会自动：
2. 更新Web界面字段显示映射更新
3. 验证映射关系的有效性
4. 提示用户确认映射变更

### 手动映射调整
用户可以通过以下方式调整映射：
1. 在Web界面中修改字段显示名称
2. 调整字段显示顺序
3. 设置字段的可见性
4. 自定义字段的格式化规则

### 映射版本控制
系统会记录每次映射关系的变更：
- 变更时间
- 变更内容
- 变更人员
- 回滚方式

## 注意事项

1. **字段一致性**: 所有系统中的字段名必须保持一致
2. **计算精度**: 所有计算结果保留2位小数
3. **类型安全**: 数据类型转换时必须进行安全检查
4. **性能考虑**: 大量数据映射时注意性能优化
5. **向后兼容**: 新增字段时保持向后兼容性
6. **国际化**: 所有显示文本支持国际化
7. **可扩展性**: 映射关系支持灵活配置和扩展

## 常见问题

### Q1: Excel中新增字段如何在Web界面显示？
**A**: 需要在17-字段映射.md中添加映射关系，并更新Web界面的字段配置。

### Q2: 如何处理字段类型不匹配的情况？
**A**: 在转换规则中定义明确的类型转换逻辑，并在验证阶段进行检查。

### Q3: 如何优化大量数据的映射性能？
**A**: 采用分批处理、懒加载、缓存等技术手段。

### Q4: 如何保证映射关系的安全性？
**A**: 对映射配置进行版本控制，并提供回滚机制。
