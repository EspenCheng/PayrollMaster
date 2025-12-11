# PayrollMaster Speckit核心文档目录

本目录包含PayrollMaster薪资自动核算系统的**Speckit工作流核心文档**，遵循Specify工作流规范。

⚠️ **重要说明**: 所有项目技术文档已迁移到 `docs/` 目录，包括数据模型、技术研究、编码规范、API契约等。

## 目录结构

```
specs/                          # Speckit核心工作流文档
├── README.md                   # 本文档，目录说明
├── spec.md                     # 功能规格说明书 (用户故事、验收标准)
├── plan.md                     # 实施计划 (技术方案、架构设计)
└── tasks.md                    # 任务清单 (可执行开发任务)

注意: 项目技术文档请查看 ../docs/ 目录
```

## 核心文档说明

| 文档 | 用途 | 优先阅读 |
|-----|------|---------|
| spec.md | 定义系统功能需求、用户故事和验收标准 | ★★★ |
| plan.md | 描述技术方案、架构设计和开发步骤 | ★★★ |
| tasks.md | 分解具体开发任务，供开发人员执行 | ★★★ |

## 开发流程 (Speckit工作流)

1. **需求理解**: 阅读 `spec.md` 了解功能需求
2. **技术方案**: 阅读 `plan.md` 了解实现方案
3. **任务执行**: 按照 `tasks.md` 执行开发任务

## 迁移说明

以下文档已迁移到 `docs/` 目录：

- **技术文档**: `model.md`, `research.md`, `quickstart.md`
- **项目指南**: `docs/guides/` (编码规范、架构设计等)
- **API契约**: `docs/contracts/`
- **检查清单**: `docs/checklists/`
- **Excel模板**: `docs/excel-templates/`
- **业务规则**: `docs/rules/`

## 注意事项

- 本目录仅包含Speckit工作流核心文档
- 所有项目技术文档和指南在 `docs/` 目录
- 修改核心文档前请确保理解其影响范围
- 所有文档使用英文命名，遵循小写+连字符格式
