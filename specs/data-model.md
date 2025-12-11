# 数据模型设计文档 - PayrollMaster薪资自动核算系统

## 概述

本文档定义了PayrollMaster系统的完整数据模型，包括所有实体、字段、关系和验证规则。数据模型基于PostgreSQL数据库，使用SQLModel ORM进行实现。

## 核心实体

### 1. 部门信息 (Department)

存储部门基础信息和分类数据，是薪资管理的基础数据。

```python
from sqlmodel import SQLModel, Field, Relationship
from typing import Optional, List
from datetime import datetime, date

class Department(SQLModel, table=True):
    """部门基础信息模型"""
    id: Optional[int] = Field(default=None, primary_key=True)
    departmentId: str = Field(index=True, unique=True, description="部门编码")
    departmentName: str = Field(description="部门名称")
    departmentType: str = Field(description="部门类别")
    departmentSubType: str = Field(description="部门二级类别")
    parentDepartmentId: Optional[int] = Field(default=None, foreign_key="department.id", description="上级部门ID")

    # 时间戳
    createdAt: datetime = Field(default_factory=datetime.now)
    updatedAt: datetime = Field(default_factory=datetime.now)

    # 关系
    employees: List["Employee"] = Relationship(back_populates="department")

    class Config:
        json_schema_extra = {
            "example": {
                "departmentId": "TECH001",
                "departmentName": "技术部",
                "departmentType": "技术",
                "departmentSubType": "软件开发"
            }
        }
```

### 2. 员工信息 (Employee)

存储员工基础信息和薪资标准数据。

```python
class Employee(SQLModel, table=True):
    """员工基础信息模型"""
    id: Optional[int] = Field(default=None, primary_key=True)
    employeeId: str = Field(index=True, unique=True, description="员工工号")
    employeeName: str = Field(description="员工姓名")
    idCardNumber: str = Field(description="身份证号")
    originalEmployeeId: str = Field(description="原系统员工ID")

    # 部门关联
    departmentId: int = Field(foreign_key="department.id", index=True, description="部门ID")

    # 岗位信息
    employeeJob: str = Field(description="岗位工种")
    jobType: str = Field(description="岗位类别")
    jobPosition: str = Field(description="职务类别")

    # 薪资标准
    salarySystem: str = Field(description="工资薪制（日薪/月薪）")
    positionSalaryBase: float = Field(default=700, description="岗位工资基值")
    positionCoefficient: float = Field(default=1.0, description="岗位系数")
    techPositionAdjustCoefficient: float = Field(default=1.0, description="专业技术人员岗位调节系数")
    undergroundHealthCoefficient: float = Field(default=1.0, description="井下职业健康岗位工资系数")
    senioritySalaryStandard: str = Field(description="年功工资标准（新标准/旧标准）")
    undergroundAdjustedYears: int = Field(default=0, description="井下折算调整工龄")

    # 工龄数据
    groupWorkYears: int = Field(description="集团工龄")
    undergroundWorkYears: int = Field(description="入井年限")

    # 津贴标准
    dutyAllowanceStandard: float = Field(default=0, description="值班津贴标准")
    undergroundAllowanceStandard: float = Field(default=0, description="入井津贴标准（0/45/60）")

    # 银行和证件
    bankAccount: Optional[str] = Field(default=None, description="银行账号")
    phone: Optional[str] = Field(default=None, description="联系电话")
    email: Optional[str] = Field(default=None, description="邮箱")

    # 入职信息
    hireDate: date = Field(description="入职日期")

    # 保留工资
    retainedSalary: float = Field(default=0, description="保留工资（单位核定的固定工资项）")

    # 时间戳
    createdAt: datetime = Field(default_factory=datetime.now)
    updatedAt: datetime = Field(default_factory=datetime.now)

    # 关系
    department: Optional[Department] = Relationship(back_populates="employees")
    attendanceRecords: List["AttendanceRecord"] = Relationship(back_populates="employee")
    performanceRecords: List["PerformanceRecord"] = Relationship(back_populates="employee")
    allowanceRecords: List["AllowanceRecord"] = Relationship(back_populates="employee")
    rewardRecords: List["RewardRecord"] = Relationship(back_populates="employee")
    deductionRecords: List["DeductionRecord"] = Relationship(back_populates="employee")
    salaryCalculations: List["SalaryCalculation"] = Relationship(back_populates="employee")

    class Config:
        json_schema_extra = {
            "example": {
                "employeeId": "RYJM-0000137269",
                "name": "张三",
                "idCardNumber": "110101199001011234",
                "originalEmployeeId": "12345",
                "departmentId": 1,
                "employeeJob": "软件工程师",
                "jobType": "技术",
                "jobPosition": "高级",
                "salarySystem": "日薪",
                "positionSalaryBase": 700,
                "positionCoefficient": 2.5,
                "techPositionAdjustCoefficient": 1.1,
                "undergroundHealthCoefficient": 1.0,
                "senioritySalaryStandard": "新标准",
                "groupWorkYears": 5,
                "undergroundWorkYears": 0,
                "retainedSalary":256,
                "hireDate": "2020-01-15"
            }
        }
```

