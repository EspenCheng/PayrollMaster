from sqlmodel import SQLModel, Field
from typing import Optional
from datetime import datetime


class Employee(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    employee_id: str = Field(index=True)
    name: str
    email: str = Field(index=True)
    department: str
    position: str
    base_salary: float
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
