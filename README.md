# Godot RL ONNX Inference Demo

This project contains a Godot RL environment, a Stable-Baselines3 PPO training script, and ONNX inference support for running the trained policy inside Godot Mono.

Tested on:

- macOS
- Mac Mini M4 / Apple Silicon
- Godot Mono
- Stable-Baselines3
- Microsoft.ML.OnnxRuntime 1.18.0

## Project Structure

```text
.
├── Godot project files
├── training script
├── exported ONNX model
└── README.md
````

## Python Setup

Create and activate a virtual environment:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install stable-baselines3 godot-rl
```

Install any other dependencies your training script requires.

## Training

Example:

```bash
python train.py --timesteps 1000000 --onnx_export_path model.onnx
```

This trains the PPO model and exports it to ONNX.

## ONNX Runtime Setup for Godot Mono on macOS

Install the .NET SDK if needed:

```bash
brew install --cask dotnet-sdk
```

Go to the Godot C# project folder containing the `.csproj` file:

```bash
cd path/to/godot/project
```

Install ONNX Runtime:

```bash
dotnet add package Microsoft.ML.OnnxRuntime --version 1.18.0
```

Godot Mono may not automatically find the native ONNX Runtime library on macOS, so manually copy the dylib into the Godot app bundle.

For Apple Silicon:

```bash
sudo mkdir -p /Applications/Godot_mono.app/Contents/Frameworks

sudo cp ~/.nuget/packages/microsoft.ml.onnxruntime/1.18.0/runtimes/osx-arm64/native/libonnxruntime.dylib \
/Applications/Godot_mono.app/Contents/Frameworks/
```

For Intel Mac:

```bash
sudo mkdir -p /Applications/Godot_mono.app/Contents/Frameworks

sudo cp ~/.nuget/packages/microsoft.ml.onnxruntime/1.18.0/runtimes/osx-x64/native/libonnxruntime.dylib \
/Applications/Godot_mono.app/Contents/Frameworks/
```

Restart Godot after copying the file.

## Fixes / Issues Encountered

### 1. `zsh: command not found: dotnet`

This means the .NET SDK was not installed or was not on PATH.

Fix:

```bash
brew install --cask dotnet-sdk
```

Then restart the terminal and check:

```bash
dotnet --version
```

### 2. `Unable to load shared library 'onnxruntime'`

Godot found the C# ONNX Runtime wrapper, but not the native macOS library.

Fix: copy `libonnxruntime.dylib` into:

```text
/Applications/Godot_mono.app/Contents/Frameworks/
```

### 3. `Unsupported model IR version: 10, max supported IR version: 9`

The ONNX Runtime version was too old.

Fix:

```bash
dotnet remove package Microsoft.ML.OnnxRuntime
dotnet add package Microsoft.ML.OnnxRuntime --version 1.18.0
```

Then copy the 1.18.0 dylib into Godot again.

### 4. `model.onnx.data failed`

The ONNX export created two files:

```text
model.onnx
model.onnx.data
```

Both files must be kept together in the same folder. Godot should load `model.onnx`, but `model.onnx.data` must be next to it.

Example:

```text
res://onnx/model.onnx
res://onnx/model.onnx.data
```