### 3. 月度考勤记录 (AttendanceRecord)

存储员工月度考勤数据，按月记录。**仅包含考勤相关数据**。

```python
class AttendanceRecord(SQLModel, table=True):
    """月度考勤记录模型 - 仅包含考勤数据"""
    id: Optional[int] = Field(default=None, primary_key=True)
    employeeId: int = Field(foreign_key="employee.id", index=True, description="员工ID")
    attendanceYear: int = Field(description="考勤年份")
    attendanceMonth: int = Field(description="考勤月份")

    # 制度工日
    systemWorkDays: float = Field(default=0, description="制度工日工数")
    businessTripDays: float = Field(default=0, description="公出工数")

    # 带薪假期
    trainingDays: float = Field(default=0, description="学习工数")
    paidAnnualLeave: float = Field(default=0, description="带薪年休假")
    marriageLeave: float = Field(default=0, description="婚假")
    familyVisitLeave: float = Field(default=0, description="探亲假")
    propertyLeave: float = Field(default=0, description="有资产假")
    nursingLeave: float = Field(default=0, description="哺乳假")
    bereavementLeave: float = Field(default=0, description="丧假")
    sickLeave: float = Field(default=0, description="病假")
    otherPaidLeave: float = Field(default=0, description="其他有资假")
    otherPaidLeaveSalary: float = Field(default=0, description="其他有资假工资")
    paidLeaveRemarks: Optional[str] = Field(default=None, description="有资假备注")

    # 无薪假期
    personalLeave: float = Field(default=0, description="事假")
    absence: float = Field(default=0, description="旷工")

    # 工作日数据
    undergroundDays: float = Field(default=0, description="下井工数")
    nightShiftDays: float = Field(default=0, description="前夜班工数")
    lateNightShiftDays: float = Field(default=0, description="后夜班工数")
    groundProductionNightDays: float = Field(default=0, description="地面生产夜班工数")
    groundNonProductionNightDays: float = Field(default=0, description="地面非生产夜班工数")
    onDutyDays: float = Field(default=0, description="值班天数")

    # 加班数据
    weekendWorkDays: float = Field(default=0, description="公休日出勤工数")
    holidayWorkDays: float = Field(default=0, description="节假日出勤工数")

    # 时间戳
    createdAt: datetime = Field(default_factory=datetime.now)
    updatedAt: datetime = Field(default_factory=datetime.now)

    # 关系
    employee: Optional[Employee] = Relationship(back_populates="attendanceRecords")
    performanceRecord: Optional["PerformanceRecord"] = Relationship(back_populates="attendanceRecord")
    allowanceRecord: Optional["AllowanceRecord"] = Relationship(back_populates="attendanceRecord")
    rewardRecord: Optional["RewardRecord"] = Relationship(back_populates="attendanceRecord")
    deductionRecord: Optional["DeductionRecord"] = Relationship(back_populates="attendanceRecord")

    class Config:
        json_schema_extra = {
            "example": {
                "employeeId": 1,
                "attendanceYear": 2025,
                "attendanceMonth": 12,
                "systemWorkDays": 22,
                "trainingDays": 1,
                "paidAnnualLeave": 3,
                "sickLeave": 1,
                "weekendWorkDays": 2,
                "holidayWorkDays": 1,
                "undergroundDays": 10,
                "nightShiftDays": 5
            }
        }
```

