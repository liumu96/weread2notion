@echo off
REM 一键修复脚本 (Windows版本)
REM 使用方法: 双击运行或在cmd中执行

echo ================================================
echo 🔧 Weread Notion Action 一键修复脚本 (Windows)
echo ================================================
echo.
echo 这个脚本将：
echo 1. 切换到main分支
echo 2. 应用修复（2个文件修改）
echo 3. 提交并推送到main
echo 4. 您就可以运行action了
echo.
pause

echo.
echo 📥 步骤 1/4: 获取最新的main分支...
git fetch origin main
git checkout main
git pull origin main

echo.
echo 🔧 步骤 2/4: 应用修复...

REM 修复 requirements.txt
echo   修复 requirements.txt...
powershell -Command "(Get-Content requirements.txt) -replace '^notion-client>=2\.2\.1$', 'notion-client>=2.2.1,<2.6.0' | Set-Content requirements.txt"

REM 修复 workflow 文件
echo   修复 .github/workflows/weread.yml...
powershell -Command "(Get-Content .github/workflows/weread.yml) | Where-Object { $_ -notmatch 'python -m pip install \"notion-client>=2\.2\.1\"' } | Set-Content .github/workflows/weread.yml"

echo.
echo ✅ 修复已应用！
echo.
echo 📝 修改的文件：
git diff --stat

echo.
echo 💾 步骤 3/4: 提交修改...
git add requirements.txt .github/workflows/weread.yml
git commit -m "Fix: Pin notion-client <2.6.0 to preserve databases.query() API - Update requirements.txt: notion-client>=2.2.1,<2.6.0 - Remove redundant pip install from workflow - Fixes: AttributeError: 'DatabasesEndpoint' object has no attribute 'query' - The databases.query() method was removed in notion-client 2.6.0"

echo.
echo 🚀 步骤 4/4: 推送到GitHub...
git push origin main

echo.
echo ================================================
echo ✅ 修复完成！
echo ================================================
echo.
echo 现在您可以：
echo 1. 进入 GitHub Actions 页面
echo 2. 选择 'weread sync' workflow
echo 3. 点击 'Run workflow' 按钮
echo 4. 从 'main' 分支运行
echo 5. Action 应该会成功运行！🎉
echo.
pause
