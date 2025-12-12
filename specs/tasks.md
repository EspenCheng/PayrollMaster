---

description: "PayrollMaster薪资自动核算系统 - 可执行任务清单"
---

# Tasks: PayrollMaster薪资自动核算系统

**输入**: 设计文档来自 `/specs/`
**前置条件**: plan.md (已完成), spec.md (已完成), model.md (已完成), contracts/ (已完成)

**测试**: 包含pytest后端测试、Jest + React Testing Library前端测试
**组织结构**: 任务按用户故事分组，每个故事可独立实现和测试

## 格式: `[ID] [P?] [Story] 描述`

- **[P]**: 可并行运行（不同文件，无依赖关系）
- **[Story]**: 所属用户故事 (US1-US7)
- 描述中包含精确的文件路径

## 路径约定

- **Web应用**: `backend/src/`, `frontend/src/`, `backend/tests/`, `frontend/tests/`
- 路径基于plan.md中的前后端分离架构

---

## Phase 1: Setup (共享基础设施)

**目标**: 项目初始化和基础结构搭建

- [ ] T001 创建前后端项目结构（backend/, frontend/）
- [ ] T002 初始化Python后端项目（FastAPI + SQLModel依赖）
- [ ] T003 初始化Next.js前端项目（Tailwind CSS + App Router）
- [ ] T004 [P] 配置代码规范工具（Python: ruff/flake8, JavaScript: ESLint/Prettier）
- [ ] T005 [P] 配置Git hooks和pre-commit检查
- [ ] T006 创建环境变量配置文件模板（.env.example）

**检查点**: 项目结构创建完成，基础配置就绪

---

## Phase 2: Foundational (阻塞前置条件)

**目标**: 所有用户故事实现前必须完成的核心里程碑

**⚠️ 关键**: 用户故事工作开始前，此阶段必须完成

- [ ] T007 设置PostgreSQL数据库架构和Alembic迁移框架
- [ ] T008 [P] 实现SQLModel数据模型（Employee, User, PayrollRule, SalaryCalculation, SystemLog, DataBackup）
- [ ] T009 [P] 实现JWT认证和授权中间件框架
- [ ] T010 [P] 设置API路由结构和CORS中间件
- [ ] T011 [P] 实现错误处理和日志记录基础设施
- [ ] T012 配置环境变量管理（数据库连接、密钥等）
- [ ] T013 创建数据库初始化脚本（管理员账号、默认规则）
- [ ] T014 [P] 实现并发控制和锁机制（防止数据竞争和不一致）
  - 数据库行级锁（SELECT FOR UPDATE）
  - 分布式锁实现（Redis或数据库级别）
  - 薪资计算过程的原子性保证
  - 避免并发写入导致的数据不一致
  - 批量计算任务的队列管理

**检查点**: 基础架构就绪 - 用户故事实现现在开始可以并行进行

---

## Phase 3: User Story 1 - Excel数据导入 (Priority: P1) 🎯 MVP

**目标**: 实现Excel文件上传、解析和员工数据存储功能

**独立测试**: 通过上传标准格式Excel文件并验证数据正确解析和显示来独立测试

### User Story 1 的测试

> **注意**: 先编写测试，确保实现前测试失败

- [ ] T015 [P] [US1] 后端Excel解析API合同测试（tests/contract/test_excel_import.py）
- [ ] T016 [P] [US1] 后端Excel数据验证API独立测试（tests/contract/test_excel_validation.py）
- [ ] T017 [P] [US1] 后端员工数据验证集成测试（tests/integration/test_employee_import.py）
- [ ] T018 [P] [US1] 前端Excel上传组件单元测试（frontend/tests/components/ExcelUpload.test.tsx）
- [ ] T019 [P] [US1] 前端数据预览组件集成测试（frontend/tests/components/DataPreview.test.tsx）

### User Story 1 的实现

- [ ] T020 [P] [US1] 实现Excel文件解析服务（backend/src/services/excel_parser.py）
  - 支持.xlsx/.xls格式
  - 双层表头解析（英文字段名 + 中文显示名）
  - 数据验证和错误处理
