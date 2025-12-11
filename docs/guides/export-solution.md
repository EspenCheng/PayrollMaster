# 薪资系统数据导出功能技术实现方案

## 1. 功能概述

薪资系统数据导出功能支持两种类型的Excel报表导出：
- **基础数据提报表**：记录部门薪资计算的原始数据
- **薪资明细表**：记录员工薪资计算的详细结果

### 1.1 报表命名规则

| 报表类型 | 命名规则 | 示例 |
|---------|----------|------|
| 基础数据提报表 | YYYYMM[部门名称]数据提报表.xlsx | 202412技术部数据提报表.xlsx |
| 薪资明细表 | YYYYMM[部门名称]薪资明细表.xlsx | 202412技术部薪资明细表.xlsx |

### 1.2 导出条件

- ✅ 部门薪资计算已完成
- ✅ 系统管理员审核通过
- ✅ 用户具备导出权限
- ✅ 数据完整性校验通过

---

## 2. 数据库设计

### 2.1 核心数据表

```sql
-- 部门表
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(20) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 员工薪资表
CREATE TABLE employee_salaries (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    department_id INT NOT NULL,
    salary_month VARCHAR(6) NOT NULL, -- YYYYMM格式
    base_salary DECIMAL(10,2) NOT NULL,
    bonus DECIMAL(10,2) DEFAULT 0,
    deductions DECIMAL(10,2) DEFAULT 0,
    net_salary DECIMAL(10,2) NOT NULL,
    calculation_status VARCHAR(20) DEFAULT 'pending',
    calculated_at TIMESTAMP,
    approved_by INT,
    approved_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id),
    FOREIGN KEY (employee_id) REFERENCES employees(id),
    UNIQUE(employee_id, salary_month)
);

-- 薪资审核表
CREATE TABLE payroll_approvals (
    id SERIAL PRIMARY KEY,
    department_id INT NOT NULL,
    salary_month VARCHAR(6) NOT NULL,
    status VARCHAR(20) NOT NULL, -- pending, approved, rejected
    approved_by INT,
    approved_at TIMESTAMP,
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id),
    UNIQUE(department_id, salary_month)
);

-- 导出记录表
CREATE TABLE export_logs (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    export_type VARCHAR(50) NOT NULL, -- 'basic_data' or 'payroll_detail'
    department_id INT NOT NULL,
    salary_month VARCHAR(6) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    record_count INT NOT NULL,
    status VARCHAR(20) DEFAULT 'success',
    error_message TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);
```

### 2.2 数据模型（Python）

```python
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Decimal, Text, UniqueConstraint
from sqlalchemy.ext.declarative import declarative_base
from sqlmodel import SQLModel, Field, Relationship

Base = declarative_base()

class Department(SQLModel, table=True):
    __tablename__ = "departments"
    id: int = Field(default=None, primary_key=True)
    name: str = Field(max_length=100, unique=True)
    code: str = Field(max_length=20, unique=True)
    created_at: datetime = Field(default_factory=datetime.utcnow)

class PayrollApproval(SQLModel, table=True):
    __tablename__ = "payroll_approvals"
    id: int = Field(default=None, primary_key=True)
    department_id: int = Field(foreign_key="departments.id")
    salary_month: str = Field(max_length=6)  # YYYYMM
    status: str = Field(max_length=20)  # pending, approved, rejected
    approved_by: int = Field(default=None, foreign_key="users.id")
    approved_at: datetime = Field(default=None)
    comments: str = Field(default=None, max_length=500)
    created_at: datetime = Field(default_factory=datetime.utcnow)

    __table_args__ = (
        UniqueConstraint('department_id', 'salary_month', name='uq_dept_month'),
    )

class ExportLog(SQLModel, table=True):
    __tablename__ = "export_logs"
    id: int = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="users.id")
    export_type: str = Field(max_length=50)  # 'basic_data' or 'payroll_detail'
    department_id: int = Field(foreign_key="departments.id")
    salary_month: str = Field(max_length=6)
    file_path: str = Field(max_length=255)
    file_name: str = Field(max_length=255)
    record_count: int
    status: str = Field(max_length=20, default='success')
    error_message: str = Field(default=None, max_length=1000)
    ip_address: str = Field(default=None, max_length=45)
    created_at: datetime = Field(default_factory=datetime.utcnow)
```

---

## 3. 后端API实现

### 3.1 API路由设计

