# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

**核心需求**：构建一个完整的薪资自动核算Web应用程序，支持Excel数据导入、薪资计算规则配置、自动薪资计算、结果预览和报表导出。

**技术方案**：
- **后端**：Python 3.11 + FastAPI + SQLModel (Pydantic + SQLAlchemy) + PostgreSQL
- **前端**：Next.js 14 (App Router) + Tailwind CSS，采用现代金融仪表板美学设计
- **核心功能**：
  1. Excel文件导入（支持.xlsx/.xls格式，数据验证和错误处理）
  2. 可配置的薪资计算规则引擎（支持固定金额、百分比、公式三种计算方式）
  3. 自动薪资计算（支持1000名员工规模，60秒内完成）
  4. 薪资结果预览和确认（详细计算明细展示）
  5. 报表导出（基于Excel模板，支持多种报表格式）
  6. 用户认证与权限管理（RBAC，基于角色的访问控制）
  7. 数据备份与恢复（自动备份 + 手动备份）

**设计亮点**：
- 前后端分离架构，API采用OpenAPI 3.0标准
- 使用Decimal类型确保金额计算精度
- 支持大文件处理和性能优化（1000条记录30秒内导入）
- 完整的审计日志和操作追踪
- 基于JWT的认证机制和细粒度权限控制

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Python 3.11+ (基于FastAPI要求)
**Primary Dependencies**: FastAPI 0.104+, SQLModel (Pydantic + SQLAlchemy), PostgreSQL, Next.js 14+ (App Router), Tailwind CSS
**Storage**: PostgreSQL (关系型数据库，支持复杂查询和事务)
**Testing**: pytest (Python后端测试), Jest + React Testing Library (Next.js前端单元测试), Playwright (端到端测试)
**Target Platform**: Linux服务器 + 现代浏览器 (Chrome/Firefox/Safari/Edge)
**Project Type**: Web应用 (前后端分离架构)
**Performance Goals**:
- 支持1000名员工薪资计算在60秒内完成
- Excel文件导入1000条记录不超过30秒
- API响应时间p95 < 200ms
**Constraints**:
- 必须处理CORS，支持跨域访问
- 使用Decimal类型进行金额计算，保留两位小数
- 实现基于角色的权限控制 (RBAC)
- 支持Excel .xlsx/.xls格式导入导出
**Scale/Scope**:
- 初期支持1000名员工规模
- 可扩展至10000名员工
- 7个主要功能模块：Excel导入、薪资计算配置、自动计算、结果预览、报表导出、用户管理、数据备份

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

根据薪资核算系统宪章，以下检查项必须通过：

- [x] **文档驱动开发**：功能需求已在spec.md中明确记录，设计方案将在model.md中记录
- [x] **统一命名规范**：所有变量、函数、类名使用驼峰命名法（camelCase）
- [x] **测试驱动开发**：计划为所有计算逻辑编写单元测试（覆盖率≥90%），使用pytest和Jest
- [x] **模块化架构**：按薪资计算、考勤管理、税务计算、员工信息、Excel处理、权限管理等模块划分
- [x] **数据安全**：敏感信息采用PostgreSQL加密存储，实现基于角色的权限控制（RBAC）
- [x] **准确性优先**：金额计算使用Decimal类型，结果保留两位小数

✅ **所有检查项通过，可以进入Phase 0研究阶段**

---

**Phase 1后重新评估**：

- [x] **文档驱动开发**：已完成model.md（数据模型）、contracts/api.md（API规范）、openapi.yaml（OpenAPI规范）、quickstart.md（快速入门）
- [x] **统一命名规范**：所有数据模型和API端点使用驼峰命名法（camelCase），遵循RESTful API最佳实践
- [x] **测试驱动开发**：计划使用pytest为所有计算逻辑编写单元测试，覆盖率≥90%，包括薪资计算、Excel处理、数据验证等核心模块
- [x] **模块化架构**：
  - 薪资计算模块：PayrollRule、SalaryCalculation
  - 员工管理模块：Employee
  - 用户权限模块：User、基于JWT的RBAC
  - Excel处理模块：数据导入/导出
  - 数据备份模块：DataBackup、SystemLog