- [ ] T021 [P] [US1] 实现Excel导入API端点（backend/src/api/v1/endpoints/excel.py）
  - POST /api/v1/excel/upload - 上传Excel文件
  - POST /api/v1/excel/validate - 验证Excel数据
  - POST /api/v1/excel/import - 导入员工数据
- [ ] T022 [US1] 实现员工数据CRUD服务（backend/src/services/employee.py）
- [ ] T023 [US1] 创建前端Excel上传页面（frontend/src/pages/ImportExcel.tsx）
- [ ] T024 [US1] 创建前端数据预览表格组件（frontend/src/components/DataPreview.tsx）
- [ ] T025 [US1] 实现Excel文件拖拽上传功能（frontend/src/components/FileUpload.tsx）
- [ ] T026 [US1] 添加数据验证错误提示和用户引导
- [ ] T027 [US1] 实现重复数据处理逻辑（覆盖或跳过选项）

**检查点**: User Story 1 应完全功能且可独立测试

---

## Phase 4: User Story 2 - 薪资计算配置 (Priority: P1)

**目标**: 实现可配置的薪资计算规则引擎，支持多种计算方式

**独立测试**: 通过配置各种薪资计算规则并验证系统能正确应用这些规则进行独立测试

### User Story 2 的测试

- [ ] T028 [P] [US2] 后端薪资规则API合同测试（tests/contract/test_payroll_rules.py）
- [ ] T029 [P] [US2] 后端计算引擎集成测试（tests/integration/test_calculation_engine.py）
- [ ] T030 [P] [US2] 前端规则配置表单单元测试（frontend/tests/components/RuleConfigForm.test.tsx）

### User Story 2 的实现

- [ ] T031 [P] [US2] 实现薪资规则CRUD API（backend/src/api/v1/endpoints/rules.py）
  - GET /api/v1/rules - 获取规则列表
  - POST /api/v1/rules - 创建新规则
  - PUT /api/v1/rules/{id} - 更新规则
  - DELETE /api/v1/rules/{id} - 删除规则
- [ ] T032 [P] [US2] 实现薪资计算引擎核心逻辑（backend/src/services/calculation_engine.py）
  - 支持三种计算类型：固定金额、百分比、公式
  - 条件判断逻辑（>、<、=、>=、<=、!=、in）
  - 奖金计算（绩效奖金、加班费等）
  - 扣款计算（迟到、病假、事假等）
- [ ] T033 [US2] 创建规则配置页面（frontend/src/pages/RuleConfig.tsx）
- [ ] T034 [US2] 实现动态规则表单组件（frontend/src/components/RuleForm.tsx）
  - 支持规则类型选择
  - 支持计算方式配置
  - 支持条件设置
- [ ] T035 [US2] 实现规则预览功能（frontend/src/components/RulePreview.tsx）
- [ ] T036 [US2] 添加规则有效性验证和冲突检查

**检查点**: User Story 2 应完全功能且可独立测试

---

## Phase 5: User Story 3 - 自动薪资计算 (Priority: P1)

**目标**: 根据员工数据和薪资规则，自动计算每个员工的应发薪资、扣除项目和实发薪资

**独立测试**: 通过执行薪资计算并验证计算结果准确性来独立测试（基于已知输入数据和计算规则）

### User Story 3 的测试

- [ ] T037 [P] [US3] 后端薪资计算API合同测试（tests/contract/test_payroll_calculation.py）
- [ ] T038 [P] [US3] 后端计算准确性单元测试（tests/unit/test_salary_calculation.py）
- [ ] T039 [P] [US3] 后端性能测试（1000员工，60秒内完成）（tests/performance/test_calculation_performance.py）
- [ ] T040 [P] [US3] 前端计算进度组件测试（frontend/tests/components/CalculationProgress.test.tsx）

### User Story 3 的实现

