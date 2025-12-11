# Excel模板管理目录

## 目录说明

本目录用于管理PayrollMaster薪资自动核算系统的所有Excel表格模板，包括数据导入模板、数据导出模板和Web展示结构定义。

## 目录结构

```
excel-templates/
├── templates.md                     # 本文档，说明模板管理方式
├── import/                               # 数据导入模板目录
│   ├── dataSubmissionReport.xlsx         # 数据提报模板（已提供）
│   └── import-spec.md                    # 导入数据格式说明文档
├── export/                               # 数据导出模板目录
│   ├── dataExportReport.xlsx             # 数据导出模板（已提供）
│   ├── payrollCalculationResult.xlsx                # 薪资计算结果导出模板（已提供）
│   └── export-spec.md                    # 导出数据格式说明文档
└── web-display/                          # Web展示结构定义目录
    ├── table-structure.md                # Web数据表格展示结构说明
    └── field-mapping.md                  # 字段映射关系文档
```

## 使用说明

### 导入模板 (import/)
- **dataSubmissionReport.xlsx**: 数据提报模板，用于导入员工基础信息和考勤数据（已提供）
- **import-spec.md**: 详细说明导入数据的字段格式、必填项、验证规则等

### 导出模板 (export/)
- **dataExportReport.xlsx**: 数据导出模板，用于导出员工基础信息（已提供）
- **payrollCalculationResult.xlsx**: 薪资计算结果导出模板，用于导出完整的薪资计算结果（已提供）
- **export-spec.md**: 详细说明导出数据的字段结构、计算公式、格式要求等

### Web展示结构 (web-display/)
- **table-structure.md**: Web界面中数据表格的展示结构和字段定义
- **field-mapping.md**: Excel字段与Web界面字段的映射关系

## 更新说明

1. **导入模板**:
   - **dataSubmissionReport.xlsx**: 数据提报模板，用于导入员工基础信息和考勤数据
   - 当需要修改导入数据格式时，更新`import/`目录下的模板文件和说明文档
2. **导出模板**:
   - **dataExportReport.xlsx**: 数据导出模板，用于导出员工基础信息
   - **payrollCalculationResult.xlsx**: 薪资计算结果导出模板，用于导出完整的薪资计算结果
   - 当需要修改导出报表格式时，更新`export/`目录下的模板文件和说明文档
3. **Web展示**: 当需要修改Web界面展示方式时，更新`web-display/`目录下的结构文档

## 模板文件说明

### dataSubmissionReport.xlsx (数据提报模板)
- **位置**: `import/dataSubmissionReport.xlsx`
- **用途**: 用于导入员工基础信息和考勤数据
- **工作表**: Sheet1
- **说明**: 该模板包含了完整的员工基础信息和考勤数据字段，支持批量导入薪资计算所需的全部数据

### dataExportReport.xlsx (数据导出模板)
- **位置**: `export/dataExportReport.xlsx`
- **用途**: 用于导出员工基础信息
- **工作表**: Sheet1
- **说明**: 该模板包含员工基础信息字段，用于导出员工基础数据

### payrollCalculationResult.xlsx (薪资结果导出模板)
- **位置**: `export/payrollCalculationResult.xlsx`
- **用途**: 用于导出完整的薪资计算结果
- **工作表**: payrollCalculationResult
- **说明**: 该模板包含了完整的薪资计算结果字段，支持导出所有员工的薪资明细和汇总信息

## 注意事项

- 所有Excel模板文件必须遵循`rules/payroll-variables.md`中定义的字段映射关系
- 所有计算逻辑必须遵循`rules/payroll-calculation.md`中定义的计算公式
- 模板文件的修改需要同步更新相关的说明文档
- Web展示结构必须与Excel导入导出字段保持一致
