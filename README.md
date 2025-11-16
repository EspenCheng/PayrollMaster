# PayrollMaster

专业的薪资管理系统，提供全面的薪资计算、税务处理和报表功能。

## 功能特性

- ✅ 薪资计算自动化


## 项目结构

本项目使用 Specify 框架进行AI驱动的开发管理：

```
PayrollMaster/
├── .specify/              # Specify 框架配置
│   ├── memory/           # 项目记忆和上下文
│   ├── scripts/          # 自动化脚本
│   └── templates/        # 文档模板
├── .claude/              # Claude Code 配置
└── README.md             # 项目说明文档
```

## 开发指南

### 环境要求

- Git
- PowerShell (用于自动化脚本)
- 支持 AI 辅助开发的 IDE

### 开始开发

1. 克隆项目
```bash
git clone https://github.com/EspenCheng/PayrollMaster.git
cd PayrollMaster
```

2. 运行初始化脚本
```powershell
./.specify/scripts/powershell/setup-plan.ps1
```

3. 开始功能开发
```powershell
./.specify/scripts/powershell/create-new-feature.ps1
```

### 开发工作流

本项目采用 AI 驱动的开发流程：

1. **需求分析** - 使用 `/speckit.specify` 明确功能需求
2. **架构设计** - 使用 `/speckit.plan` 设计系统架构
3. **任务分解** - 使用 `/speckit.tasks` 生成开发任务
4. **代码实现** - 使用 `/speckit.implement` 执行开发任务
5. **质量检查** - 使用 `/speckit.analyze` 进行代码质量分析

## 贡献指南

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 联系方式

- 项目链接: [https://github.com/EspenCheng/PayrollMaster]
## 更新日志

### v1.0.0 (开发中)
- 项目初始化
- 集成 Specify 开发框架
- 配置 AI 辅助开发环境