```python
from fastapi import APIRouter, Depends, HTTPException, Query
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
from typing import Optional
import pandas as pd
from datetime import datetime

router = APIRouter(prefix="/api/v1/export", tags=["export"])

@router.post(
    "/basic-data",
    summary="导出基础数据提报表",
    description="导出部门基础数据提报表，需要管理员审核通过"
)
async def export_basic_data(
    request: ExportRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    导出基础数据提报表

    命名格式：{salary_month}{department_name}数据提报表.xlsx
    """
    try:
        # 1. 权限验证
        if not check_permission(current_user, "export_basic_data"):
            raise HTTPException(status_code=403, detail="无权导出基础数据报表")

        # 2. 审核状态验证
        approval = get_approval_status(db, request.department_id, request.salary_month)
        if not approval or approval.status != "approved":
            raise HTTPException(
                status_code=400,
                detail="该部门薪资尚未通过审核，无法导出报表"
            )

        # 3. 数据查询和验证
        basic_data = get_basic_data(db, request.department_id, request.salary_month)
        if not basic_data:
            raise HTTPException(status_code=404, detail="未找到可导出的数据")

        # 4. 生成Excel文件
        department = get_department(db, request.department_id)
        file_name = generate_filename(
            request.salary_month,
            department.name,
            "dataExportReport.xlsx"
        )
        file_path = f"exports/{file_name}"

        # 5. 创建Excel工作簿
        create_basic_data_excel(basic_data, file_path)

        # 6. 记录导出日志
        export_log = ExportLog(
            user_id=current_user.id,
            export_type="basic_data",
            department_id=request.department_id,
            salary_month=request.salary_month,
            file_path=file_path,
            file_name=file_name,
            record_count=len(basic_data),
            ip_address=request.client.host
        )
        db.add(export_log)
        db.commit()

        # 7. 返回文件
        return FileResponse(
            file_path,
            filename=file_name,
            media_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        )

    except Exception as e:
        logger.error(f"导出基础数据报表失败: {str(e)}")
        raise HTTPException(status_code=500, detail=f"导出失败: {str(e)}")

@router.post(
    "/payroll-detail",
    summary="导出薪资明细表",
    description="导出部门薪资明细表，需要管理员审核通过"
)
async def export_payroll_detail(
    request: ExportRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """
    导出薪资明细表

    命名格式：{salary_month}{department_name}薪资明细表.xlsx
    """
    try:
        # 权限验证
        if not check_permission(current_user, "export_payroll_detail"):
            raise HTTPException(status_code=403, detail="无权导出薪资明细表")

        # 审核状态验证
        approval = get_approval_status(db, request.department_id, request.salary_month)
        if not approval or approval.status != "approved":
            raise HTTPException(
                status_code=400,
                detail="该部门薪资尚未通过审核，无法导出报表"
            )

        # 数据查询
        payroll_data = get_payroll_detail(db, request.department_id, request.salary_month)
        if not payroll_data:
            raise HTTPException(status_code=404, detail="未找到可导出的薪资数据")

        # 生成Excel文件
        department = get_department(db, request.department_id)
        file_name = generate_filename(
            request.salary_month,
            department.name,
            "payrollCalculationResult.xlsx"
        )
        file_path = f"exports/{file_name}"

        # 创建Excel工作簿
        create_payroll_detail_excel(payroll_data, file_path)

        # 记录导出日志
        export_log = ExportLog(
            user_id=current_user.id,
            export_type="payroll_detail",
            department_id=request.department_id,
            salary_month=request.salary_month,
            file_path=file_path,
            file_name=file_name,
            record_count=len(payroll_data),
            ip_address=request.client.host
        )
        db.add(export_log)
        db.commit()

        # 返回文件
        return FileResponse(
            file_path,
            filename=file_name,
            media_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        )

    except Exception as e:
        logger.error(f"导出薪资明细表失败: {str(e)}")
        raise HTTPException(status_code=500, detail=f"导出失败: {str(e)}")

@router.get(
    "/logs",
    summary="查询导出记录",
    description="查询用户的导出历史记录"
)
async def get_export_logs(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    export_type: Optional[str] = Query(None),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """查询导出日志"""
    query = db.query(ExportLog).filter(ExportLog.user_id == current_user.id)

    if export_type:
        query = query.filter(ExportLog.export_type == export_type)

    total = query.count()
    logs = query.order_by(ExportLog.created_at.desc())\
        .offset((page - 1) * page_size)\
        .limit(page_size)\
        .all()

    return {
        "total": total,
        "page": page,
        "page_size": page_size,
        "data": logs
    }
```

### 3.2 请求模型

```python
from pydantic import BaseModel, Field, validator
from typing import Optional

class ExportRequest(BaseModel):
    department_id: int = Field(..., gt=0, description="部门ID")
    salary_month: str = Field(
        ...,
        regex=r'^\d{6}$',
        description="薪资月份，格式：YYYYMM"
    )

    @validator('salary_month')
    def validate_month(cls, v):
        year = int(v[:4])
        month = int(v[4:])
        if year < 2020 or year > 2030:
            raise ValueError('年份必须在2020-2030之间')
        if month < 1 or month > 12:
            raise ValueError('月份必须在1-12之间')
        return v

class ExportLogResponse(BaseModel):
    id: int
    export_type: str
    department_name: str
    salary_month: str
    file_name: str
    record_count: int
    status: str
    created_at: datetime
    download_url: Optional[str] = None

    class Config:
        from_attributes = True
```

### 3.3 数据服务层