### 4. 月度绩效记录 (PerformanceRecord)

存储员工月度绩效数据，包括绩效分配、考核评分等。

```python
class PerformanceRecord(SQLModel, table=True):
    """月度绩效记录模型"""
    id: Optional[int] = Field(default=None, primary_key=True)
    employeeId: int = Field(foreign_key="employee.id", index=True, description="员工ID")
    attendanceYear: int = Field(description="绩效年份")
    attendanceMonth: int = Field(description="绩效月份")

    # 绩效数据
    performanceAllocation: float = Field(default=0, description="绩效分配金额")
    performanceSupplement: float = Field(default=0, description="绩效补发金额")
    assessmentDeduction: float = Field(default=0, description="考核奖扣工资")

    # 考核数据
    safetyStructureCoefficient: float = Field(default=100, description="安全结构工资系数")
    seniorityAssessmentScore: float = Field(default=100, description="年功工资考核打分")
    undergroundHealthAssessmentScore: float = Field(default=100, description="井下职业健康岗位工资考核打分")

    # 计件工资
    workPoints: int = Field(default=0, description="工分")
    unitPrice: float = Field(default=0, description="单价")

    # 备注
    remarks: Optional[str] = Field(default=None, description="备注")

    # 时间戳
    createdAt: datetime = Field(default_factory=datetime.now)
    updatedAt: datetime = Field(default_factory=datetime.now)

    # 关系
    employee: Optional[Employee] = Relationship(back_populates="performanceRecords")
    attendanceRecord: Optional[AttendanceRecord] = Relationship(back_populates="performanceRecord")

    class Config:
        json_schema_extra = {
            "example": {
                "employeeId": 1,
                "attendanceYear": 2025,
                "attendanceMonth": 12,
                "performanceAllocation": 1500,
                "workPoints": 1000,
                "unitPrice": 0.5
            }
        }
```

### 5. 月度津贴记录 (AllowanceRecord)

存储员工月度各类津贴数据。

```python
class AllowanceRecord(SQLModel, table=True):
    """月度津贴记录模型"""
    id: Optional[int] = Field(default=None, primary_key=True)
    employeeId: int = Field(foreign_key="employee.id", index=True, description="员工ID")
    attendanceYear: int = Field(description="津贴年份")
    attendanceMonth: int = Field(description="津贴月份")

    # 各类津贴
    highAltitudeAllowance: float = Field(default=0, description="高温高空津贴")
    fieldWorkAllowance: float = Field(default=0, description="野外施工津贴")
    hazardousAllowance: float = Field(default=0, description="有毒有害津贴")
    weldingAllowance: float = Field(default=0, description="电焊津贴")
    halalFoodAllowance: float = Field(default=0, description="回族伙食津贴")
    transportAllowance: float = Field(default=0, description="交通补助")
    communicationAllowance: float = Field(default=0, description="通讯补助")
    otherAllowances: float = Field(default=0, description="其他津补贴")

    # 补差工资
    supplementSalary: float = Field(default=0, description="补差工资（月度变动）")

    # 备注
    remarks: Optional[str] = Field(default=None, description="备注")

    # 时间戳
    createdAt: datetime = Field(default_factory=datetime.now)
    updatedAt: datetime = Field(default_factory=datetime.now)

    # 关系
    employee: Optional[Employee] = Relationship(back_populates="allowanceRecords")
    attendanceRecord: Optional[AttendanceRecord] = Relationship(back_populates="allowanceRecord")

    class Config:
        json_schema_extra = {
            "example": {
                "employeeId": 1,
                "attendanceYear": 2025,
                "attendanceMonth": 12,
                "highAltitudeAllowance": 200,
                "transportAllowance": 150
            }
        }
```

### 6. 月度奖励记录 (RewardRecord)

存储员工月度奖励数据。