- [ ] T041 [P] [US3] 实现薪资计算API端点（backend/src/api/v1/endpoints/calculation.py）
  - POST /api/v1/calculation/run - 执行薪资计算
  - GET /api/v1/calculation/status/{id} - 获取计算状态
  - GET /api/v1/calculation/results/{id} - 获取计算结果
- [ ] T042 [P] [US3] 实现批量计算服务（backend/src/services/batch_calculation.py）
  - 支持1000员工规模
  - 进度跟踪和状态更新
  - 并发控制和数据一致性保证
- [ ] T043 [US3] 实现个人所得税计算逻辑（backend/src/services/tax_calculation.py）
  - 基于应发工资扣除社保后计算
  - 遵循个人所得税法规
- [ ] T044 [US3] 实现社保公积金计算（backend/src/services/insurance_calculation.py）
  - 养老保险、医疗保险、失业保险、住房公积金
- [ ] T045 [US3] 创建前端薪资计算页面（frontend/src/pages/Calculation.tsx）
- [ ] T046 [US3] 实现计算进度指示器（frontend/src/components/CalculationProgress.tsx）
- [ ] T047 [US3] 添加异常数据处理和错误提示
- [ ] T048 [US3] 实现计算结果缓存机制

**检查点**: User Story 3 应完全功能且可独立测试

---

## Phase 6: User Story 4 - 计算结果预览与确认 (Priority: P2)

**目标**: 提供薪资计算结果的详细预览，支持最终确认前检查数据准确性

**独立测试**: 通过执行计算后查看详细结果页面并验证计算逻辑正确性来独立测试

### User Story 4 的测试

- [ ] T049 [P] [US4] 后端结果查询API合同测试（tests/contract/test_calculation_results.py）
- [ ] T050 [P] [US4] 前端结果表格组件测试（frontend/tests/components/CalculationResultTable.test.tsx）

### User Story 4 的实现

- [ ] T051 [P] [US4] 实现结果查询API（backend/src/api/v1/endpoints/results.py）
  - GET /api/v1/results/{calculation_id} - 获取计算结果详情
  - POST /api/v1/results/{calculation_id}/confirm - 确认计算结果
  - GET /api/v1/results/{calculation_id}/compare - 比较不同计算版本
- [ ] T052 [P] [US4] 实现薪资明细详细展示服务（backend/src/services/result_detail.py）
  - 应发工资明细（岗位工资、奖金、加班费等）
  - 扣除明细（社保、公积金、扣款等）
  - 个人所得税明细
  - 税后项目（独生子女费、女工卫生费）
  - 实发工资计算
- [ ] T053 [US4] 创建结果预览页面（frontend/src/pages/ResultPreview.tsx）
- [ ] T054 [US4] 实现结果表格组件（frontend/src/components/CalculationResultTable.tsx）
  - 支持按员工、部门筛选
  - 支持排序和搜索
  - 导出Excel功能
- [ ] T055 [US4] 实现计算明细展开功能（frontend/src/components/ResultDetailModal.tsx）
- [ ] T056 [US4] 添加结果确认流程（状态标记：draft → confirmed）
- [ ] T057 [US4] 实现版本比较功能（比较不同计算方案）

**检查点**: User Story 4 应完全功能且可独立测试

---

## Phase 7: User Story 5 - 薪资报表导出 (Priority: P2)

**目标**: 将薪资计算结果导出为Excel报表，支持多种格式

**独立测试**: 通过导出功能生成Excel文件并验证文件内容包含完整薪资数据和正确格式来独立测试

### User Story 5 的测试

- [ ] T058 [P] [US5] 后端报表导出API合同测试（tests/contract/test_report_export.py）
- [ ] T059 [P] [US5] 后端Excel模板生成测试（tests/unit/test_excel_template.py）

### User Story 5 的实现

- [ ] T060 [P] [US5] 实现报表导出API（backend/src/api/v1/endpoints/export.py）
  - POST /api/v1/export/payroll - 导出薪资计算结果
  - POST /api/v1/export/employee - 导出员工基础信息
  - GET /api/v1/export/download/{file_id} - 下载导出的文件
