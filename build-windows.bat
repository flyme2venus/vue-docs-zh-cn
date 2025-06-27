@echo off
chcp 65001 >nul
echo.
echo ========================================
echo Vue Docs Windows 桌面应用构建脚本
echo ========================================
echo.

REM 检查是否安装了 Rust
where rustc >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 未找到 Rust 编译器
    echo 请访问 https://rustup.rs/ 下载安装 Rust
    echo 安装完成后重新运行此脚本
    pause
    exit /b 1
)

REM 检查是否安装了 pnpm
where pnpm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 未找到 pnpm
    echo 请先安装 pnpm: npm install -g pnpm
    pause
    exit /b 1
)

echo [信息] 检查 Windows 构建目标...
rustup target list --installed | findstr "x86_64-pc-windows-msvc" >nul
if %ERRORLEVEL% NEQ 0 (
    echo [信息] 添加 Windows 构建目标...
    rustup target add x86_64-pc-windows-msvc
    if %ERRORLEVEL% NEQ 0 (
        echo [错误] 添加 Windows 构建目标失败
        pause
        exit /b 1
    )
)

echo [信息] 安装项目依赖...
pnpm install
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 依赖安装失败
    pause
    exit /b 1
)

echo [信息] 构建前端资源...
pnpm build
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 前端构建失败
    pause
    exit /b 1
)

echo [信息] 构建 Tauri Windows 应用...
pnpm tauri build --target x86_64-pc-windows-msvc
if %ERRORLEVEL% NEQ 0 (
    echo [错误] Tauri 应用构建失败
    pause
    exit /b 1
)

echo.
echo ========================================
echo 构建完成！
echo ========================================
echo.
echo 安装程序位置:
echo src-tauri\target\x86_64-pc-windows-msvc\release\bundle\msi\
echo.
echo 可执行文件位置:
echo src-tauri\target\x86_64-pc-windows-msvc\release\
echo.
pause
