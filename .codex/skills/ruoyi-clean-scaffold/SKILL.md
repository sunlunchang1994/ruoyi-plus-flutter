---
name: ruoyi-clean-scaffold
description: 当用户要求把 ruoyi-flutter-plus、ruoyi-xxx 或基于 ruoyi-flutter-plus 的 Flutter 项目整理成干净脚手架、删除示例业务、抽离模板、保留开发范例、生成可复用空工程时使用；必须先保存当前页面/网络/表单/路由/权限等范式，再执行清理。
metadata:
  short-description: ruoyi 干净脚手架整理
---

# RuoYi Clean Scaffold

## 核心原则

- 先保留范例，再清理业务。不能直接删除 `business/user`、`business/system` 等示例模块，否则后续 AI 会丢失列表、表单、搜索、权限、网络、路由、字典等写法。
- 清理前先读取根目录 `scaffold/INDEX.md`，再读取 `scaffold/standards/` 和 `scaffold/templates/`，把它们当作“被删除业务代码的替代记忆”。
- 清理策略读取 `scaffold/checklists/clean-scaffold.md`，不要把基础能力、主题、l10n、路由、网络、启动链路误删。
- 真正执行清理时先列出将删除/保留的路径；确认范例和模板仍保留在 `scaffold/`。

## 触发后的工作顺序

1. 先确认用户要的是“生成方案”“创建干净分支/副本”还是“直接在当前项目清理”。
2. 检查 `git status --short`，区分用户已有改动和本次要动的文件。
3. 打开 `scaffold/INDEX.md`，确认标准和模板覆盖本次要删除的功能。
4. 打开 `scaffold/checklists/clean-scaffold.md`，确定保留层、示例层、可删除业务层。
5. 如果要实际清理，按清单逐步执行；不要一次性大范围删除而不说明边界。

## 输出要求

- 说明当前将保留哪些脚手架能力：启动、主题、l10n、Dio、Provider/MVVM、路由、表单、分页、字典、权限、本地持久化。
- 说明将清理哪些业务示例：默认 RuoYi 用户/角色/部门/菜单/租户/日志/OSS/监控等页面，或按用户指定范围清理。
- 清理后必须保留根目录 `scaffold/`，这是后续人和 AI 参考标准写法、模板的入口。
- 如果用户只要“干净脚手架技能”，不要实际删除业务代码。