- [ ] T061 [P] [US5] 实现Excel模板引擎（backend/src/services/excel_export.py）
  - 基于用户提供的参考文件设计
  - dataExportReport.xlsx - 员工基础信息导出表
  - payrollCalculationResult.xlsx - 薪资计算结果导出表（包含payrollCalculationResult工作表）
  - 支持自定义列和格式
- [ ] T062 [US5] 实现前端报表导出页面（frontend/src/pages/ExportReports.tsx）
- [ ] T063 [US5] 创建导出配置组件（frontend/src/components/ExportConfig.tsx）
  - 支持按部门筛选
  - 支持选择导出格式
  - 支持自定义列选择
- [ ] T064 [US5] 实现文件下载和进度显示
- [ ] T065 [US5] 添加导出历史记录功能

**检查点**: User Story 5 应完全功能且可独立测试

---

## Phase 8: User Story 6 - 用户认证与权限管理 (Priority: P3)

**目标**: 实现用户认证和基于角色的权限控制（RBAC）

**独立测试**: 通过创建不同权限用户账号并验证各账号只能访问授权范围内功能来独立测试

### User Story 6 的测试

- [ ] T066 [P] [US6] 后端认证API合同测试（tests/contract/test_auth.py）
- [ ] T067 [P] [US6] 后端权限控制集成测试（tests/integration/test_rbac.py）
- [ ] T068 [P] [US6] 前端认证状态管理测试（frontend/tests/hooks/useAuth.test.ts）

### User Story 6 的实现

- [ ] T069 [P] [US6] 实现用户认证API（backend/src/api/v1/endpoints/auth.py）
  - POST /api/v1/auth/login - 用户登录
  - POST /api/v1/auth/logout - 用户注销
  - GET /api/v1/auth/me - 获取当前用户信息
  - POST /api/v1/auth/refresh - 刷新令牌
- [ ] T070 [P] [US6] 实现JWT令牌管理和验证（backend/src/core/auth.py）
  - 访问令牌和刷新令牌
  - 令牌过期处理
  - 密码加密存储（bcrypt）
- [ ] T071 [P] [US6] 实现RBAC权限控制（backend/src/core/permissions.py）
  - 角色定义：admin/staff-transfer-admin/attendance-admin/social-security-admin/finance-admin/payroll-calculator/employee
  - 权限检查中间件
  - 装饰器方式权限验证
  - 数据范围过滤（本单位数据隔离）
- [ ] T072 [US6] 实现用户管理页面（frontend/src/pages/UserManagement.tsx）
- [ ] T073 [US6] 创建登录页面（frontend/src/pages/Login.tsx）
- [ ] T074 [US6] 实现认证状态管理（frontend/src/contexts/AuthContext.tsx）
- [ ] T075 [US6] 添加路由守卫（frontend/src/components/ProtectedRoute.tsx）
- [ ] T076 [US6] 实现密码修改功能
- [ ] T077 [US6] 添加会话超时自动注销

**检查点**: User Story 6 应完全功能且可独立测试

---

## Phase 9: User Story 7 - 数据备份与恢复 (Priority: P3)

**目标**: 实现数据备份和恢复功能，确保数据安全

**独立测试**: 通过执行数据备份并模拟数据丢失场景，然后使用备份数据进行恢复来独立测试

### User Story 7 的测试

- [ ] T078 [P] [US7] 后端备份API合同测试（tests/contract/test_backup.py）
- [ ] T079 [P] [US7] 后端数据恢复集成测试（tests/integration/test_data_recovery.py）

### User Story 7 的实现

- [ ] T080 [P] [US7] 实现数据备份API（backend/src/api/v1/endpoints/backup.py）
  - POST /api/v1/backup/create - 创建备份
  - GET /api/v1/backup/list - 获取备份列表
  - POST /api/v1/backup/restore/{id} - 恢复数据
  - DELETE /api/v1/backup/{id} - 删除备份
