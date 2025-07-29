@echo off
chcp 65001 > nul
title Vue项目启动器 - my-learn-tools-for-math-english

:: 定义项目路径
set "PROJECT_PATH=E:\开发项目\学习工具网站\my-learn-tools-for-math-english"

:: 检查项目目录是否存在
if not exist "%PROJECT_PATH%" (
    echo 错误：项目目录不存在！
    echo 请检查路径：%PROJECT_PATH%
    goto :END
)

:: 检查npm是否已安装
where npm > nul 2> nul
if %errorlevel% neq 0 (
    echo 错误：未找到npm。请确保已安装Node.js和npm。
    goto :END
)

:: 显示启动信息
echo ======================================
echo 正在启动Vue项目：my-learn-tools-for-math-english
echo 项目路径：%PROJECT_PATH%
echo ======================================
echo.

:: 切换到项目目录
cd /d "%PROJECT_PATH%"

:: 检查是否为Vue项目（通过package.json判断）
if not exist "package.json" (
    echo 错误：当前目录不是有效的npm项目！
    goto :END
)

:: 检查package.json中是否有dev脚本
findstr /C:"\"dev\"" package.json > nul
if %errorlevel% neq 0 (
    echo 错误：package.json中未定义"dev"脚本！
    goto :END
)

:: 启动项目
echo 正在执行：npm run dev
echo.
npm run dev

:END
echo.
echo 脚本执行完毕。按任意键退出...
pause > nul    