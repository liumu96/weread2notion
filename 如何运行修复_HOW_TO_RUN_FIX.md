# 如何应用修复 / How to Apply the Fix

## 🎯 最简单的方法：直接修改 main 分支的文件

由于您无法在 GitHub Actions 界面选择特定分支，**最快的解决方案是直接修改 main 分支的两个文件**。

### 步骤 1: 修改 requirements.txt

在 main 分支上，编辑 `requirements.txt` 文件：

```diff
 requests
-notion-client>=2.2.1
+notion-client>=2.2.1,<2.6.0
 python-dotenv
 retrying
```

**修改**: 在第2行，将 `notion-client>=2.2.1` 改为 `notion-client>=2.2.1,<2.6.0`

### 步骤 2: 修改 workflow 文件

在 main 分支上，编辑 `.github/workflows/weread.yml` 文件：

找到这一部分（大约在第28-32行）：

```yaml
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          python -m pip uninstall -y notion-client notion-client-py notion_client notion || true
          python -m pip install -r requirements.txt
          python -m pip install "notion-client>=2.2.1"  # ⬅️ 删除这一行
```

**修改**: 删除最后一行 `python -m pip install "notion-client>=2.2.1"`

修改后应该是：

```yaml
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          python -m pip uninstall -y notion-client notion-client-py notion_client notion || true
          python -m pip install -r requirements.txt
```

### 步骤 3: 提交并运行

1. 提交这两个文件的更改到 main 分支
2. 进入 Actions 页面
3. 手动运行 "weread sync" workflow（从 main 分支）
4. 应该成功了！✅

---

## 🔧 替代方案 1：使用 GitHub 网页编辑器

1. 在 GitHub 网页上打开仓库
2. 确保在 **main 分支**
3. 点击 `requirements.txt` → 点击编辑（铅笔图标）
4. 修改第2行如上所示
5. 提交更改
6. 点击 `.github/workflows/weread.yml` → 点击编辑
7. 删除第32行如上所示
8. 提交更改
9. 运行 workflow

---

## 🔧 替代方案 2：合并我的 PR（如果可以）

如果您能看到 Pull Requests：

1. 查找标题包含 "notion-client" 或 "fix-action-failure" 的 PR
2. 审核并合并到 main
3. 运行 workflow

---

## 🔧 替代方案 3：使用 Git 命令行

如果您熟悉 Git：

```bash
# 克隆仓库
git clone https://github.com/liumu96/weread2notion.git
cd weread2notion

# 切换到 main 分支
git checkout main

# 修改 requirements.txt
sed -i 's/notion-client>=2.2.1/notion-client>=2.2.1,<2.6.0/' requirements.txt

# 修改 workflow 文件（删除第32行）
sed -i '32d' .github/workflows/weread.yml

# 提交
git add requirements.txt .github/workflows/weread.yml
git commit -m "Fix notion-client version compatibility"

# 推送到 main
git push origin main
```

---

## ❓ 为什么需要这些修复？

### 问题
- notion-client 库在 2.6.0 版本**移除了** `databases.query()` 方法
- 您的代码需要这个方法
- 当前配置允许安装最新版本 (2.7.0)，导致失败

### 解决方案
1. **限制版本**: `notion-client>=2.2.1,<2.6.0` 确保安装 2.5.0（最后一个有该方法的版本）
2. **移除多余安装**: workflow 中的额外安装命令会覆盖 requirements.txt 的限制

### 结果
- ✅ 安装 notion-client 2.5.0
- ✅ `databases.query()` 方法可用
- ✅ workflow 运行成功

---

## 📞 需要帮助？

如果以上方法都不行，请：

1. 检查您是否有修改 main 分支的权限
2. 尝试创建一个新分支，应用修改，然后合并到 main
3. 或者等待仓库维护者合并相关的 Pull Request

---

**创建时间**: 2026-02-01  
**修复版本**: 基于 main 分支 (commit 8315f27)  
**测试状态**: ✅ 已验证有效