```python
class RewardRecord(SQLModel, table=True):
    """月度奖励记录模型"""
    id: Optional[int] = Field(default=None, primary_key=True)
    employeeId: int = Field(foreign_key="employee.id", index=True, description="员工ID")
    attendanceYear: int = Field(description="奖励年份")
    attendanceMonth: int = Field(description="奖励月份")

    # 奖励项目
    striverSpecialIncentive: float = Field(default=0, description="奋斗者专项激励")
    contributionIncome: float = Field(default=0, description="贡献收入")
    otherRewards: float = Field(default=0, description="其他奖励")

    # 备注
    remarks: Optional[str] = Field(default=None, description="奖励备注")

    # 时间戳
    createdAt: datetime = Field(default_factory=datetime.now)
    updatedAt: datetime = Field(default_factory=datetime.now)

    # 关系
    employee: Optional[Employee] = Relationship(back_populates="rewardRecords")
    attendanceRecord: Optional[AttendanceRecord] = Relationship(back_populates="rewardRecord")

    class Config:
        json_schema_extra = {
            "example": {
                "employeeId": 1,
                "attendanceYear": 2025,
                "attendanceMonth": 12,
                "striverSpecialIncentive": 500,
                "contributionIncome": 300
            }
        }
```

### 7. 月度扣款记录 (DeductionRecord)

存储员工月度扣款数据。

```python
class DeductionRecord(SQLModel, table=True):
    """月度扣款记录模型"""
    id: Optional[int] = Field(default=None, primary_key=True)
    employeeId: int = Field(foreign_key="employee.id", index=True, description="员工ID")
    attendanceYear: int = Field(description="扣款年份")
    attendanceMonth: int = Field(description="扣款月份")

    # 扣罚项目
    penaltyDeduction: float = Field(default=0, description="扣罚工资（补扣工资）")
    penaltyDeductionRemarks: Optional[str] = Field(default=None, description="扣罚工资备注")

    # 社保（个人）
    pensionInsurancePersonal: float = Field(default=0, description="养老保险（个人）")
    medicalInsurancePersonal: float = Field(default=0, description="医疗保险（个人）")
    unemploymentInsurancePersonal: float = Field(default=0, description="失业保险（个人）")
    housingFundPersonal: float = Field(default=0, description="住房公积金（个人）")
    annuityPersonal: float = Field(default=0, description="企业年金（个人）")
    mutualAidPersonal: float = Field(default=0, description="互助金（个人）")

    # 税后项目
    personalIncomeTax: float = Field(default=0, description="个人所得税")
    oneChildAllowance: float = Field(default=0, description="独生子女费")
    femaleHygieneAllowance: float = Field(default=0, description="女工卫生费")

    # 时间戳
    createdAt: datetime = Field(default_factory=datetime.now)
    updatedAt: datetime = Field(default_factory=datetime.now)

    # 关系
    employee: Optional[Employee] = Relationship(back_populates="deductionRecords")
    attendanceRecord: Optional[AttendanceRecord] = Relationship(back_populates="deductionRecord")

    class Config:
        json_schema_extra = {
            "example": {
                "employeeId": 1,
                "attendanceYear": 2025,
                "attendanceMonth": 12,
                "penaltyDeduction": 100,
                "pensionInsurancePersonal": 433.26,
                "personalIncomeTax": 123.45
            }
        }
```

### 8. 薪资计算规则 (PayrollRule)

可配置的薪资计算规则模板，支持多种计算方式。

```python
class PayrollRule(SQLModel, table=True):
    """薪资计算规则模型"""
    id: Optional[int] = Field(default=None, primary_key=True)
    ruleName: str = Field(description="规则名称")
    ruleType: str = Field(description="规则类型：bonus/deduction/overtime/tax/insurance")

    # 计算配置
    calculationType: str = Field(description="计算类型：fixed/percentage/formula")
    value: Optional[float] = Field(default=None, description="固定金额或百分比值")
    formula: Optional[str] = Field(default=None, description="自定义计算公式")

    # 条件配置
    conditionField: Optional[str] = Field(default=None, description="条件字段名")
    conditionOperator: Optional[str] = Field(default=None, description="条件操作符：>/</=/>=/<=/!=/in")
    conditionValue: Optional[str] = Field(default=None, description="条件值")

    # 状态
    isActive: bool = Field(default=True, description="是否启用")
    description: Optional[str] = Field(default=None, description="规则描述")

    createdAt: datetime = Field(default_factory=datetime.now)
    updatedAt: datetime = Field(default_factory=datetime.now)

    class Config:
        json_schema_extra = {
            "example": {
                "ruleName": "绩效奖金",
                "ruleType": "bonus",
                "calculationType": "percentage",
                "value": 10.0,
            }
        }
```

