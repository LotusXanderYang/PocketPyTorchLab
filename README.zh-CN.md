[English](README.md) | **简体中文**

# Pocket PyTorch Lab

在 ARM64 Android 设备上离线运行 Python · PyTorch 小模型实验。Lab 是独立应用，不需要安装 [Pocket Android IDE](https://github.com/LotusXanderYang/PocketPythonIDE) 或语言包。

**当前版本：`0.2.0-alpha.1`（测试版）** · Android API 26+ · ARM64 · CPU

## 亮点

- **从样例直接开始训练**：内置矩阵/自动求导检查和极小线性回归项目；也可新建自己的项目，编辑 `main.py` 与 `params.json`。
- **后台任务可追踪**：训练在独立进程和前台服务中运行。界面显示状态、日志和异常位置；锁屏后可从通知返回，任务可停止。
- **指标与检查点落盘**：脚本通过 `lab_api.log_metric()` 记录指标，通过 `lab_api.save_checkpoint()` 原子保存 `.pt` 文件。内置样例会重读检查点并计算预测。
- **数据由用户掌握**：经系统文件选择器导入数据，导出代码、参数、日志、指标、检查点和运行记录。导出默认不含原始数据。
- **离线且独立**：APK 内含 CPython 3.14.6、NumPy 2.5.4 和 CPU 版 PyTorch 2.14.1；训练无需联网，也不依赖 IDE。

## 目前能做什么

| 功能 | `0.2.0-alpha.1` 状态 |
| --- | --- |
| Python 脚本、参数与项目文件编辑 | 已提供 |
| CPU 小模型训练、日志、指标、检查点 | 已提供 |
| 后台运行、取消、异常定位 | 已提供；系统仍可能回收进程 |
| 从系统选择器导入数据、导出成果 ZIP | 已提供；导入单文件上限 10 MiB |
| GPU、任意桌面 wheel、通用 `pip install` | 未提供 |

已在 MAG-AN00 完成训练、检查点重读和锁屏运行测试；BTK-W00 全新安装后完成极小训练与检查点重读。API 26 和 16 KB 内存页设备尚未实测。一次只运行一个训练任务，单次上限 30 分钟。运行时首次解包需要额外存储；卸载应用前请导出项目。

## 安装与开始

从 [Lab `0.2.0-alpha.1` Release](https://github.com/LotusXanderYang/PocketPyTorchLab/releases/tag/v0.2.0-alpha.1) 下载 APK，核对页面列出的 SHA-256 后安装。打开应用，点“极小训练样例”→“启动 CPU 任务”；完成后查看日志、指标和检查点重读结果。自己的代码可从“新建项目”开始。

包名为 `com.example.pocketpythonlab`。从旧 Lab 覆盖安装时须保持签名一致，**不要为了绕过签名不一致而直接卸载**，否则私有项目会被删除。先从旧应用导出模型与日志。此版使用测试签名，源码自行构建通常采用另一把本机调试密钥，不能直接覆盖已安装的发布 APK。

## 从源码构建

需要 JDK 17、Android SDK Platform 35、Python 3 和 Gradle 8.13（仓库含 Gradle wrapper）。Windows PowerShell：

```powershell
git clone https://github.com/LotusXanderYang/PocketPyTorchLab.git
cd PocketPyTorchLab
.\build-local.ps1
```

脚本从旧版已发布的固定运行时下载 `runtime.zip`，先按 [`runtime/source-runtime.json`](runtime/source-runtime.json) 验证 SHA-256，再将应用私有路径调整为 Lab 包名并按 [`lab/src/main/assets/runtime.json`](lab/src/main/assets/runtime.json) 验证输出。运行时 ZIP 不进入 Git。产物位于 `lab/build/outputs/apk/debug/lab-debug.apk`。若已有经过校验的 Lab 运行时，脚本直接复用；离线构建仍需本地 Gradle/Android 依赖缓存。

`lab/` 是应用实现；`workbench/` 是 Lab 使用的编辑器代码副本。JNI 桥源码和 NDK 构建脚本位于 [`tools/native-runtime/`](tools/native-runtime/)，固定的 Termux 补丁及纯 Python wheel 哈希位于 [`packaging/`](packaging/)；完整第三方运行时的原始构建流程保留在[拆分前源码](https://github.com/LotusXanderYang/PocketPythonIDE/tree/v0.2.0-alpha.1/tools)。两仓库从[原共同源码提交](https://github.com/LotusXanderYang/PocketPythonIDE/commit/930ff544e42a4586d32e4c1ff7a83cb665055bf2)拆分，后续各自维护。Lab 运行时的固定版本、依赖与第三方许可见 [`lab/src/main/assets/runtime.json`](lab/src/main/assets/runtime.json) 和 [`lab/src/main/assets/THIRD_PARTY_NOTICES.md`](lab/src/main/assets/THIRD_PARTY_NOTICES.md)。项目自有源码采用 [MIT License](LICENSE)；内嵌组件沿用各自许可证。
