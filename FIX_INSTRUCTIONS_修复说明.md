# GitHub Action 修复说明 / Fix Instructions

## 问题 (Problem)

您的 GitHub Action 一直失败，错误信息：
```
AttributeError: 'DatabasesEndpoint' object has no attribute 'query'
```

## 根本原因 (Root Cause)

1. **代码使用** `client.databases.query()` 方法
2. **该方法在 notion-client 2.6.0+ 版本中被移除了**
3. **当前 main 分支配置允许安装最新版本 (2.7.0)**，导致代码运行失败

## 详细分析 (Detailed Analysis)

### Main 分支的问题配置

**requirements.txt**:
```
notion-client>=2.2.1  ❌ 允许安装任何 >= 2.2.1 的版本，包括不兼容的 2.7.0
```

**workflow 文件 (.github/workflows/weread.yml 第32行)**:
```bash
python -m pip install "notion-client>=2.2.1"  ❌ 强制升级到最新版本
```

### 修复后的配置 (在 copilot/fix-action-failure-issue 分支)

**requirements.txt**:
```
notion-client>=2.2.1,<2.6.0  ✅ 限制版本，确保兼容性
```

**workflow 文件**:
```bash
# 移除了这一行 ✅
# python -m pip install "notion-client>=2.2.1"
```

## 解决方案 (Solutions)

### 方案 1: 合并 PR (推荐)

1. **访问 GitHub 仓库**: https://github.com/liumu96/weread2notion
2. **找到 Pull Requests 标签页**
3. **找到标题类似的 PR**: "Fix GitHub Action failure due to notion-client API incompatibility" 或 "Pin notion-client to <2.6.0"
4. **审核并合并这个 PR**
5. **合并后，重新运行 weread workflow**

### 方案 2: 从修复分支运行 workflow (快速测试)

1. 访问: https://github.com/liumu96/weread2notion/actions/workflows/weread.yml
2. 点击 "Run workflow" 按钮
3. **在分支选择中**，选择 `copilot/fix-action-failure-issue` 而不是 `main`
4. 点击 "Run workflow" 开始运行
5. 这将使用修复后的配置运行，应该会成功

### 方案 3: 手动应用修复 (如果无法合并 PR)

如果您无法访问 PR，可以手动修改两个文件：

**1. 编辑 requirements.txt**
```diff
requests
-notion-client>=2.2.1
+notion-client>=2.2.1,<2.6.0
python-dotenv
retrying
```

**2. 编辑 .github/workflows/weread.yml**
```diff
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          python -m pip uninstall -y notion-client notion-client-py notion_client notion || true
          python -m pip install -r requirements.txt
-          python -m pip install "notion-client>=2.2.1"
```

## 技术细节 (Technical Details)

### notion-client 版本兼容性

| 版本 | databases.query 方法 | 状态 |
|------|---------------------|------|
| 2.2.1 | ✅ 存在 | 兼容 |
| 2.3.0 - 2.5.0 | ✅ 存在 | 兼容 |
| 2.6.0+ | ❌ 不存在 | **不兼容** |
| 2.7.0 (最新) | ❌ 不存在 | **不兼容** |

### 修复将会：
- ✅ 安装 notion-client 2.5.0 (最后一个兼容版本)
- ✅ `databases.query` 方法可用
- ✅ 脚本正常运行
- ✅ Action 执行成功

## 验证修复 (Verification)

修复后，workflow 的断言步骤应该显示：
```
databases.query exists: True  ✅
```

而不是当前的：
```
databases.query exists: False  ❌
```

## 需要帮助？ (Need Help?)

如果您在应用修复时遇到问题，请：
1. 检查 PR 是否存在
2. 确认您有合并 PR 的权限
3. 或者尝试方案 2 从修复分支运行 workflow

---

**创建时间**: 2026-02-01
**修复分支**: copilot/fix-action-failure-issue
**状态**: 等待合并到 main 分支