- [ ] T081 [P] [US7] 实现备份服务（backend/src/services/backup_service.py）
  - 自动备份（定时任务）
  - 手动备份
  - 备份文件压缩和加密
  - 备份完整性校验
- [ ] T082 [US7] 实现数据恢复服务（backend/src/services/restore_service.py）
  - 数据一致性检查
  - 恢复进度跟踪
  - 恢复后数据验证
- [ ] T083 [US7] 创建备份管理页面（frontend/src/pages/BackupManagement.tsx）
- [ ] T084 [US7] 实现备份历史列表（frontend/src/components/BackupHistory.tsx）
- [ ] T085 [US7] 添加备份进度指示器
- [ ] T086 [US7] 实现自动备份配置（frontend/src/components/AutoBackupConfig.tsx）

**检查点**: User Story 7 应完全功能且可独立测试

---

## Phase 10: Polish & Cross-Cutting Concerns (最终阶段)

**目标**: 改进和优化，影响多个用户故事

- [ ] T087 [P] 系统日志和审计追踪完善（backend/src/services/audit_log.py）
- [ ] T088 [P] API性能优化（分页、缓存、索引优化）
- [ ] T089 [P] 前端性能优化（代码分割、懒加载、缓存策略）
- [ ] T090 [P] 安全加固（SQL注入防护、XSS防护、CSRF令牌）
- [ ] T091 [P] 前端响应式设计完善（移动端适配）
- [ ] T092 [P] API文档生成（自动生成OpenAPI文档）
- [ ] T093 [P] 单元测试覆盖率提升至90%+
- [ ] T094 [P] 端到端测试（Playwright）
- [ ] T095 [P] 部署脚本编写（Dockerfile, docker-compose.yml）
- [ ] T096 [P] quickstart.md验证和更新
- [ ] T097 [P] 代码注释和文档完善
- [ ] T098 [P] 错误处理和用户提示优化

**检查点**: 系统完全就绪，所有功能测试通过

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: 无依赖 - 可以立即开始
- **Foundational (Phase 2)**: 依赖Setup完成 - 阻塞所有用户故事
- **User Stories (Phase 3-9)**: 所有依赖Foundational阶段完成
  - 用户故事可以按优先级顺序进行（P1 → P2 → P3）
  - 或在人员充足时并行进行
- **Polish (Phase 10)**: 依赖所有用户故事完成

### User Story Dependencies

- **User Story 1-3 (P1)**: Foundational完成后即可开始 - 无需依赖其他故事
- **User Story 4-5 (P2)**: Foundational完成后可开始 - 可与P1故事并行，但建议顺序实现
- **User Story 6-7 (P3)**: Foundational完成后可开始 - 可与其他故事并行

### Within Each User Story

- 测试（如果包含）必须在实现前编写并确保失败
- 先模型后服务
- 先服务后API端点
- 核心实现先于集成
- 故事完成后才能进入下一个优先级

### Parallel Opportunities

- 所有Setup任务标记[P]可并行运行
- 所有Foundational任务标记[P]可并行运行（Phase 2内）
- Foundational阶段完成后，所有用户故事可以并行开始（如果团队容量允许）
- 用户故事内所有测试标记[P]可并行运行
- 用户故事内不同模型标记[P]可并行运行
- 不同用户故事可由不同团队成员并行开发

---

## Parallel Example: User Story 1 (Excel数据导入)

```bash
# 并行运行所有测试：
Task: "后端Excel解析API合同测试（tests/contract/test_excel_import.py）"
Task: "后端员工数据验证集成测试（tests/integration/test_employee_import.py）"
Task: "前端Excel上传组件单元测试（frontend/tests/components/ExcelUpload.test.tsx）"
Task: "前端数据预览组件集成测试（frontend/tests/components/DataPreview.test.tsx）"

# 并行运行所有服务：
Task: "实现Excel文件解析服务（backend/src/services/excel_parser.py）"
Task: "实现Excel导入API端点（backend/src/api/v1/endpoints/excel.py）"
Task: "实现员工数据CRUD服务（backend/src/services/employee.py）"
```

