#!/bin/bash

# 设置项目名称和工作目录
PROJECT_NAME="newsFeedTest"
WORKSPACE_NAME="newsFeedTest.xcworkspace"
BUILD_DIR="$(pwd)/build"
DESTINATION="generic/platform=iOS Simulator"

# 清理之前的构建
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# 使用xcodebuild构建项目并用xcpretty生成compile_commands.json
xcodebuild clean build \
    -workspace "$WORKSPACE_NAME" \
    -scheme "$PROJECT_NAME" \
    -destination "$DESTINATION" \
    -derivedDataPath "$BUILD_DIR" \
    | xcpretty --report json-compilation-database --output compile_commands.json

# 输出结果
echo "compile_commands.json has been generated in $(pwd)"