### 5. 薪资计算结果 (SalaryCalculation)

存储每次薪资计算的详细结果。

```python
class SalaryCalculation(SQLModel, table=True):
    """薪资计算结果模型"""
    id: Optional[int] = Field(default=None, primary_key=True)
    employeeId: int = Field(foreign_key="employee.id", index=True, description="员工ID")
    attendanceYear: int = Field(description="考勤年份")
    attendanceMonth: int = Field(description="考勤月份")
    calculationDate: date = Field(index=True, description="计算日期（薪资周期）")

    # 系统计算字段
    dailySalary: float = Field(description="日资")
    attendanceDays: int = Field(description="出勤工数")
    ptoDays: int = Field(description="有资假工数")
    positionSalary: float = Field(description="岗位工资")
    undergroundHealthSalary: float = Field(description="井下职业健康岗位工资")
    senioritySalary: int = Field(description="年功工资")
    overtimeSalaryTotal: float = Field(description="加班工资合计")
    annualLeaveSalary: float = Field(description="年休假工资")
    trainingSalary: float = Field(description="培训工资")
    marriageLeaveSalary: float = Field(description="婚假工资")
    familyVisitLeaveSalary: float = Field(description="探亲假工资")
    propertyLeaveSalary: float = Field(description="有资产假工资")
    bereavementLeaveSalary: float = Field(description="丧假工资")
    sickLeaveSalary: float = Field(description="病假工资")
    undergroundAllowance: int = Field(description="下井津贴")
    nightShiftAllowance: int = Field(description="夜班津贴")
    dutyAllowance: int = Field(description="值班津贴")

    # 合计项目
    paidLeaveSalaryTotal: float = Field(description="带薪假类工资合计")
    auxiliarySalaryTotal: int = Field(description="辅助工资合计")
    performanceSalaryTotal: float = Field(description="绩效工资合计")
    safetyStructureSalary: float = Field(description="安全结构工资")
    grossSalary: float = Field(description="应领工资")
    personalDeductionTotal: float = Field(description="个人代扣代缴合计")
    otherDeductions: int = Field(description="其他扣减项目")
    netSalary: float = Field(description="实领工资")

    # 状态
    status: str = Field(default="draft", description="状态：draft/confirmed/paid")
    confirmedBy: Optional[str] = Field(default=None, description="确认人")
    confirmedAt: Optional[datetime] = Field(default=None, description="确认时间")
    notes: Optional[str] = Field(default=None, description="备注")

    createdAt: datetime = Field(default_factory=datetime.now)
    updatedAt: datetime = Field(default_factory=datetime.now)

    # 关系
    employee: Optional[Employee] = Relationship(back_populates="salaryCalculations")

    class Config:
        json_schema_extra = {
            "example": {
                "employeeId": 1,
                "attendanceYear": 2025,
                "attendanceMonth": 12,
                "calculationDate": "2025-12-31",
                "dailySalary": 89.66,
                "attendanceDays": 22,
                "ptoDays": 4,
                "positionSalary": 1950.38,
                "senioritySalary": 400,
                "overtimeSalaryTotal": 538.0,
                "grossSalary": 2888.38,
                "personalDeductionTotal": 433.26,
                "netSalary": 2405.12,
                "status": "draft"
            }
        }
```

### 6. 用户账号 (User)

系统用户和认证信息。采用手机号码登录方式。