---

## Implementation Strategy

### MVP First (仅User Story 1)

1. 完成Phase 1: Setup
2. 完成Phase 2: Foundational（关键 - 阻塞所有故事）
3. 完成Phase 3: User Story 1
4. **停止并验证**: 独立测试User Story 1
5. 部署/演示（如果准备就绪）

### Incremental Delivery

1. 完成Setup + Foundational → 基础架构就绪
2. 添加User Story 1 → 独立测试 → 部署/演示（MVP！）
3. 添加User Story 2 → 独立测试 → 部署/演示
4. 添加User Story 3 → 独立测试 → 部署/演示
5. 添加User Story 4-5 → 独立测试 → 部署/演示
6. 添加User Story 6-7 → 独立测试 → 部署/演示
7. 每个故事增加价值且不破坏之前的故事

### Parallel Team Strategy

多开发人员协作：

1. 团队共同完成Setup + Foundational
2. Foundational完成后：
   - 开发者A: User Story 1 (Excel导入)
   - 开发者B: User Story 2 (薪资配置)
   - 开发者C: User Story 3 (自动计算)
3. 故事独立完成和集成

---

## User Story Summary

### Total Task Count: 98 tasks

**By Phase:**
- Phase 1 (Setup): 6 tasks (T001-T006)
- Phase 2 (Foundational): 8 tasks (T007-T014)
- Phase 3 (US1 - Excel导入): 13 tasks (T015-T027)
- Phase 4 (US2 - 薪资配置): 9 tasks (T028-T036)
- Phase 5 (US3 - 自动计算): 12 tasks (T037-T048)
- Phase 6 (US4 - 结果预览): 9 tasks (T049-T057)
- Phase 7 (US5 - 报表导出): 8 tasks (T058-T065)
- Phase 8 (US6 - 用户认证): 12 tasks (T066-T077)
- Phase 9 (US7 - 数据备份): 9 tasks (T078-T086)
- Phase 10 (Polish): 12 tasks (T087-T098)

**By Priority:**
- P1 (US1-3): 34 tasks
- P2 (US4-5): 17 tasks
- P3 (US6-7): 21 tasks
- Setup/Foundational/Polish: 26 tasks

### Parallel Opportunities

- **Phase 1**: 6 tasks（3个[P]任务可并行）
- **Phase 2**: 7 tasks（4个[P]任务可并行）
- **每个用户故事**: 50-60%的任务可并行执行

### Independent Test Criteria

**User Story 1**: 上传Excel文件并验证数据正确导入和显示
**User Story 2**: 配置薪资规则并验证规则正确保存和应用
**User Story 3**: 执行薪资计算并验证1000员工在60秒内完成且结果准确
**User Story 4**: 查看计算结果并验证明细准确，支持确认流程
**User Story 5**: 导出Excel报表并验证文件格式和数据完整性
**User Story 6**: 创建不同角色用户并验证权限控制正确
**User Story 7**: 执行备份和恢复并验证数据完整性

### Suggested MVP Scope

**推荐MVP**: User Story 1 (Excel数据导入) + User Story 3 (自动薪资计算)
- 这两个故事组合提供了完整的核心功能流程
- 可以演示从数据导入到薪资计算的完整工作流
- 为后续故事奠定基础

---

## Notes

- [P]任务 = 不同文件，无依赖
- [Story]标签将任务映射到特定用户故事，实现可追溯性
- 每个用户故事应可独立完成和测试
- 确保测试在实现前失败
- 每个任务或逻辑组后进行提交
- 在任何检查点停止以独立验证故事
- 避免：模糊任务、相同文件冲突、破坏独立性的跨故事依赖

**项目信息**:
- **分支**: 001-payroll-calculation-system
- **技术栈**: Python 3.11 + FastAPI + PostgreSQL + Next.js 14 + Tailwind CSS
- **测试框架**: pytest + Jest + Playwright
- **数据库**: PostgreSQL + SQLModel ORM
- **认证**: JWT + RBAC