```python
def get_approval_status(db: Session, department_id: int, salary_month: str) -> Optional[PayrollApproval]:
    """获取薪资审核状态"""
    return db.query(PayrollApproval)\
        .filter(
            PayrollApproval.department_id == department_id,
            PayrollApproval.salary_month == salary_month
        )\
        .first()

def get_basic_data(db: Session, department_id: int, salary_month: str) -> List[dict]:
    """获取基础数据"""
    # 查询部门员工基础信息
    employees = db.query(Employee)\
        .filter(Employee.department_id == department_id)\
        .all()

    basic_data = []
    for emp in employees:
        salary_record = db.query(EmployeeSalary)\
            .filter(
                EmployeeSalary.employee_id == emp.id,
                EmployeeSalary.salary_month == salary_month
            )\
            .first()

        basic_data.append({
            "员工编号": emp.employeeId,
            "姓名": emp.full_name,
            "职位": emp.position,
            "入职日期": emp.hire_date.strftime('%Y-%m-%d'),
            "基本工资": salary_record.base_salary if salary_record else 0,
            "岗位津贴": salary_record.allowance if salary_record else 0,
            "绩效奖金": salary_record.performance_bonus if salary_record else 0,
            "考勤扣款": salary_record.attendance_deduction if salary_record else 0,
            "社保扣款": salary_record.social_security if salary_record else 0,
            "公积金扣款": salary_record.housing_fund if salary_record else 0,
            "其他扣款": salary_record.other_deductions if salary_record else 0,
        })

    return basic_data

def get_payroll_detail(db: Session, department_id: int, salary_month: str) -> List[dict]:
    """获取薪资明细数据"""
    salary_records = db.query(EmployeeSalary)\
        .join(Employee)\
        .filter(
            Employee.department_id == department_id,
            EmployeeSalary.salary_month == salary_month
        )\
        .all()

    payroll_data = []
    for record in salary_records:
        payroll_data.append({
            "员工编号": record.employee.employeeId,
            "姓名": record.employee.full_name,
            "职位": record.employee.position,
            "基本工资": record.base_salary,
            "岗位津贴": record.allowance,
            "绩效奖金": record.performance_bonus,
            "加班费": record.overtime_pay,
            "其他收入": record.other_income,
            "应发工资": record.gross_salary,
            "考勤扣款": record.attendance_deduction,
            "社保扣款": record.social_security,
            "公积金扣款": record.housing_fund,
            "个人所得税": record.income_tax,
            "其他扣款": record.other_deductions,
            "扣款合计": record.total_deductions,
            "实发工资": record.net_salary,
            "银行账号": record.employee.bank_account,
            "备注": record.remarks or ""
        })

    return payroll_data

def generate_filename(salary_month: str, department_name: str, suffix: str) -> str:
    """生成文件名"""
    return f"{salary_month}{department_name}{suffix}"
```

---

## 4. Excel导出实现

### 4.1 基础数据提报表Excel模板

```python
import pandas as pd
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Border, Side, Alignment
from openpyxl.utils.dataframe import dataframe_to_rows

def create_basic_data_excel(data: List[dict], file_path: str):
    """创建基础数据提报表Excel文件"""
    wb = Workbook()
    ws = wb.active
    ws.title = "基础数据"

    # 设置列宽
    column_widths = {
        'A': 12, 'B': 12, 'C': 15, 'D': 12, 'E': 12,
        'F': 12, 'G': 12, 'H': 12, 'I': 12, 'J': 12, 'K': 12
    }
    for col, width in column_widths.items():
        ws.column_dimensions[col].width = width

    # 创建标题
    ws.merge_cells('A1:K1')
    title_cell = ws['A1']
    title_cell.value = "部门薪资基础数据提报表"
    title_cell.font = Font(size=16, bold=True)
    title_cell.alignment = Alignment(horizontal='center', vertical='center')
    title_cell.fill = PatternFill(start_color="4472C4", end_color="4472C4", fill_type="solid")
    title_cell.font = Font(size=16, bold=True, color="FFFFFF")

    # 创建列标题
    headers = [
        "员工编号", "姓名", "职位", "入职日期", "基本工资",
        "岗位津贴", "绩效奖金", "考勤扣款", "社保扣款", "公积金扣款", "其他扣款"
    ]
    for col, header in enumerate(headers, 1):
        cell = ws.cell(row=2, column=col)
        cell.value = header
        cell.font = Font(bold=True, color="FFFFFF")
        cell.fill = PatternFill(start_color="70AD47", end_color="70AD47", fill_type="solid")
        cell.alignment = Alignment(horizontal='center', vertical='center')
        cell.border = Border(
            left=Side(style='thin'),
            right=Side(style='thin'),
            top=Side(style='thin'),
            bottom=Side(style='thin')
        )

    # 填充数据
    for row_idx, record in enumerate(data, 3):
        for col_idx, (key, value) in enumerate(record.items(), 1):
            cell = ws.cell(row=row_idx, column=col_idx)
            cell.value = value
            cell.alignment = Alignment(horizontal='center', vertical='center')
            cell.border = Border(
                left=Side(style='thin'),
                right=Side(style='thin'),
                top=Side(style='thin'),
                bottom=Side(style='thin')
            )

    # 添加统计行
    total_row = len(data) + 3
    ws.cell(row=total_row, column=1).value = "合计"
    ws.cell(row=total_row, column=1).font = Font(bold=True)

    for col_idx in range(2, 12):
        cell = ws.cell(row=total_row, column=col_idx)
        if col_idx in [5, 6, 7, 8, 9, 10, 11]:  # 数值列
            col_letter = chr(64 + col_idx)
            formula = f"=SUM({col_letter}3:{col_letter}{total_row-1})"
            cell.value = formula
            cell.font = Font(bold=True)
            cell.number_format = '#,##0.00'

    # 保存文件
    wb.save(file_path)
    logger.info(f"基础数据提报表已生成: {file_path}")
```