```python
class User(SQLModel, table=True):
    """用户账号模型"""
    id: Optional[int] = Field(default=None, primary_key=True)
    phone: str = Field(index=True, unique=True, description="手机号码（登录账号）")
    hashedPassword: str = Field(description="加密密码")
    fullName: str = Field(description="姓名")
    email: Optional[str] = Field(default=None, description="邮箱（非必填）")
    role: str = Field(index=True, description="角色：admin/manager/accountant/employee")

    # 权限
    isActive: bool = Field(default=True, description="是否激活")
    isSuperuser: bool = Field(default=False, description="是否超级管理员")

    # 时间戳
    lastLogin: Optional[datetime] = Field(default=None, description="最后登录时间")
    createdAt: datetime = Field(default_factory=datetime.now)
    updatedAt: datetime = Field(default_factory=datetime.now)

    class Config:
        json_schema_extra = {
            "example": {
                "phone": "13800138000",
                "fullName": "系统管理员",
                "email": "admin@company.com",
                "role": "admin"
            }
        }
```

### 7. 系统日志 (SystemLog)

记录所有关键操作，支持审计追踪。

```python
class SystemLog(SQLModel, table=True):
    """系统日志模型"""
    id: Optional[int] = Field(default=None, primary_key=True)
    userId: Optional[int] = Field(foreign_key="user.id", index=True, description="操作用户ID")
    action: str = Field(index=True, description="操作类型")
    resourceType: str = Field(index=True, description="资源类型")
    resourceId: Optional[int] = Field(default=None, description="资源ID")
    details: Optional[str] = Field(default=None, description="详细信息")
    ipAddress: Optional[str] = Field(default=None, description="IP地址")
    userAgent: Optional[str] = Field(default=None, description="用户代理")

    createdAt: datetime = Field(default_factory=datetime.now, index=True)

    class Config:
        json_schema_extra = {
            "example": {
                "action": "CREATE",
                "resourceType": "Employee",
                "details": "创建员工：张三"
            }
        }
```

### 8. 数据备份记录 (DataBackup)

数据备份和恢复记录。

```python
class DataBackup(SQLModel, table=True):
    """数据备份模型"""
    id: Optional[int] = Field(default=None, primary_key=True)
    backupName: str = Field(description="备份名称")
    backupType: str = Field(description="备份类型：manual/automatic")
    filePath: str = Field(description="备份文件路径")
    fileSize: int = Field(description="文件大小（字节）")
    recordCount: int = Field(description="记录数量")

    # 状态
    status: str = Field(default="pending", description="状态：pending/success/failed")
    errorMessage: Optional[str] = Field(default=None, description="错误信息")

    createdBy: Optional[int] = Field(foreign_key="user.id", description="创建人")
    createdAt: datetime = Field(default_factory=datetime.now)

    class Config:
        json_schema_extra = {
            "example": {
                "backupName": "2025-12-09-full-backup",
                "backupType": "automatic",
                "status": "success"
            }
        }
```

## 实体关系图

```
Department (1) ←→ (N) Employee

Employee (1) ←→ (N) AttendanceRecord
Employee (1) ←→ (N) PerformanceRecord
Employee (1) ←→ (N) AllowanceRecord
Employee (1) ←→ (N) RewardRecord
Employee (1) ←→ (N) DeductionRecord
Employee (1) ←→ (N) SalaryCalculation

AttendanceRecord (1) ←→ (1) PerformanceRecord
AttendanceRecord (1) ←→ (1) AllowanceRecord
AttendanceRecord (1) ←→ (1) RewardRecord
AttendanceRecord (1) ←→ (1) DeductionRecord

User (1) ←→ (N) SystemLog
User (1) ←→ (N) DataBackup

PayrollRule (N) → (1) SalaryCalculation  [通过规则应用]
```

## Excel字段映射

**⚠️ 重要说明**：Excel文件采用双层表头格式

### 员工数据导入格式

Excel文件的前两行作为表头，从第3行开始是实际数据：

| 行号 | 内容 | 说明 |
|------|------|------|
| 第1行 | 英文字段名 | 用于系统内部字段映射 |
| 第2行 | 中文字段名 | 用于用户界面显示 |
| 第3行开始 | 实际数据 | 员工记录 |

### 字段映射表

