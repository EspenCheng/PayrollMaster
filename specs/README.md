# PayrollMaster 设计文档目录

本目录包含PayrollMaster薪资自动核算系统的所有设计文档，遵循Specify工作流规范。

## 目录结构

```
specs/
├── README.md                 # 本文档，目录说明
│
├── 核心文档 (Specify工作流)
│   ├── spec.md               # 功能规格说明书
│   ├── plan.md               # 实施计划
│   ├── tasks.md              # 任务清单
│   ├── data-model.md         # 数据模型设计
│   ├── research.md           # 技术研究报告
│   └── quickstart.md         # 快速开始指南
│
├── guides/                   # 辅助文档
│   ├── document-index.md     # 文档索引
│   ├── project-index.md      # 项目文档索引
│   ├── project-research.md   # 项目技术研究
│   ├── project-export-solution.md    # 数据导出方案
│   ├── project-coding-standards.md   # 项目编码规范
│   ├── python-coding-standards.md    # Python编码规范
│   ├── excel-format-spec.md          # Excel格式规范
│   ├── frontend-architecture.md      # 前端架构设计
│   ├── frontend-design-spec.md       # 前端设计规范
│   ├── tech-stack-summary.md         # 技术栈更新总结
│   └── tech-stack-analysis.md        # 技术栈分析
│
├── contracts/                # API契约
│   └── api-endpoints.md      # API端点规范
│
├── checklists/               # 检查清单
│   ├── requirements-checklist.md  # 需求检查清单
│   └── comprehensive.md           # 综合检查清单
│
├── excel-templates/          # Excel模板
│   ├── template-guide.md     # 模板说明文档
│   ├── import/               # 导入模板
│   │   ├── dataSubmissionReport.xlsx
│   │   └── import-spec.md
│   ├── export/               # 导出模板
│   │   ├── dataExportReport.xlsx
│   │   ├── payrollCalculationResult.xlsx
│   │   └── export-spec.md
│   └── web-display/          # Web展示结构
│       ├── table-structure.md
│       └── field-mapping.md
│
└── rules/                    # 规则定义
    ├── payroll-calculation.md    # 薪资计算逻辑
    └── payroll-variables.md      # 薪资变量定义
```

## 核心文档说明

| 文档 | 用途 | 优先阅读 |
|-----|------|---------|
| spec.md | 定义系统功能需求、用户故事和验收标准 | ★★★ |
| plan.md | 描述技术方案、架构设计和开发步骤 | ★★★ |
| tasks.md | 分解具体开发任务，供开发人员执行 | ★★★ |
| data-model.md | 定义数据库结构、实体关系和字段说明 | ★★☆ |
| research.md | 记录技术选型、调研结果和决策依据 | ★★☆ |
| quickstart.md | 提供快速上手指南和环境配置说明 | ★☆☆ |

## 子目录说明

### guides/ - 辅助文档
存放项目开发过程中产生的各类参考文档，包括编码规范、架构设计、技术分析等。

### contracts/ - API契约
存放API接口定义文档，包括端点规范、请求响应格式等。

### checklists/ - 检查清单
存放各类检查清单，用于需求验证、代码审查等质量保证活动。

### excel-templates/ - Excel模板
存放系统使用的Excel模板文件及其说明文档，详见 `excel-templates/template-guide.md`。

### rules/ - 规则定义
存放业务规则定义文档，包括薪资计算逻辑和变量定义，是系统核心业务逻辑的依据。

## 开发流程

1. **需求理解**: 阅读 `spec.md` 了解功能需求
2. **技术方案**: 阅读 `plan.md` 了解实现方案
3. **任务执行**: 按照 `tasks.md` 执行开发任务
4. **规则参考**: 开发时参考 `rules/` 目录下的业务规则
5. **模板参考**: 处理Excel时参考 `excel-templates/` 目录

## 注意事项

- 修改核心文档前请确保理解其影响范围
- 业务规则变更需同步更新 `rules/` 目录下的文档
- Excel模板变更需同步更新 `excel-templates/` 目录下的说明文档
- 所有文档使用英文命名，遵循小写+连字符格式