### 4.2 薪资明细表Excel模板

```python
def create_payroll_detail_excel(data: List[dict], file_path: str):
    """创建薪资明细表Excel文件"""
    wb = Workbook()
    ws = wb.active
    ws.title = "薪资明细"

    # 设置列宽
    column_widths = {
        'A': 12, 'B': 12, 'C': 15, 'D': 12, 'E': 12, 'F': 12, 'G': 12, 'H': 12,
        'I': 12, 'J': 12, 'K': 12, 'L': 12, 'M': 12, 'N': 12, 'O': 12, 'P': 15, 'Q': 20
    }
    for col, width in column_widths.items():
        ws.column_dimensions[col].width = width

    # 创建标题
    ws.merge_cells('A1:Q1')
    title_cell = ws['A1']
    title_cell.value = "部门薪资明细表"
    title_cell.font = Font(size=16, bold=True)
    title_cell.alignment = Alignment(horizontal='center', vertical='center')
    title_cell.fill = PatternFill(start_color="E74C3C", end_color="E74C3C", fill_type="solid")
    title_cell.font = Font(size=16, bold=True, color="FFFFFF")

    # 创建列标题
    headers = [
        "员工编号", "姓名", "职位", "基本工资", "岗位津贴", "绩效奖金", "加班费", "其他收入",
        "应发工资", "考勤扣款", "社保扣款", "公积金扣款", "个人所得税", "其他扣款", "扣款合计",
        "实发工资", "银行账号"
    ]
    for col, header in enumerate(headers, 1):
        cell = ws.cell(row=2, column=col)
        cell.value = header
        cell.font = Font(bold=True, color="FFFFFF")
        cell.fill = PatternFill(start_color="34495E", end_color="34495E", fill_type="solid")
        cell.alignment = Alignment(horizontal='center', vertical='center', wrap_text=True)
        cell.border = Border(
            left=Side(style='thin'),
            right=Side(style='thin'),
            top=Side(style='thin'),
            bottom=Side(style='thin')
        )

    # 填充数据
    for row_idx, record in enumerate(data, 3):
        for col_idx, (key, value) in enumerate(record.items(), 1):
            cell = ws.cell(row=row_idx, column=col_idx)
            cell.value = value

            # 数值列格式
            if key in ["基本工资", "岗位津贴", "绩效奖金", "加班费", "其他收入", "应发工资",
                      "考勤扣款", "社保扣款", "公积金扣款", "个人所得税", "其他扣款",
                      "扣款合计", "实发工资"]:
                cell.number_format = '#,##0.00'

            cell.alignment = Alignment(horizontal='center', vertical='center')
            cell.border = Border(
                left=Side(style='thin'),
                right=Side(style='thin'),
                top=Side(style='thin'),
                bottom=Side(style='thin')
            )

    # 添加统计行
    total_row = len(data) + 3
    ws.cell(row=total_row, column=1).value = "合计"
    ws.cell(row=total_row, column=1).font = Font(bold=True)

    # 统计数值列
    numeric_columns = {
        4: "基本工资", 5: "岗位津贴", 6: "绩效奖金", 7: "加班费", 8: "其他收入",
        9: "应发工资", 10: "考勤扣款", 11: "社保扣款", 12: "公积金扣款",
        13: "个人所得税", 14: "其他扣款", 15: "扣款合计", 16: "实发工资"
    }

    for col_idx, col_name in numeric_columns.items():
        cell = ws.cell(row=total_row, column=col_idx)
        col_letter = chr(64 + col_idx)
        formula = f"=SUM({col_letter}3:{col_letter}{total_row-1})"
        cell.value = formula
        cell.font = Font(bold=True)
        cell.number_format = '#,##0.00'
        cell.fill = PatternFill(start_color="F39C12", end_color="F39C12", fill_type="solid")

    # 保存文件
    wb.save(file_path)
    logger.info(f"薪资明细表已生成: {file_path}")
```

---

## 5. 权限控制

### 5.1 RBAC权限设计

```python
# 权限常量
PERMISSIONS = {
    "export_basic_data": "导出基础数据提报表",
    "export_payroll_detail": "导出薪资明细表",
    "view_export_logs": "查看导出记录"
}

# 角色权限映射
ROLE_PERMISSIONS = {
    "SUPER_ADMIN": ["export_basic_data", "export_payroll_detail", "view_export_logs"],
    "HR_ADMIN": ["export_basic_data", "export_payroll_detail", "view_export_logs"],
    "PAYROLL_MANAGER": ["export_basic_data", "export_payroll_detail", "view_export_logs"],
    "FINANCE_MANAGER": ["export_basic_data", "export_payroll_detail"],
    "DEPARTMENT_HEAD": [],  # 无导出权限
    "EMPLOYEE": []
}

def check_permission(user: User, permission: str) -> bool:
    """检查用户权限"""
    user_roles = [role.name for role in user.roles]
    for role in user_roles:
        role_permissions = ROLE_PERMISSIONS.get(role, [])
        if permission in role_permissions:
            return True
    return False
```

### 5.2 数据访问控制

