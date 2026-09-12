# Creation Handoff — ai-berkshire v1.0.1（fastagent 单框架包）

**日期**：2026-09-01
**产物**：`tokenaissance/ai-berkshire` fork 的 fastagent 单框架 skill 包（`fastagent` 分支承载构建）
**上游**：`xbtlin/ai-berkshire`（MIT，四大师价值投资框架，21 模块 + tools 全套）

## 参考的 skill / 候选（本次研究并评估）

- **xbtlin/ai-berkshire**（上游，本包包装对象；skills.sh 上以 4 个子 skill 形态被发现的正是它）
- claude-office-skills/skills:investment-memo（4.5K installs，投资备忘录）
- longbridge/skills:longbridge-value-investing（2.7K，长桥券商绑定价值投资）
- liangdabiao/claude-code-stock-deep-research-agent（1.8K，单执行器深研）
- qodex-ai/ai-agent-skills:financial-analysis-agent（1.2K，通用财务分析）
- star23/day1global-skills:us-value-investing、wind-information-co-ltd/wind-skills:valuation-pricing-framework、easychen/opc-methodology:opc-value-proposition
- **fastagent-meta-skill v2.10.0**（包装方法论，joeseesun/qiaomu-meta-skill 等启发）

## 候选特定教训（candidate-specific lessons）

1. 上游在 skills.sh 上以**子 skill 碎片**（investment-checklist / investment-team / thesis-tracker / dyp-ask）被发现——用户如果装 fork，会拿到碎片而不是整框架。**单根 SKILL.md 框架路由是必做项**，否则 fork 的"单一可发现包"价值为零。
2. longbridge 绑券商 API 换采纳量，但牺牲可移植性；本包坚持只读公开数据（WebSearch / FinMind / 财报原文），安全边界更干净。
3. 单一执行器（deep-research-agent）缺分工与互检；上游 `investment-team` 的四角色并行 + 数据抽检准出是更接近真实投研的质量机制，保留。

## 有意拒绝（deliberate rejections）

- **不拆成 22 个子包**：单框架包（用户既定决策）。拆包会破坏框架整体路由、报告命名规范与 tools 共享。
- **不改上游框架内容**：skills/、tools/、codex-skills/、CLAUDE.md 报告规范原样保留；只加壳 + 适配 + 安装物化。
- **不把 package 合入 main**：main 保持纯净镜像（上游活跃，避免每次 sync 冲突）；构建在 fastagent 分支。
- **不删 codex-skills**：改名 `SKILL.example.md` 满足单根 SKILL.md 契约，安装时物化回 SKILL.md 保 Codex 兼容。

## 原创贡献（original contributions）

| 贡献 | 类型 |
|---|---|
| **单根 SKILL.md 框架路由**（description 路由 21 模块 + 框架核心原则 + 标准执行路径 + 准出流程） | design advantage |
| **双分支同步架构**（main 纯净镜像 12h fast-forward + fastagent 构建分支；上游活跃提交下同步零冲突） | design advantage（从 ai-signal 单分支混入 package 的冲突负担迁移而来） |
| **codex-skills SKILL.example.md 治理**（改名 + install 物化 + sync re-assert 三件套） | design advantage |
| **`{baseDir}`-aware 工具路径**（fastagent 下 `python3 {baseDir}/tools/…` 绝对路径约定） | design advantage |
| **trigger-eval 15/15**（投资研究意图边界：8 正 / 4 负 / 3 近邻，阈值 0.34，denominator=5） | validated advantage |
| **validate 0 failure**（含嵌套 SKILL.md 契约、README 四项、manifest/IR 一致性） | validated advantage |
| **sync-upstream 工作流**（main fast-forward + fastagent keep-ours + SKILL.example re-assert 三段式） | design advantage |

## 待验证假设（hypothesis）

- **12h 同步在 xbtlin 活跃提交下长期无冲突**：目前 main 纯净镜像、fastagent 只加壳，理论上冲突集 = README/LICENSE/install 脚本三处；xbtlin 若改 README 结构（如新增子 README），需观察 re-assert 是否够用。
- **fastagent `{baseDir}` 路径约定在真实 agent loop 中不退化**：本地未跑真实 fastagent runtime，属部署后验证项。
- **codex-skills 改名不吓退 Codex 用户**：`SKILL.example.md` 是 meta-skill 契约命名，install 脚本已物化；真实 Codex 用户兼容性待反馈。

## 门禁与证据

- `validate_skill.py`：0 failure / 0 warning（上游 `sync-codex-*.py` 已加 `SCRIPT_INTERFACE = "internal-module"` 标记，随本包维护在 fastagent 分支，sync 冲突 keep-ours）
- `trigger_eval.py`：15/15 pass（8 should_trigger / 4 should_not / 3 near_neighbor，阈值 0.34）
- `export_skill_ir.py`：reports/skill-ir.json 生成，package.name=ai-berkshire、version=1.0.1 与 manifest 一致
- `release_check.py --phase local --run-tests`：package_validation / version_and_report_consistency / git_diff_check / feature_branch / unit_tests（26 tests）全 pass；clean_install、provider_or_human_output_evidence 为 warn（本地无远端 revision / 无 output-evidence.json，发布流程补）；**secret_scan 为 block——见下方"安全门例外"**

## 安全门例外（documented exception）：secret_scan

`release_check.py --phase local` 的 `secret_scan` gate 报 block：110 个 "OpenAI-like key"（`sk-[A-Za-z0-9_-]{20,}`）命中，全部来自上游 `reports/` 语料的 **`sk-` URL slug**（SK海力士新闻标题 slug、SK 公司新闻 slug、Damodaran 链接 `sk-premiums-...`）。逐条核实（提取 110 个唯一匹配串）：

- 110/110 为 URL slug 或公司名（`sk-hynix-announces-fy25-financial-results` 等），**0 真实凭据**（无 `AKIA`、无私钥块、无 `api_key=/password=` 赋值）。
- 扫描器 `scan_secrets` 无排除机制（只跳 `.git/__pycache__/node_modules/dist`），`publish_skill.py` 对任何命中无条件 raise；改 meta-skill scanner 会动共享安全门（不采纳）。
- **用户决策（2026-09-01）**：整仓保留（`reports/` 2341 个上游文件原样随包）+ **手动发布**绕过 publish_skill.py 的 secret gate，以本条审核记录作为替代证据。上游语料是框架输出物，剥离会破坏"整仓单框架包"约定。

## 交接清单

1. 构建在 `fastagent` 分支；发布后把默认分支切到 `fastagent`（npx install 读默认分支）。
2. **发布走手动路径**：`publish_skill.py` 因 secret gate（上述例外）与 codex/ 分支前置不可用；手动 = 推 fastagent → 切默认分支 → `gh release create v1.0.1` → `npx skills add tokenaissance/ai-berkshire` 验证 → 记 published gates（secret_scan 以审核记录替代）。
3. 上游内容更新走 `.github/workflows/sync-upstream.yml`（12h）：main fast-forward → fastagent merge（keep-ours）→ SKILL.example re-assert → push both。
4. 任何新 package 文件（SKILL.md/README/LICENSE/agents/evals/reports）改在 fastagent 分支；main 只许镜像。
5. 本地更新：`git pull --rebase origin fastagent`。
