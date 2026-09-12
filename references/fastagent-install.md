# fastagent 安装指南（AI Berkshire）

本框架是**整仓单框架** skill 包：根 `SKILL.md` 负责路由，21 个研究模块在 `skills/`，工具在 `tools/`。fastagent 安装的是**整个框架目录**，不是单个 SKILL.md。

## 安装路径

fastagent 只扫 user 层 `~/.fastagent/skills/<name>/`（**不扫** `~/.agents/skills`）。推荐用 git clone：

```bash
# fastagent 分支 = 我们的构建（含 package 壳 + 适配）
git clone --branch fastagent https://github.com/tokenaissance/ai-berkshire.git \
  ~/.fastagent/skills/ai-berkshire
```

或手动把 `fastagent` 分支内容放到 `~/.fastagent/skills/ai-berkshire/`。

skill key = 目录名 `ai-berkshire`。下轮对话即被 loader 加载（user 层 Layer2/3），`fastagent skill list` 应显示 source=user。

## 前置条件

- `python3`（全部 tools 为 Python；`datetime.UTC` 需要 3.11+）
- WebSearch 权限：`investment-team` 用后台 Agent 并行研究，Agent 无法弹交互式授权，须先在 `.claude/settings.local.json` 的 `permissions.allow` 放行 `"WebSearch"`，否则会静默退化（详见 `skills/investment-team.md` 预检步骤）
- 台股研究（可选）：FinMind token 写 `~/.fastagent/skills/ai-berkshire/local/finmind_token.txt` 或环境变量 `FINMIND_TOKEN`

## {baseDir} 路径约定

fastagent 在加载时把 `{baseDir}` 替换为 skill 目录。**SKILL.md 与各模块里所有工具调用一律用绝对路径**：

```bash
python3 {baseDir}/tools/financial_rigor.py verify-market-cap --price 380 --shares 148.8e8 --reported 5.66e12 --currency CNY
python3 {baseDir}/tools/terminal_value.py audit --currency CNY --r 0.08 --roic 0.15 --g 0.02,0.025,0.03 --rf 0.017 --beta 1.0
python3 {baseDir}/tools/twstock_data.py quote 2330
python3 {baseDir}/tools/report_audit.py extract --report reports/腾讯/腾讯-research-20260801.md
```

模块引用：`{baseDir}/skills/investment-research.md` 等。不要用相对路径 `tools/…`——agent 的工作目录不保证在 skill 目录内。

## 触发

路由由根 `SKILL.md` 的 `description` 驱动。典型触发：

- "帮我研究一下腾讯" → investment-research
- "用团队模式分析美团" → investment-team
- "精读拼多多 2025Q4 财报" → earnings-review
- "给这家公司做个十年折现估值" → valuation + terminal_value.py
- "我的组合需要检视吗" → portfolio-review

## 更新

框架内容跟随上游 [xbtlin/ai-berkshire](https://github.com/xbtlin/ai-berkshire) 12h 同步到本仓库 `main`（纯净镜像），再合并进 `fastagent` 分支（package 文件冲突保留我方）。本地更新：

```bash
cd ~/.fastagent/skills/ai-berkshire && git pull --rebase origin fastagent
```

## Troubleshooting

| 症状 | 处理 |
|---|---|
| `fastagent skill list` 看不到 | 确认路径是 `~/.fastagent/skills/ai-berkshire/SKILL.md`（不是 `~/.agents/skills`） |
| 工具报 `datetime.UTC` 不存在 | Python < 3.11，升级 |
| 后台 Agent 搜索被静默拦截 | 放行 WebSearch 权限后重启 agent |
| 台股取数限流 | 配 FinMind token（`local/finmind_token.txt`），未注册可直连（小时级限额） |
| 十年估值 audit 打回 | 报告补 r 取值、币种、配对 g 上限与敏感性，见 `skills/investment-research.md` 第七步 |