```python
EMPLOYEE_FIELD_MAPPING = {
    # 英文字段名 : 数据库字段名
    'employeeId': 'employeeId',
    'name': 'name',
    'departmentId': 'departmentId',
    'position': 'position',
    'salarySystem': 'salarySystem',
    'hireDate': 'hireDate',
    'bankAccount': 'bankAccount',
    'idCardNumber': 'idCardNumber',
    'phone': 'phone',
    'email': 'email',
}

# 中文显示名称映射
CHINESE_FIELD_NAMES = {
    'employeeId': '员工工号',
    'name': '姓名',
    'departmentId': '部门编码',
    'position': '职位',
    'salarySystem': '工资薪制',
    'hireDate': '入职日期',
    'bankAccount': '银行账号',
    'idCardNumber': '身份证号',
    'phone': '联系电话',
    'email': '邮箱',
}
```

### Excel解析示例

```python
def parseEmployeeExcel(worksheet):
    """
    解析员工Excel文件
    """
    # 读取字段映射（第1-2行）
    fieldMappings = {}
    chineseNames = {}

    for col in range(1, worksheet.maxColumn + 1):
        englishName = worksheet.cell(row=1, column=col).value
        chineseName = worksheet.cell(row=2, column=col).value
        dbField = EMPLOYEE_FIELD_MAPPING.get(englishName)

        if dbField:
            fieldMappings[col] = dbField
            chineseNames[dbField] = chineseName

    # 读取数据（第3行开始）
    employees = []
    for row in range(3, worksheet.maxRow + 1):
        employeeData = {}
        for col, dbField in fieldMappings.items():
            value = worksheet.cell(row=row, column=col).value
            employeeData[dbField] = value

        if any(employeeData.values()):  # 跳过空行
            employees.append(employeeData)

    return employees, chineseNames
```

## 验证规则

### 字段验证

1. **员工工号**：必须唯一，格式为"RYJM-0000137269"（15位字母数字组合+连字符）
2. **手机号码**：必须唯一，11位数字，以1开头
3. **邮箱**：必须符合RFC 5322标准格式（非必填）
4. **薪资金额**：必须≥0，保留两位小数
5. **日期字段**：不能为未来日期（除入职日期外）
6. **员工ID**：删除员工前必须确保无相关薪资记录

### 业务规则验证

1. **薪资计算一致性**：
   - 实发工资 = 应发工资 - 个人代扣代缴合计 - 个人所得税 + 税后项目
   - 所有金额字段必须保留两位小数

2. **考勤数据合理性**：
   - 出勤天数 ≤ 当月工作日
   - 请假天数 ≥ 0

3. **权限控制**：
   - 只有admin角色可以创建/删除用户
   - 只有admin和manager可以访问薪资计算配置
   - 所有用户只能查看自己负责范围内的薪资数据
   - 登录时使用手机号码进行身份验证

## 索引策略

### 主要索引

1. **Department表**：
   - departmentId (唯一索引)

2. **Employee表**：
   - employeeId (唯一索引)
   - departmentId (普通索引)
   - hireDate (普通索引)

3. **AttendanceRecord表**：
   - employeeId + attendanceYear + attendanceMonth (复合唯一索引)
   - attendanceYear + attendanceMonth (复合索引，用于按周期查询)

4. **PerformanceRecord表**：
   - employeeId + attendanceYear + attendanceMonth (复合唯一索引)
   - performanceAllocation (普通索引，用于绩效排序查询)

5. **AllowanceRecord表**：
   - employeeId + attendanceYear + attendanceMonth (复合唯一索引)

6. **RewardRecord表**：
   - employeeId + attendanceYear + attendanceMonth (复合唯一索引)

7. **DeductionRecord表**：
   - employeeId + attendanceYear + attendanceMonth (复合唯一索引)

8. **SalaryCalculation表**：
   - employeeId + calculationDate (复合索引，用于查询特定员工的薪资历史)
   - calculationDate (普通索引，用于按周期查询)
   - status (普通索引，用于筛选状态)

9. **User表**：
   - phone (唯一索引) - 手机号码作为登录账号
   - email (唯一索引)
   - role (普通索引)

10. **SystemLog表**：
    - userId (普通索引)
    - createdAt (普通索引，用于时间范围查询)
    - action + resourceType (复合索引，用于审计查询)

## 数据完整性

### 外键约束