```python
def get_department_accessible_ids(user: User) -> List[int]:
    """获取用户可访问的部门ID列表"""
    if user.is_super_admin:
        # 超级管理员可访问所有部门
        return db.query(Department.id).all()

    if user.role == "DEPARTMENT_HEAD":
        # 部门负责人只能访问自己的部门
        return [user.department_id]

    # HR和管理员可访问所有部门
    return db.query(Department.id).all()
```

---

## 6. 审计日志

### 6.1 审计日志记录

```python
import logging
from sqlalchemy import event

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('exports/export_audit.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger('export_audit')

def log_export_activity(
    user_id: int,
    action: str,
    department_id: int,
    salary_month: str,
    file_name: str,
    status: str,
    error_message: str = None
):
    """记录导出活动到审计日志"""
    log_entry = {
        "timestamp": datetime.utcnow().isoformat(),
        "user_id": user_id,
        "action": action,
        "department_id": department_id,
        "salary_month": salary_month,
        "file_name": file_name,
        "status": status,
        "error_message": error_message
    }

    logger.info(f"EXPORT_ACTIVITY: {json.dumps(log_entry)}")

# 导出前后钩子
@event.listens_for(ExportLog, "before_insert")
def log_before_export(mapper, connection, target):
    """导出前记录日志"""
    logger.info(f"开始导出: 用户{target.user_id}, 类型{target.export_type}, "
                f"部门{target.department_id}, 月份{target.salary_month}")
```

### 6.2 审计查询接口

```python
@router.get(
    "/audit",
    summary="查询审计日志",
    description="查询所有导出活动的审计日志（仅管理员）"
)
async def get_audit_logs(
    start_date: Optional[str] = Query(None, description="开始日期 YYYY-MM-DD"),
    end_date: Optional[str] = Query(None, description="结束日期 YYYY-MM-DD"),
    department_id: Optional[int] = Query(None),
    export_type: Optional[str] = Query(None),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """查询审计日志"""
    if not current_user.is_super_admin:
        raise HTTPException(status_code=403, detail="只有超级管理员可以查看审计日志")

    query = db.query(ExportLog)

    if start_date:
        query = query.filter(ExportLog.created_at >= start_date)
    if end_date:
        query = query.filter(ExportLog.created_at <= end_date)
    if department_id:
        query = query.filter(ExportLog.department_id == department_id)
    if export_type:
        query = query.filter(ExportLog.export_type == export_type)

    logs = query.order_by(ExportLog.created_at.desc()).limit(1000).all()

    return {"data": logs}
```

---

## 7. 前端实现

### 7.1 React组件设计

```typescript
// components/ExportCenter.tsx
import React, { useState, useEffect } from 'react';
import { Button, Select, DatePicker, Table, Modal, message } from 'antd';
import { DownloadOutlined, FileExcelOutlined } from '@ant-design/icons';
import dayjs from 'dayjs';

interface Department {
  id: number;
  name: string;
  code: string;
}

interface ExportLog {
  id: number;
  export_type: string;
  department_name: string;
  salary_month: string;
  file_name: string;
  record_count: number;
  status: string;
  created_at: string;
}

const ExportCenter: React.FC = () => {
  const [departments, setDepartments] = useState<Department[]>([]);
  const [selectedDepartment, setSelectedDepartment] = useState<number | null>(null);
  const [selectedMonth, setSelectedMonth] = useState<string>(dayjs().format('YYYYMM'));
  const [exportLogs, setExportLogs] = useState<ExportLog[]>([]);
  const [loading, setLoading] = useState(false);

  // 获取部门列表
  useEffect(() => {
    fetchDepartments();
    fetchExportLogs();
  }, []);

  const fetchDepartments = async () => {
    try {
      const response = await fetch('/api/v1/departments');
      const data = await response.json();
      setDepartments(data);
    } catch (error) {
      message.error('获取部门列表失败');
    }
  };

  const fetchExportLogs = async () => {
    try {
      const response = await fetch('/api/v1/export/logs');
      const data = await response.json();
      setExportLogs(data.data);
    } catch (error) {
      message.error('获取导出记录失败');
    }
  };

  const handleExport = async (exportType: 'basic_data' | 'payroll_detail') => {
    if (!selectedDepartment || !selectedMonth) {
      message.warning('请选择部门和月份');
      return;
    }

    setLoading(true);
    try {
      const response = await fetch(`/api/v1/export/${exportType}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          department_id: selectedDepartment,
          salary_month: selectedMonth
        })
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.detail || '导出失败');
      }

      // 获取文件名
      const contentDisposition = response.headers.get('content-disposition');
      const fileName = contentDisposition
        ? contentDisposition.split('filename=')[1].replace(/"/g, '')
        : 'export.xlsx';

      // 下载文件
      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = fileName;
      a.click();
      window.URL.revokeObjectURL(url);

      message.success('导出成功');
      fetchExportLogs(); // 刷新导出记录
    } catch (error: any) {
      message.error(error.message);
    } finally {
      setLoading(false);
    }
  };

  const columns = [
    {
      title: '导出类型',
      dataIndex: 'export_type',
      render: (type: string) => (
        <span>
          {type === 'basic_data' ? '基础数据提报表' : '薪资明细表'}
        </span>
      )
    },
    {
      title: '部门',
      dataIndex: 'department_name'
    },
    {
      title: '薪资月份',
      dataIndex: 'salary_month',
      render: (month: string) => `${month.substring(0, 4)}-${month.substring(4, 6)}`
    },
    {
      title: '文件名',
      dataIndex: 'file_name'
    },
    {
      title: '记录数',
      dataIndex: 'record_count'
    },
    {
      title: '状态',
      dataIndex: 'status',
      render: (status: string) => (
        <span style={{ color: status === 'success' ? '#52c41a' : '#f5222d' }}>
          {status === 'success' ? '成功' : '失败'}
        </span>
      )
    },
    {
      title: '导出时间',
      dataIndex: 'created_at',
      render: (time: string) => dayjs(time).format('YYYY-MM-DD HH:mm:ss')
    }
  ];

  return (
    <div className="export-center">
      <div className="export-controls" style={{ marginBottom: 24 }}>
        <Select
          placeholder="选择部门"
          style={{ width: 200, marginRight: 16 }}
          value={selectedDepartment}
          onChange={setSelectedDepartment}
        >
          {departments.map(dept => (
            <Select.Option key={dept.id} value={dept.id}>
              {dept.name}
            </Select.Option>
          ))}
        </Select>

        <Select
          style={{ width: 150, marginRight: 16 }}
          value={selectedMonth}
          onChange={setSelectedMonth}
        >
          {/* 生成最近12个月的选项 */}
          {Array.from({ length: 12 }, (_, i) => {
            const month = dayjs().subtract(i, 'month').format('YYYYMM');
            const display = dayjs().subtract(i, 'month').format('YYYY年MM月');
            return (
              <Select.Option key={month} value={month}>
                {display}
              </Select.Option>
            );
          })}
        </Select>

        <Button
          type="primary"
          icon={<FileExcelOutlined />}
          onClick={() => handleExport('basic_data')}
          loading={loading}
          style={{ marginRight: 8 }}
        >
          导出基础数据
        </Button>

        <Button
          type="primary"
          icon={<DownloadOutlined />}
          onClick={() => handleExport('payroll_detail')}
          loading={loading}
        >
          导出薪资明细
        </Button>
      </div>

      <Table
        columns={columns}
        dataSource={exportLogs}
        rowKey="id"
        pagination={{ pageSize: 20 }}
      />
    </div>
  );
};

