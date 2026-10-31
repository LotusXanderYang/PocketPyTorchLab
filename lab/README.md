# Lab Android 模块

产品简介、安装、支持范围和构建命令见[仓库首页](../README.md)。本目录包含应用、前台训练服务、私有 Python 运行时客户端、项目存储、内置样例及 `lab_api`。

项目由 `main.py`、`params.json` 和 `data/`、`logs/`、`metrics/`、`checkpoints/`、`runs/` 构成。样例可在应用首页生成；导入数据会复制到项目 `data/`，不会持续同步原文件。导出 ZIP 包含代码、参数、日志、指标、检查点和运行记录，默认不含原始数据。

训练脚本可调用 `from lab_api import log_metric, save_checkpoint`。`save_checkpoint` 先写入临时文件并同步，再原子改名为唯一的 `.pt` 文件。训练运行于独立 `:python` 进程；取消或被系统终止后，已完成的日志与检查点仍保留。

[`src/main/assets/runtime.json`](src/main/assets/runtime.json) 固定内嵌运行时的版本、SHA-256 与包清单；[`src/main/assets/THIRD_PARTY_NOTICES.md`](src/main/assets/THIRD_PARTY_NOTICES.md) 列出第三方许可。`runtime.zip` 由构建脚本校验或生成，不进入 Git。实机验收记录保留在[拆分前仓库的阶段 7 文档](https://github.com/LotusXanderYang/PocketPythonIDE/blob/v0.2.0-alpha.1/docs/STAGE7-ACCEPTANCE-2026-10-25.md)。