- `Employee.departmentId` → `Department.id`
- `AttendanceRecord.employeeId` → `Employee.id`
- `PerformanceRecord.employeeId` → `Employee.id`
- `PerformanceRecord.attendanceRecordId` → `AttendanceRecord.id`
- `AllowanceRecord.employeeId` → `Employee.id`
- `AllowanceRecord.attendanceRecordId` → `AttendanceRecord.id`
- `RewardRecord.employeeId` → `Employee.id`
- `RewardRecord.attendanceRecordId` → `AttendanceRecord.id`
- `DeductionRecord.employeeId` → `Employee.id`
- `DeductionRecord.attendanceRecordId` → `AttendanceRecord.id`
- `SalaryCalculation.employeeId` → `Employee.id`
- `SystemLog.userId` → `User.id`
- `DataBackup.createdBy` → `User.id`

### 唯一性约束

- `Department.departmentId` 唯一
- `Employee.employeeId` 唯一
- `User.phone` 唯一 - 手机号码作为登录账号
- `User.email` 唯一
- `AttendanceRecord.employeeId + attendanceYear + attendanceMonth` 唯一
- `PerformanceRecord.employeeId + attendanceYear + attendanceMonth` 唯一
- `AllowanceRecord.employeeId + attendanceYear + attendanceMonth` 唯一
- `RewardRecord.employeeId + attendanceYear + attendanceMonth` 唯一
- `DeductionRecord.employeeId + attendanceYear + attendanceMonth` 唯一

### 检查约束

- 日期字段格式正确
- 状态字段值在允许范围内
- 岗位系数在1.0-6.0之间
- 年功工资标准只能是"新标准"或"旧标准"
- 工资薪制只能是"日薪"或"月薪"
- 手机号码格式：11位数字，以1开头

## 数据迁移

使用Alembic进行数据库版本管理，迁移脚本应包括：

1. 初始表结构创建
2. 索引创建
3. 基础数据插入（管理员账号、默认规则等）
4. 数据验证脚本

## 性能优化

### 查询优化

1. 使用预加载（selectinload）减少N+1查询
2. 分页查询限制返回数据量
3. 使用复合索引优化多条件查询

### 缓存策略

1. Redis缓存频繁查询的薪资规则
2. 缓存用户会话和权限信息
3. 缓存部门列表等基础数据

### 并发控制

1. 使用数据库事务保证数据一致性
2. 乐观锁防止并发修改冲突
3. 薪资计算使用排他锁避免重复计算

## 数据模型设计原则

### 单一职责原则

本数据模型严格遵循单一职责原则，不同类型的数据存储在不同的表中：

1. **AttendanceRecord** - 仅包含考勤相关数据
   - 制度工日、带薪假期、无薪假期
   - 工作日数据（夜班、下井等）
   - 加班数据（周末、节假日）

2. **PerformanceRecord** - 仅包含绩效相关数据
   - 绩效分配、绩效补发、考核奖扣
   - 考核评分（安全结构、年功工资等）
   - 计件工资数据

3. **AllowanceRecord** - 仅包含津贴相关数据
   - 各类岗位津贴（高温、野外、有害等）
   - 补助类（交通、通讯等）
   - 补差工资（月度变动）
   - 其他津补贴

**注意**：`retainedSalary`（保留工资）是单位核定的固定工资项，存储在 `Employee` 模型中。

4. **RewardRecord** - 仅包含奖励相关数据
   - 专项激励、贡献收入
   - 其他奖励项目

5. **DeductionRecord** - 仅包含扣款相关数据
   - 扣罚工资
   - 个人社保（养老、医疗、失业、公积金等）
   - 税后项目（个人所得税、独生子女费、女工卫生费）

### 数据一致性保证

1. **复合唯一索引**：每个员工在每个月只能有一条记录，确保数据不重复
2. **外键约束**：通过 `attendanceRecordId` 关联到考勤记录，保证数据关联正确
3. **统一时间维度**：所有月度记录使用 `attendanceYear` 和 `attendanceMonth` 字段，便于查询和统计

### 查询便利性

1. **员工维度查询**：可以快速查询某个员工的所有月度数据
2. **时间维度查询**：可以快速查询某个月的所有员工数据
3. **复合查询**：支持按部门、时间、员工等多维度组合查询