export default ExportCenter;
```

### 7.2 权限控制组件

```typescript
// components/ProtectedExport.tsx
import React from 'react';
import { Button } from 'antd';

interface ProtectedExportProps {
  permission: string;
  children: React.ReactNode;
  onClick: () => void;
  loading?: boolean;
}

const ProtectedExport: React.FC<ProtectedExportProps> = ({
  permission,
  children,
  onClick,
  loading = false
}) => {
  const [hasPermission, setHasPermission] = React.useState(false);
  const [checking, setChecking] = React.useState(true);

  useEffect(() => {
    checkPermission();
  }, []);

  const checkPermission = async () => {
    try {
      const response = await fetch('/api/v1/user/permissions');
      const permissions = await response.json();
      setHasPermission(permissions.includes(permission));
    } catch (error) {
      console.error('Failed to check permissions:', error);
    } finally {
      setChecking(false);
    }
  };

  if (checking) return null;

  if (!hasPermission) {
    return (
      <Button disabled title="您没有权限执行此操作">
        {children}
      </Button>
    );
  }

  return (
    <Button onClick={onClick} loading={loading}>
      {children}
    </Button>
  );
};

export default ProtectedExport;
```

---

## 8. 安全策略

### 8.1 文件安全

```python
import os
import uuid
from datetime import timedelta

# 文件存储策略
EXPORT_DIR = "exports"
MAX_FILE_AGE_DAYS = 7  # 导出文件保留7天
MAX_FILE_SIZE_MB = 100  # 最大文件大小100MB

def generate_secure_filename(original_name: str) -> str:
    """生成安全的文件名"""
    # 生成UUID前缀防止文件名冲突
    uuid_prefix = str(uuid.uuid4()).split('-')[0]
    return f"{uuid_prefix}_{original_name}"

def cleanup_old_exports():
    """清理过期文件"""
    cutoff_time = datetime.now() - timedelta(days=MAX_FILE_AGE_DAYS)

    for filename in os.listdir(EXPORT_DIR):
        file_path = os.path.join(EXPORT_DIR, filename)
        if os.path.isfile(file_path):
            file_mtime = datetime.fromtimestamp(os.path.getmtime(file_path))
            if file_mtime < cutoff_time:
                os.remove(file_path)
                logger.info(f"已清理过期文件: {filename}")

@event.listens_for(ExportLog, "after_insert")
def schedule_file_cleanup(mapper, connection, target):
    """导出完成后调度文件清理任务"""
    # 可以使用Celery或Redis队列实现异步清理
    cleanup_old_exports()
```

### 8.2 数据验证

```python
from pydantic import BaseModel, validator, ValidationError
from typing import List, Optional

