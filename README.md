# AI Berkshire — 价值投资研究框架（FastAgent Skill 包）

> "Price is what you pay, value is what you get." — Warren Buffett
>
> 用 AI 重新定义投资研究的深度与效率。**一个人 + AI = 一个投研团队。**

[![GitHub Trending](https://trendshift.io/api/badge/repositories/63696)](https://trendshift.io/repositories/63696)

**AI Berkshire** 是一套价值投资研究 Skill 包，把**巴菲特、芒格、段永平、李录**四位大师的方法论系统化、结构化。安装一次，即可获得从财报精读到十年折现估值的完整投研管线。

> **本仓库是 fork（Tokenaissance 适配版）**：框架内容镜像上游 [xbtlin/ai-berkshire](https://github.com/xbtlin/ai-berkshire)，包装成 fastagent 单框架 Skill 包（整仓单根 SKILL.md 路由，21 个研究模块保留原样）。构建在 `fastagent` 分支，`main` 为上游纯净镜像。

## 它解决什么问题

普通 AI 投研的三大缺陷：

| 缺陷 | AI Berkshire 的解法 |
|---|---|
| **只会复述市场共识** | 强制"信息丰富度评级"：A 级标的重做**反面检验**，避免输出"正确的废话" |
| **财务数据心算出错** | 所有计算强制走 `tools/financial_rigor.py` / `tools/terminal_value.py`，精确十进制，禁止 LLM 心算 |
| **看二手摘要不看原文** | `earnings-review` 直接读 10-K / 年报 / 电话会纪要，分析管理层语气与承诺追踪 |

## 能力一览

- **完整投研**：四角色并行团队（team-lead + 4 个后台 Agent，巴菲特/芒格/段永平/李录视角）
- **财报精读**：一手资料深度解读，MD&A 语气分析、承诺追踪、附注隐藏信息挖掘
- **十年折现估值**：r / ROIC / g 三输入 + 三条硬约束准出（`terminal_value.py audit`）
- **双源数据规范**：美股 / 港股 / A股 / 台股 各自主副信源，误差 >1% 必须标记
- **数据抽检准出**：`report_audit.py` 随机抽样双源核验，通过才可发布
- **投后纪律**：论文追踪、漂移预警、组合审视、月营收拐点信号

## 你可以直接这样说

- "帮我研究一下腾讯" → `investment-research` 七模块系统研究
- "用团队模式分析美团" → `investment-team` 四角色并行
- "精读一下拼多多 2025Q4 财报" → `earnings-review` 一手资料精读
- "估值一下这家公司，做十年折现" → `investment-checklist` + `terminal_value.py`
- "AI 行业里哪些公司值得深研" → `industry-funnel` 漏斗筛选
- "我的持仓需要检视吗" → `portfolio-review`

## 目录结构

```
ai-berkshire/                  ← 整仓单框架 Skill 包
├── SKILL.md                   ← 根入口：路由 + 框架原则 + 最小工作流
├── agents/interface.yaml      ← 接口定义（FastAgent / Claude / OpenAI 适配）
├── evals/trigger_cases.json   ← 触发边界回归用例
├── manifest.json              ← 包元数据（版本、owner、maturity）
├── references/                ← 安装文档、常见问题
├── skills/                    ← 21 个研究模块（保留上游原样）
├── tools/                     ← 计算/取数工具（financial_rigor 等）
├── codex-skills/              ← Codex 适配副本（SKILL.example.md，安装时物化）
├── reports/                   ← 研究报告输出
├── data/ / scripts/ / tests/  ← 上游框架内容
└── LICENSE                    ← MIT（Tokenaissance + xbtlin 双署名）
```

## 工作流

```
识别意图 → 路由到模块（skills/*）→ 信息丰富度评级 + 偏见自查
→ 数据收集（双源交叉验证，tools 精确计算）→ 分析（四大师框架）
→ 报告写入 reports/（CLAUDE.md 命名规范）→ 数据抽检准出（report_audit.py）
```

## 安装

### fastagent（user 层）

```bash
git clone --branch fastagent https://github.com/tokenaissance/ai-berkshire.git ~/.fastagent/skills/ai-berkshire
```

或手动把本仓库 `fastagent` 分支内容放到 `~/.fastagent/skills/ai-berkshire/`。fastagent 下一轮对话即加载（Skill loader 扫 user 层）。详细见 [references/fastagent-install.md](references/fastagent-install.md)。

### Claude Code / Codex

```bash
npx skills add tokenaissance/ai-berkshire
```

或在仓库内使用：根 `SKILL.md` 路由，`skills/` 为命令定义（Claude Code 复制到 `~/.claude/commands/`；Codex 运行 `scripts/install-codex-skills.sh`）。

### 前置条件

- `python3`（全部 tools 为 Python，建议 3.9+；`datetime.UTC` 需 3.11+）
- WebSearch 权限（`investment-team` 的后台 Agent 需要，否则退化为训练知识）
- 台股研究：FinMind token 写入 `local/finmind_token.txt`（已 gitignore）或环境变量 `FINMIND_TOKEN`

## 验证

```bash
python3 scripts/validate_skill.py .            # 包契约：0 failure / 0 warning
python3 scripts/trigger_eval.py . --cases evals/trigger_cases.json --output reports/trigger-eval.json
python3 scripts/export_skill_ir.py . --output reports/skill-ir.json
python3 scripts/release_check.py . --phase local --run-tests   # 上游 tests/ 一并跑
```

## Troubleshooting

| 症状 | 处理 |
|---|---|
| 后台 Agent 搜索被静默拦截 | 在 `.claude/settings.local.json` 的 `permissions.allow` 加入 `"WebSearch"`（见 `skills/investment-team.md` 预检步骤） |
| 台股取数失败 / 限流 | 检查 `local/finmind_token.txt` 或 `FINMIND_TOKEN`；FinMind 未注册可直连（小时级限额） |
| `datetime.UTC` 报错 | Python 版本 < 3.11，升级解释器 |
| 十年估值 audit 打回 | 报告里补 r 取值、币种、配对 g 上限与敏感性（见 `skills/investment-research.md` 第七步） |
| 同步后 codex-skills 出现 SKILL.md | 上游重新生成的副本，`sync-upstream.yml` 会自动改回 `SKILL.example.md` |

## 设计理念

- **整仓单框架**：一个根入口路由全部分析路径，保留上游 21 模块原样，不拆包、不改内容。
- **主分支镜像化**：`main` 纯镜像上游（12h 自动同步），构建与适配全部在 `fastagent` 分支，同步零冲突。
- **工具即纪律**：把"不心算、双源验证、抽检准出"做成工具而不是口头要求。

## Credits

- 上游框架：[xbtlin/ai-berkshire](https://github.com/xbtlin/ai-berkshire)（四大师方法论、21 个研究 Skill、`tools/` 全套工具）——MIT 许可
- 包化与 FastAgent 适配：[Tokenaissance](https://github.com/tokenaissance)（2026）
- 包装流程：fastagent-meta-skill（joeseesun/qiaomu-meta-skill 等启发）

## 安全边界

- 本包**只读公开数据**（WebSearch / 财报原文 / FinMind 公共 API）；FinMind token 只存本机、严禁提交 git。
- 不收集用户持仓，不触碰账户/交易系统。
- 研究报告是研究工具输出，**不构成投资建议**，不承诺任何收益。
