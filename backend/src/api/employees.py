from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session, select
from typing import List
from ..models.employee import Employee
from ..core.database import get_session

router = APIRouter(prefix="/employees", tags=["employees"])


@router.get("/", response_model=List[Employee])
async def get_employees(session: Session = Depends(get_session)):
    employees = session.exec(select(Employee)).all()
    return employees


@router.get("/{employee_id}", response_model=Employee)
async def get_employee(employee_id: str, session: Session = Depends(get_session)):
    employee = session.exec(
        select(Employee).where(Employee.employee_id == employee_id)
    ).first()
    if not employee:
        raise HTTPException(status_code=404, detail="Employee not found")
    return employee


@router.post("/", response_model=Employee)
async def create_employee(
    employee: Employee, session: Session = Depends(get_session)
):
    session.add(employee)
    session.commit()
    session.refresh(employee)
    return employee