class ExportValidator:
    """导出数据验证器"""

    @staticmethod
    def validate_department_exists(db: Session, department_id: int) -> bool:
        """验证部门是否存在"""
        return db.query(Department).filter(Department.id == department_id).first() is not None

    @staticmethod
    def validate_salary_data_exists(
        db: Session,
        department_id: int,
        salary_month: str
    ) -> bool:
        """验证薪资数据是否存在"""
        count = db.query(EmployeeSalary)\
            .join(Employee)\
            .filter(
                Employee.department_id == department_id,
                EmployeeSalary.salary_month == salary_month
            )\
            .count()
        return count > 0

    @staticmethod
    def validate_export_permission(
        user: User,
        department_id: int,
        export_type: str
    ) -> bool:
        """验证导出权限"""
        # 检查用户权限
        if not check_permission(user, export_type):
            return False

        # 如果是部门负责人，验证只能导出自己部门
        if user.role == "DEPARTMENT_HEAD" and user.department_id != department_id:
            return False

        return True
```

---

## 9. 测试方案

### 9.1 单元测试

```python
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

class TestExportAPI:
    """导出API测试"""

    @pytest.fixture
    def client(self):
        """创建测试客户端"""
        SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"
        engine = create_engine(SQLALCHEMY_DATABASE_URL)
        TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

        def override_get_db():
            try:
                db = TestingSessionLocal()
                yield db
            finally:
                db.close()

        app.dependency_overrides[get_db] = override_get_db
        return TestClient(app)

    @pytest.fixture
    def test_user(self):
        """创建测试用户"""
        user = User(
            email="test@example.com",
            hashed_password="test123",
            is_active=True
        )
        # 分配HR_ADMIN角色
        role = Role(name="HR_ADMIN")
        user.roles.append(role)
        return user

    def test_export_basic_data_success(self, client, test_user):
        """测试成功导出基础数据"""
        # 模拟登录
        client.headers.update({"Authorization": f"Bearer {create_test_token(test_user)}"})

        response = client.post("/api/v1/export/basic_data", json={
            "department_id": 1,
            "salary_month": "202412"
        })

        assert response.status_code == 200
        assert "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" in \
               response.headers["content-type"]

    def test_export_without_approval(self, client, test_user):
        """测试未审核时导出失败"""
        client.headers.update({"Authorization": f"Bearer {create_test_token(test_user)}"})

        response = client.post("/api/v1/export/basic_data", json={
            "department_id": 1,
            "salary_month": "202412"
        })

        assert response.status_code == 400
        assert "尚未通过审核" in response.json()["detail"]

    def test_export_without_permission(self, client):
        """测试无权限导出"""
        # 创建普通员工（无导出权限）
        normal_user = create_normal_employee()
        client.headers.update({"Authorization": f"Bearer {create_test_token(normal_user)}"})

        response = client.post("/api/v1/export/basic_data", json={
            "department_id": 1,
            "salary_month": "202412"
        })

        assert response.status_code == 403
```

### 9.2 集成测试

```python
def test_export_workflow():
    """测试完整导出工作流"""
    # 1. 创建测试数据
    department = create_test_department(name="技术部")
    employees = create_test_employees(department, count=10)

    # 2. 生成薪资数据
    for emp in employees:
        create_salary_record(emp, "202412", base_salary=10000)

    # 3. 管理员审核
    admin = create_admin_user()
    approve_payroll(admin, department, "202412")

    # 4. 导出基础数据
    hr_user = create_hr_user()
    file_path = export_basic_data(hr_user, department, "202412")
    assert os.path.exists(file_path)

    # 5. 验证Excel内容
    df = pd.read_excel(file_path)
    assert len(df) == 10  # 10个员工
    assert "员工编号" in df.columns
    assert "基本工资" in df.columns

    # 6. 导出薪资明细
    file_path2 = export_payroll_detail(hr_user, department, "202412")
    df2 = pd.read_excel(file_path2)
    assert len(df2) == 10
    assert "实发工资" in df2.columns

    # 7. 验证审计日志
    logs = get_export_logs(hr_user)
    assert len(logs) == 2
    assert all(log.status == "success" for log in logs)
```

---

## 10. 部署和运维

### 10.1 环境变量配置

```bash
# .env
EXPORT_MAX_FILE_SIZE_MB=100
EXPORT_RETENTION_DAYS=7
EXPORT_STORAGE_PATH=./exports
EXPORT_CLEANUP_ENABLED=true
EXPORT_AUDIT_LOG_LEVEL=INFO
```

### 10.2 定时清理任务

```python
# tasks/cleanup_exports.py
from celery import Celery
from datetime import datetime, timedelta

celery_app = Celery('payroll_export')

@celery_app.task
def cleanup_expired_exports():
    """清理过期导出文件"""
    cutoff_time = datetime.now() - timedelta(days=int(os.getenv('EXPORT_RETENTION_DAYS', 7)))

    expired_files = []
    for filename in os.listdir(EXPORT_DIR):
        file_path = os.path.join(EXPORT_DIR, filename)
        if os.path.isfile(file_path):
            file_mtime = datetime.fromtimestamp(os.path.getmtime(file_path))
            if file_mtime < cutoff_time:
                os.remove(file_path)
                expired_files.append(filename)

    logger.info(f"清理了 {len(expired_files)} 个过期文件")
    return expired_files

# 每天凌晨2点执行
@celery_app.on_after_configure.connect
def setup_periodic_tasks(sender, **kwargs):
    sender.add_periodic_task(
        crontab(hour=2, minute=0),
        cleanup_expired_exports.s(),
        name='cleanup exports daily'
    )
