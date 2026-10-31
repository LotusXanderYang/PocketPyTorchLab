**English** | [简体中文](README.zh-CN.md)

# Pocket PyTorch Lab

Run small Python and PyTorch experiments offline on an ARM64 Android device. Lab is a standalone app: it does not require [Pocket Android IDE](https://github.com/LotusXanderYang/PocketPythonIDE) or a language pack.

**Current version: `0.2.0-alpha.1` (preview)** · Android API 26+ · ARM64 · CPU

## Highlights

- **Start with a working experiment.** Use the built-in matrix/autograd check or create a minimal linear-regression project. You can also create a project and edit its `main.py` and `params.json` yourself.
- **Follow a task while it runs in the background.** Training runs in a separate process with a foreground service. The app shows status, logs, and error locations; return from the notification after locking the screen, or stop the task.
- **Keep metrics and checkpoints.** Scripts call `lab_api.log_metric()` to record metrics and `lab_api.save_checkpoint()` to atomically save `.pt` files. The built-in training example reloads a checkpoint and makes a prediction.
- **Keep control of your data.** Import a file through Android's system picker, then export code, parameters, logs, metrics, checkpoints, and run records. Raw input data is excluded from exports by default.
- **Work offline without the IDE.** The APK includes CPython 3.14.6, NumPy 2.5.4, and a CPU build of PyTorch 2.14.1. Training does not need a network connection.

## What this version supports

| Feature | `0.2.0-alpha.1` status |
| --- | --- |
| Edit Python scripts, parameters, and project files | Available |
| CPU training, logs, metrics, and checkpoints | Available |
| Background runs, cancellation, error locations | Available; Android may still reclaim the process |
| Import through the system picker and export results as ZIP | Available; each imported file is limited to 10 MiB |
| GPU, arbitrary desktop wheels, general `pip install` | Not available |

Training, checkpoint reload, and a locked-screen run were tested on MAG-AN00. A fresh install on BTK-W00 passed the minimal training and checkpoint checks. Android API 26 and devices with 16 KB memory pages have not yet been tested. Only one training task can run at a time, for at most 30 minutes. First-run runtime extraction needs additional storage; export your projects before uninstalling.

## Install and get started

Download the APK from the [Lab `0.2.0-alpha.1` release](https://github.com/LotusXanderYang/PocketPyTorchLab/releases/tag/v0.2.0-alpha.1), check its published SHA-256, and install it. In the app, choose **Minimal Training Example** (`极小训练样例`) → **Start CPU Task** (`启动 CPU 任务`). When it finishes, inspect the logs, metrics, and checkpoint reload result. Use **New Project** (`新建项目`) for your own code.

The package ID is `com.example.pocketpythonlab`. An in-place update from an earlier Lab build requires the same signing key. If Android reports a signature mismatch, export models and logs from the installed app before uninstalling it; uninstalling deletes private projects. This preview uses a test key. A locally built debug APK will usually have a different key and cannot replace the published APK in place.

## Build from source

You need JDK 17, Android SDK Platform 35, Python 3, and Gradle 8.13 (the repository includes a Gradle wrapper). On Windows PowerShell:

```powershell
git clone https://github.com/LotusXanderYang/PocketPyTorchLab.git
cd PocketPyTorchLab
.\build-local.ps1
```

The script downloads a pinned previously published `runtime.zip`, checks it against [`runtime/source-runtime.json`](runtime/source-runtime.json), rebases its private paths to the Lab package ID, and checks the result against [`lab/src/main/assets/runtime.json`](lab/src/main/assets/runtime.json). Runtime ZIPs are not committed to Git. The APK is written to `lab/build/outputs/apk/debug/lab-debug.apk`. A previously verified Lab runtime can be reused; a fully offline build also needs cached Gradle and Android dependencies.

`lab/` contains the app; `workbench/` is the editor-code copy used by Lab. JNI bridge source and its NDK build script are in [`tools/native-runtime/`](tools/native-runtime/). Pinned Termux patches and pure-Python wheel hashes are in [`packaging/`](packaging/); the full third-party runtime build pipeline remains in the [pre-split source](https://github.com/LotusXanderYang/PocketPythonIDE/tree/v0.2.0-alpha.1/tools). The two repositories were separated from the [original shared source commit](https://github.com/LotusXanderYang/PocketPythonIDE/commit/930ff544e42a4586d32e4c1ff7a83cb665055bf2) and are now maintained independently. Runtime versions, dependency hashes, and third-party licenses are recorded in [`runtime.json`](lab/src/main/assets/runtime.json) and the [third-party notices](lab/src/main/assets/THIRD_PARTY_NOTICES.md). Project-owned source uses the [MIT License](LICENSE); bundled components retain their own licenses.