- [x] **数据安全**：敏感信息加密存储、银行账号脱敏显示、基于角色的权限控制（RBAC）、完整的审计日志
- [x] **准确性优先**：所有金额字段使用Decimal类型，结果保留两位小数，薪资计算公式：实发工资 = 应发工资 - 个人代扣代缴合计 - 个人所得税 + 税后项目

✅ **Phase 1后宪法检查全部通过，设计方案符合所有要求**

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md                        # This file (/speckit.plan command output)
├── research.md                    # Phase 0 output (/speckit.plan command)
├── model.md                  # Phase 1 output (/speckit.plan command)
├── quickstart.md                  # Phase 1 output (/speckit.plan command)
├── contracts/                     # Phase 1 output (/speckit.plan command)
└── tasks.md                       # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

**Structure Decision**: 采用前后端分离架构

**项目路径结构**:
```
PayrollMaster/
├── backend/                 # 后端目录
│   ├── src/                # 源代码
│   │   ├── models/         # 数据模型
│   │   ├── services/       # 业务服务
│   │   ├── api/            # API端点
│   │   └── core/           # 核心配置
│   └── tests/              # 后端测试
├── frontend/               # 前端目录
│   ├── src/                # 源代码
│   │   ├── components/     # React组件
│   │   ├── pages/          # 页面
│   │   └── services/       # API服务
│   └── tests/              # 前端测试
└── specs/                  # 项目文档
```

- **后端**: backend/ 目录，基于FastAPI + SQLModel + PostgreSQL
- **前端**: frontend/ 目录，基于Next.js 14 (App Router) + Tailwind CSS，采用现代金融仪表板美学设计
- **原因**: Next.js提供服务端渲染(SSR)、静态生成(SSG)、API路由等特性，更适合复杂的数据可视化界面，同时具备优秀的SEO和性能表现

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| 无违规项 | N/A | N/A |

---

## 规划执行报告

### ✅ Phase 0: 研究阶段完成
- **已完成**：所有技术选型和最佳实践研究
- **输出文件**：
  - `research.md`
  - `research_rbac.md`
- **研究范围**：
  - SQLModel ORM最佳实践
  - Excel文件处理方案（openpyxl vs pandas）
  - React + Tailwind CSS UI设计
  - RBAC权限控制架构

### ✅ Phase 1: 设计阶段完成
- **已完成**：数据模型设计、API契约生成、快速入门指南
- **输出文件**：
  - `model.md` - 完整的数据模型设计（6个核心实体）
  - `contracts/api.md` - 详细的API端点规范（9个功能模块）
  - `contracts/openapi.yaml` - OpenAPI 3.0标准规范
  - `quickstart.md` - 快速入门指南
- **Agent Context已更新**：`.claude/CLAUDE.md`

### 📋 项目信息
- **分支**: `001-payroll-calculation-system`
- **IMPL_PLAN路径**: `C:\Users\Espen\DevTools\WorkSpace\PayrollMaster\specs\001-payroll-calculation-system\plan.md`
- **技术栈**: Python 3.11 + FastAPI + PostgreSQL + React 18 + Tailwind CSS + SQLModel

### 🎯 下一步
- **Phase 2**: 生成任务清单（tasks.md）
- **命令**: 使用 `/speckit.tasks` 生成可执行的任务列表

---

## 技术栈变更记录

### 变更日期：2025-12-09

**变更内容**：
- **前端框架**：从 React 18 + Vite 变更为 Next.js 14 (App Router)
- **设计风格**：增加现代金融仪表板美学设计规范

**变更原因**：
1. Next.js提供SSR/SSG能力，提升首屏加载速度和SEO表现
2. App Router架构更清晰，适合复杂的企业级应用
3. 内置API Routes简化部署架构
4. 金融仪表板设计风格更专业，提升用户信任感

**相关文档**：
- `guides/frontend-design.md` - 完整的前端设计规范
- `guides/tech-analysis.md` - 技术栈对比分析
- `guides/frontend-architecture.md` - 前端架构蓝图

**更新内容**：
- ✅ 已更新 `plan.md` 中的技术栈信息
- ✅ 已更新 Agent Context (`.claude/CLAUDE.md`)
- ✅ 已创建3份前端设计相关文档
