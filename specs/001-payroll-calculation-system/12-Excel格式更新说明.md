# Excel格式更新说明 - PayrollMaster系统

## 📋 更新概览

**更新日期**: 2025-12-09  
**功能分支**: `001-payroll-calculation-system`  
**更新类型**: Excel文件格式规范制定

---

## ⚠️ 重要说明

**Excel文件采用双层表头格式**：

```
第1行：英文字段名   employeeId | name | department | position | basicSalary
第2行：中文字段名   员工工号   | 姓名  | 部门       | 职位     | 基本薪资
第3行：实际数据     EMP001    | 张三  | 技术部      | 高级工程师 | 15000
```

**解析规则**：
1. 第1行英文字段名用于系统内部字段映射
2. 第2行中文字段名用于用户界面显示
3. **第3行开始才是实际数据**

---

## ✅ 已更新文档

### 1. 前端设计规范
**文件**: `frontend-design-02-功能规格说明书.md`
- ✅ 在员工列表页面部分添加Excel文件格式说明
- ✅ 添加解析逻辑和代码实现示例
- ✅ 说明双层表头的重要性

### 2. 快速入门指南
**文件**: `06-快速开始指南.md`
- ✅ 更新步骤2中的Excel导入说明
- ✅ 明确说明双层表头格式
- ✅ 添加解析规则说明

### 3. 数据模型设计
**文件**: `04-数据模型设计.md`
- ✅ 新增"Excel字段映射"章节
- ✅ 提供完整字段映射表（15个字段）
- ✅ 添加Excel解析示例代码
- ✅ 说明英文字段名到数据库字段的映射

### 4. API契约文档
**文件**: `contracts/42-API端点规范.md`
- ✅ 在3.1节"上传Excel文件"中添加格式要求
- ✅ 添加字段映射规则说明
- ✅ 提供示例Excel文件结构

### 5. Excel格式规范（新增）
**文件**: `excel-format-02-功能规格说明书.md` ⭐
- ✅ 15000+字详细规范文档
- ✅ 完整字段映射表
- ✅ 数据验证规则
- ✅ 错误处理机制
- ✅ 技术实现示例
- ✅ 最佳实践和FAQ

---

## 📊 字段映射表

### 员工数据字段映射

| 英文字段名 | 数据库字段名 | 中文字段名 | 必填 | 类型 |
|------------|--------------|------------|------|------|
| employeeId | employee_id | 员工工号 | ✓ | string |
| name | name | 姓名 | ✓ | string |
| department | department | 部门 | ✓ | string |
| position | position | 职位 | ✓ | string |
| basicSalary | basic_salary | 基本薪资 | ✓ | decimal |
| hireDate | hire_date | 入职日期 | ✓ | date |
| bankAccount | bank_account | 银行账号 | - | string |
| idCard | id_card | 身份证号 | - | string |
| phone | phone | 联系电话 | - | string |
| email | email | 邮箱 | - | string |
| attendanceDays | attendance_days | 出勤天数 | - | integer |
| overtimeHours | overtime_hours | 加班小时数 | - | decimal |
| lateCount | late_count | 迟到次数 | - | integer |
| sickLeaveDays | sick_leave_days | 病假天数 | - | integer |
| personalLeaveDays | personal_leave_days | 事假天数 | - | integer |

---

## 🔧 技术实现

### 前端解析示例

```typescript
const parseExcelHeaders = (worksheet: any) => {
  const headers = []
  for (let col = 1; col <= worksheet.maxColumn; col++) {
    const englishName = worksheet.getCell(1, col).value
    const chineseName = worksheet.getCell(2, col).value
    headers.push({
      english: englishName,
      chinese: chineseName,
      key: englishName.toLowerCase().replace(/[^a-z0-9]/g, '_')
    })
  }
  return headers
}
```

### 后端解析示例

```python
def parse_employee_excel(file_path: str) -> Tuple[List[Dict], Dict]:
    workbook = load_workbook(file_path, read_only=True)
    worksheet = workbook.active

    # 读取表头（第1-2行）
    headers = ExcelParser._parse_headers(worksheet)

    # 读取数据（第3行开始）
    data = ExcelParser._parse_data(worksheet, headers)

    return data, headers
```

---

## 🎯 影响范围

### 需要更新的文件

1. **Excel模板文件**
   - `excel-templates/import/employee-template.xlsx`
   - `excel-templates/import/attendance-template.xlsx`

2. **代码文件**
   - 前端Excel上传组件
   - 后端Excel解析服务
   - 数据验证器

3. **测试文件**
   - Excel导入测试用例
   - 数据验证测试

---

## 📝 验证规则

### 必填字段
- employeeId, name, department, position, basicSalary, hireDate

### 数据格式
- employeeId: 5-20位字母或数字
- email: 符合RFC 5322标准
- phone: 11位数字
- basicSalary: ≥0的数值
- hireDate: YYYY-MM-DD格式

### 业务规则
- employeeId必须唯一
- hireDate不能是未来日期
- 考勤数据不能为负数

---

## ❓ 常见问题

### Q1: 为什么需要双层表头？

**A**: 
- 英文字段名便于系统内部处理和字段映射
- 中文字段名提升用户体验，便于理解
- 为国际化预留空间

### Q2: 可以修改字段名吗？

**A**: 
- 不建议修改英文字段名（用于系统映射）
- 可以调整中文字段名（仅用于显示）
- 使用官方模板最安全

### Q3: 最大支持多少行数据？

**A**: 
- .xlsx: 最大1,048,576行
- 推荐单次导入不超过1,000条记录

---

## 📚 相关文档

| 文档名称 | 路径 | 说明 |
|----------|------|------|
| Excel格式规范 | `excel-format-02-功能规格说明书.md` | **完整技术规范** |
| 前端设计规范 | `frontend-design-02-功能规格说明书.md` | UI设计说明 |
| 快速入门指南 | `06-快速开始指南.md` | 用户操作指南 |
| 数据模型 | `04-数据模型设计.md` | 字段映射详情 |
| API契约 | `contracts/42-API端点规范.md` | 接口说明 |

---

## ✨ 总结

本次更新建立了完整的Excel文件格式规范，确保：

✅ **数据一致性**: 双层表头确保前后端数据同步  
✅ **用户友好**: 中文字段名便于理解  
✅ **系统兼容**: 英文字段名便于处理  
✅ **验证完整**: 完整的验证规则和错误处理  
✅ **文档齐全**: 5个文档全面覆盖  

所有相关文档已更新完成，可直接用于开发！ 🎉
