# 一键修复脚本使用说明

## ⚠️ 重要说明

**我的权限限制**：作为 AI 助手，我**不能直接合并PR或推送到main分支**。但我为您创建了自动化脚本！

## 🚀 快速修复（3种方法）

### 方法1：使用一键修复脚本（推荐）⭐

#### Linux/Mac用户：
```bash
# 在仓库目录下运行
bash 一键修复.sh
```

#### Windows用户：
```batch
# 双击运行或在cmd中执行
一键修复.bat
```

**脚本会自动：**
1. ✅ 切换到main分支
2. ✅ 修复 requirements.txt（添加版本限制）
3. ✅ 修复 workflow文件（删除多余安装）
4. ✅ 提交并推送到main
5. ✅ 完成！您就可以运行action了

---

### 方法2：手动修复（如果脚本不工作）

#### 步骤1：切换到main分支
```bash
git checkout main
git pull origin main
```

#### 步骤2：修改 `requirements.txt`
找到这一行：
```
notion-client>=2.2.1
```
改成：
```
notion-client>=2.2.1,<2.6.0
```

#### 步骤3：修改 `.github/workflows/weread.yml`
找到并**删除**这一行（大约在第32行）：
```yaml
          python -m pip install "notion-client>=2.2.1"
```

#### 步骤4：提交并推送
```bash
git add requirements.txt .github/workflows/weread.yml
git commit -m "Fix notion-client version compatibility"
git push origin main
```

---

### 方法3：在GitHub网页上直接编辑

1. 访问 https://github.com/liumu96/weread2notion
2. 确保在 **main** 分支
3. 点击 `requirements.txt` → 编辑（铅笔图标）
4. 修改第2行为：`notion-client>=2.2.1,<2.6.0`
5. 提交更改
6. 点击 `.github/workflows/weread.yml` → 编辑
7. 删除第32行：`python -m pip install "notion-client>=2.2.1"`
8. 提交更改

---

## ❓ 为什么我不能直接合并PR？

根据我的系统限制：
- ❌ 我没有权限直接推送到main分支
- ❌ 我没有GitHub token来合并PR
- ❌ force push 功能被禁用
- ✅ 但我可以创建脚本帮助您！

## 📊 修复后的效果

修复后：
- ✅ notion-client 将安装 2.5.0 版本
- ✅ `databases.query()` 方法可用
- ✅ weread sync action 将成功运行

修复前：
- ❌ notion-client 安装 2.7.0 版本
- ❌ `databases.query()` 方法不存在
- ❌ action 失败

## 🎯 运行修复后

修复应用到main分支后：
1. 进入 GitHub → Actions
2. 选择 "weread sync" workflow
3. 点击 "Run workflow"
4. 确保选择 **main** 分支
5. 运行 → 成功！✅

## 💡 需要帮助？

如果脚本运行有问题，您可以：
1. 检查是否有权限推送到main分支
2. 使用方法2手动修复
3. 使用方法3在网页上编辑

---

**所有修复文件已准备好，请选择上述任一方法应用到main分支！**