```

---

## 11. 性能优化

### 11.1 大数据量处理

```python
def export_large_dataset(db: Session, department_id: int, salary_month: str):
    """大数据量导出优化"""

    # 1. 分批查询，避免内存溢出
    batch_size = 1000
    offset = 0

    # 2. 使用流式写入Excel
    with pd.ExcelWriter(file_path, engine='openpyxl') as writer:
        first_batch = True

        while True:
            batch = db.query(EmployeeSalary)\
                .join(Employee)\
                .filter(
                    Employee.department_id == department_id,
                    EmployeeSalary.salary_month == salary_month
                )\
                .offset(offset)\
                .limit(batch_size)\
                .all()

            if not batch:
                break

            # 转换为DataFrame
            df = pd.DataFrame([serialize_record(record) for record in batch])

            # 写入Excel
            df.to_excel(
                writer,
                sheet_name='薪资明细',
                startrow=offset if first_batch else offset + 1,
                index=False,
                header=first_batch
            )

            first_batch = False
            offset += batch_size

            # 释放内存
            del batch, df
```

### 11.2 缓存策略

```python
from functools import lru_cache
import redis

redis_client = redis.Redis(host='localhost', port=6379, db=1)

def get_cached_department_data(department_id: str, salary_month: str) -> Optional[List[dict]]:
    """缓存部门薪资数据"""
    cache_key = f"payroll_data:{department_id}:{salary_month}"

    # 尝试从Redis获取
    cached_data = redis_client.get(cache_key)
    if cached_data:
        return json.loads(cached_data)

    # 数据库查询
    data = get_payroll_detail(db, department_id, salary_month)

    # 缓存1小时
    if data:
        redis_client.setex(
            cache_key,
            3600,
            json.dumps(data, default=str)
        )

    return data

@lru_cache(maxsize=128)
def get_cached_department_name(department_id: int) -> Optional[str]:
    """缓存部门名称"""
    dept = db.query(Department).filter(Department.id == department_id).first()
    return dept.name if dept else None
```

---

## 12. 错误处理和监控

### 12.1 错误处理

```python
from fastapi import Request
from starlette.responses import JSONResponse

class ExportException(Exception):
    """导出异常基类"""
    def __init__(self, message: str, error_code: str = None):
        self.message = message
        self.error_code = error_code or "EXPORT_ERROR"
        super().__init__(self.message)

class DataValidationException(ExportException):
    """数据验证异常"""
    pass

class PermissionDeniedException(ExportException):
    """权限不足异常"""
    pass

class FileGenerationException(ExportException):
    """文件生成异常"""
    pass

@router.exception_handler(ExportException)
async def export_exception_handler(request: Request, exc: ExportException):
    """导出异常处理器"""
    logger.error(
        f"Export error: {exc.message}",
        extra={
            "error_code": exc.error_code,
            "request_path": request.url.path,
            "request_method": request.method
        }
    )

    return JSONResponse(
        status_code=400,
        content={
            "error": exc.error_code,
            "message": exc.message,
            "timestamp": datetime.utcnow().isoformat()
        }
    )
```

### 12.2 监控指标

```python
from prometheus_client import Counter, Histogram, Gauge

# 定义监控指标
export_requests_total = Counter(
    'export_requests_total',
    'Total export requests',
    ['export_type', 'status']
)

export_duration = Histogram(
    'export_duration_seconds',
    'Export operation duration'
)

export_file_size = Gauge(
    'export_file_size_bytes',
    'Exported file size in bytes'
)

active_exports = Gauge(
    'active_exports',
    'Number of active export operations'
)

@router.post("/basic_data")
async def export_basic_data(request: ExportRequest, ...):
    """导出基础数据"""
    active_exports.inc()
    start_time = time.time()

    try:
        # 导出逻辑...

        # 记录成功
        export_requests_total.labels(
            export_type='basic_data',
            status='success'
        ).inc()

        export_duration.observe(time.time() - start_time)

        return response

    except Exception as e:
        # 记录失败
        export_requests_total.labels(
            export_type='basic_data',
            status='error'
        ).inc()
        raise

    finally:
        active_exports.dec()
```

---

## 13. 总结

### 13.1 核心特性

✅ **双重报表支持**：基础数据提报表和薪资明细表
✅ **严格的命名规范**：YYYYMM[部门名称]格式
✅ **权限控制**：基于RBAC的细粒度权限管理
✅ **审核流程**：薪资计算完成后需管理员审核
✅ **审计日志**：完整的导出活动记录
✅ **数据安全**：文件安全存储和访问控制
✅ **性能优化**：大数据量分批处理和缓存机制
✅ **实时监控**：Prometheus指标和错误追踪

### 13.2 扩展建议

1. **批量导出**：支持多部门、多月份批量导出
2. **导出模板**：允许管理员自定义Excel模板
3. **云存储**：支持导出到云存储（S3、OSS等）
4. **邮件通知**：导出完成后自动发送邮件通知
5. **数据脱敏**：支持对敏感字段进行脱敏处理
6. **在线预览**：提供Web端在线预览Excel内容

---

**文档版本**: 1.0
**最后更新**: 2025-12-09
**作者**: Claude Code
**状态**: 完整实现方案
