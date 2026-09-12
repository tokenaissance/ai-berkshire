# Prior-Art Research — ai-berkshire（fastagent 包化重构）

**日期**：2026-09-01
**性质**：fork 再包装（re-wrap）——对上游 `xbtlin/ai-berkshire` 价值投资研究框架做 fastagent 单框架包化，保留 21 个研究模块与 `tools/` 原样，不改框架内容。

## 检索记录

- 查询 1：`价值投资 research skill`（skills.sh 19 候选 + SkillsMP 10 候选）
- 查询 2：`value investing investment analysis agent skill`（skills.sh 15 候选 + SkillsMP 9 候选）
- 去重后 distinct family：**50**；无 missing evidence。
- 度量语义：skills.sh installs = 安装采纳度量；SkillsMP stars = 源仓库星标。**二者都不是用户评分或质量分**，仅用于候选排序。

## 候选短名单（按采纳/星标降序）

| family_key | 度量 | 一句话 |
|---|---|---|
| claude-office-skills/skills:investment-memo | 4.5K | 单一投资备忘录产出 |
| longbridge/skills:longbridge-value-investing | 2.7K | 长桥券商 API 绑定，价值投资看板 |
| liangdabiao/claude-code-stock-deep-research-agent | 1.8K | 单执行器股票深研 agent |
| qodex-ai/ai-agent-skills:financial-analysis-agent | 1.2K | 通用财务分析 |
| star23/day1global-skills:us-value-investing | 681 | 美股价值投资 |
| wind-information-co-ltd/wind-skills:valuation-pricing-framework | 364 | 估值定价框架 |
| easychen/opc-methodology:opc-value-proposition | 198 | 价值主张方法论 |
| **xbtlin/ai-berkshire:investment-checklist / investment-team / thesis-tracker / dyp-ask** | 194/180/166/161 | **本包上游**，已在 skills.sh 被发现为 4 个独立子 skill |

## 综合：keep / adapt / reject / invent

### keep（原样保留）
- **xbtlin/ai-berkshire 全部框架内容**：21 个研究模块（`skills/`）、`tools/` 全套（financial_rigor / terminal_value / twstock_data / report_audit / ashare_data / stock_screener 等）、`codex-skills/`（Codex 适配副本）、报告命名规范（CLAUDE.md）、三语 README、MIT 许可（署名上游）。

### adapt（从候选借鉴的机制）
- **none materially**。所有候选都是更窄的单用途 skill（备忘录/看板/单一执行器），框架深度（四大师方法论、双源验证、十年折现、抽检准出）均不及上游。无值得移植的机制。

### reject（有意不采用）
| 候选 | 拒绝理由 |
|---|---|
| investment-memo | 只覆盖"投资备忘录"一环，缺全链路研究；我们保留上游 `investment-memo-craft`（codex-skills 中）已够 |
| longbridge-value-investing | 绑定长桥券商专有 API，不可移植；本包坚持只读公开数据（WebSearch / FinMind / 财报原文） |
| stock-deep-research-agent | 单一执行器，无四角色并行、无大师视角分工；本包保留 `investment-team` 的多 Agent 团队模型 |
| financial-analysis-agent | 通用财务分析，无方法论深度（无信息丰富度评级、无抽检准出） |
| us-value-investing / valuation-pricing-framework / opc-value-proposition | 单市场或单环节；本包覆盖 A/H/美/台四市场 + 全链路 |

### invent（本包原创）
1. **单根 SKILL.md 框架路由**：整仓单框架包，根入口路由到 21 个模块，保留上游内容原样——解决"多子 skill 合集 vs 单一可发现包"冲突。
2. **双分支同步架构**：`main`=纯上游镜像（12h fast-forward，零冲突），`fastagent`=构建分支承载 package + 适配；上游活跃提交时不污染镜像、同步永远干净。
3. **codex-skills 嵌套 entrypoint 治理**：上游生成的 `codex-skills/*/SKILL.md` 与 fastagent-meta-skill 的"单根 SKILL.md"契约冲突 → 仓库内改名 `SKILL.example.md`（meta-skill 官方示例命名），安装脚本物化回 `SKILL.md`；同步工作流内建 re-assert 步骤把上游重新生成的 SKILL.md 改回。
4. **`{baseDir}`-aware 工具路径**：fastagent 下所有工具调用用绝对路径 `{baseDir}/tools/…`，避免 agent 工作目录不在 skill 目录内的相对路径失效。
5. **工具即纪律**：把"不心算 / 双源验证 / 抽检准出"做成强制工具链，而不是口头规则（沿用上游设计，包化后固化为接口契约）。

## 教训

- 上游已经在 skills.sh 以 4 个子 skill 形态被发现——**fork 若不做包化，用户装到的会是子 skill 碎片而不是整框架**；这正是本次重构的动机。
- 候选的安装度量差异大（4.5K vs 6），但度量排序 ≠ 质量排序；真正的差异化在方法论深度与可移植性（不绑券商 API）。
- 对活跃上游做 fork 同步时，"主分支纯净镜像 + 构建分支"比"主分支混入 package"健壮得多——这是从 ai-signal（package 在主分支，每次 sync 要处理冲突）迁移来的架构教训。

## Missing Evidence

- 无。两次目录检索均成功（skills.sh + SkillsMP），无 missing evidence。
