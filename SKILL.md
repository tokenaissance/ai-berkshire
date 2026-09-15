---
name: ai-berkshire
description: |
  AI Berkshire 价值投资研究框架——把巴菲特、芒格、段永平、李录四大师方法论系统化
  为可执行的投研 Skill 合集。覆盖投资研究、财报精读、估值、护城河、商业模式、
  行业竞争、风险管理、组合审视、投资论文追踪、主题筛选。对"帮我研究X公司"、
  "分析X的财报"、"估值X"、"X值得买吗"、"组合检视"等投资研究意图触发。
metadata:
  author: Tokenaissance
  version: "1.0.1"
  upstream_inspiration: xbtlin/ai-berkshire
  fastagent:
    emoji: 🏛️
    requires:
      anyBins:
        - python3
---

# AI Berkshire — 价值投资研究框架

> "Price is what you pay, value is what you get." — Warren Buffett

对目标标的执行系统化价值投资研究。框架把四位大师的方法论结构化：**巴菲特**（护城河 / 内在价值 / 管理层诚信）、**芒格**（逆向思考 / 跨学科模型）、**段永平**（对的生意 / 对的人 / 对的价格）、**李录**（文明演进框架 / 一手资料精读）。

本包是**整仓单框架**：根 SKILL.md 负责路由，21 个研究模块在 `skills/`，计算工具在 `tools/`。

## 路径引导（先读）

- **fastagent**：本 skill 装在 `~/.fastagent/skills/ai-berkshire/`，`{baseDir}` 即该目录。引用模块与工具一律用绝对路径：`{baseDir}/skills/investment-research.md`、`python3 {baseDir}/tools/financial_rigor.py …`。
- **Claude Code**：在仓库根目录内用相对路径 `skills/…`、`tools/…`；仓库外先 `git clone` 或进入仓库根目录。
- 执行任何 `tools/` 命令前先 `date` 确认今天日期，作为"最新数据"基线并在报告头标注数据截止日。

## 框架核心原则（所有模块必须遵守，最高优先级）

1. **客观**——一切分析基于事实与数据，严禁主观臆断。
2. **事实/观点分离**——事实用数据支撑，观点明确标注为"观点"或"推测"。
3. **不预设立场**——先摆数据、再推逻辑、最后得结论，结论从数据中自然推出。
4. **正反两面**——每个核心判断必须附带反面论据，让读者自己权衡。
5. **诚实的确定性**——不确定就写"数据不足"，不用推测填充确定性。AI 置信度 ≠ 投资确定性。
6. **双源交叉验证**——每个关键数据来自两个独立来源，误差 >1% 须标记（规范见 `{baseDir}/skills/financial-data.md`）。

## 路由

先一句话识别用户意图，按下表选模块（优先级从上到下）。拿不准时默认 `investment-research`。

| 意图 | 模块 |
|---|---|
| 团队化完整投研（四角色并行） | `{baseDir}/skills/investment-team.md` |
| 单公司系统研究（七模块） | `{baseDir}/skills/investment-research.md` |
| 财报精读（一手资料，非二手摘要） | `{baseDir}/skills/earnings-review.md` |
| 财报季团队精读（公众号产出） | `{baseDir}/skills/earnings-team.md` |
| 买入前清单 / 估值 / 安全边际 | `{baseDir}/skills/investment-checklist.md` |
| 行业研究 | `{baseDir}/skills/industry-research.md` |
| 行业漏斗筛选（几十→几个） | `{baseDir}/skills/industry-funnel.md` |
| 管理层尽调 | `{baseDir}/skills/management-deep-dive.md` |
| 未上市公司研究 | `{baseDir}/skills/private-company-research.md` |
| 组合审视 / 再平衡 | `{baseDir}/skills/portfolio-review.md` |
| 投资论文追踪（买入后纪律） | `{baseDir}/skills/thesis-tracker.md` |
| 论文漂移预警 | `{baseDir}/skills/thesis-drift.md` |
| 质量筛选（跨公司打分） | `{baseDir}/skills/quality-screen.md` |
| 高股息投资 | `{baseDir}/skills/income-investment.md` |
| 超级趋势研究（AI 产业等） | `{baseDir}/skills/era-alpha.md` |
| 供应链瓶颈套利 | `{baseDir}/skills/bottleneck-hunter.md` |
| 向段永平提问 | `{baseDir}/skills/dyp-ask.md` |
| 新闻脉冲（信号扫描） | `{baseDir}/skills/news-pulse.md` |
| 深度公司系列（长期跟踪） | `{baseDir}/skills/deep-company-series.md` |
| 公众号文章产出 | `{baseDir}/skills/wechat-article.md` |
| 财务数据获取与交叉验证规范 | `{baseDir}/skills/financial-data.md` |

## 标准执行路径

### 前置：AI 研究偏见自评（每个研究都必须做）

先评估标的的**信息丰富度评级**并写入报告开头：

| 等级 | 特征 | 研究策略调整 |
|---|---|---|
| A（信息充裕） | 上市多年、券商覆盖广 | 重点做**反面检验**和非共识视角，避免输出与市场一致的"正确的废话" |
| B（信息适中） | 上市不久、覆盖有限 | 推算数据标注置信度，汇总时标注"数据充分度" |
| C（信息稀缺） | 冷门/新上市/新兴市场 | 转"第一性原理模式"，聚焦商业本质核心问题，不追求报告完整性 |

关键提醒：资料多≠确定性高。确定性来自商业模式本身，不来自资料数量。

### 执行

1. 按路由表执行所选模块的全部步骤。
2. **工具强制**：所有涉及计算的数据（市值、PE/PB/ROE、估值、三情景、十年折现）必须用 `python3 {baseDir}/tools/financial_rigor.py` / `{baseDir}/tools/terminal_value.py` 验算，**禁止 LLM 心算**；台股用 `{baseDir}/tools/twstock_data.py`（FinMind），A股用 `{baseDir}/tools/ashare_data.py`。
3. 数据来源、口径、复权规则遵循 `{baseDir}/skills/financial-data.md`。
4. 报告命名规范遵循 `{baseDir}/CLAUDE.md`（按公司名分目录，`{公司名}-research-{YYYYMMDD}.md` 等）。
5. 报告用中文，直接、犀利、不说废话，评分用 ★（1-5，不含半星），关键数据标注来源。

### 准出：数据抽检（报告写完后必须执行）

```bash
python3 {baseDir}/tools/report_audit.py extract --report <报告文件>
# 对清单每项从可靠信源取数（双源），填 fetched_value / fetched_source / fetched_value2 / fetched_source2
python3 {baseDir}/tools/report_audit.py verdict --results '<填好的JSON>' --report <报告文件名>
```

- **【准出】** 全部抽检点偏差 ≤1% → 报告可发布
- **【打回】** 任意点偏差 >1% → 修正后重审，直到准出

## 工具总览

| 工具 | 用途 |
|---|---|
| `{baseDir}/tools/financial_rigor.py` | 市值/估值/多源交叉验证，精确十进制，杜绝心算误差 |
| `{baseDir}/tools/terminal_value.py` | 十年折现估值：r/ROIC/g 三输入 + audit 三条硬约束准出 |
| `{baseDir}/tools/twstock_data.py` | 台股 FinMind 取数（行情/估值/财务/月营收/股利，自带市值验算） |
| `{baseDir}/tools/ashare_data.py` | A股数据取数 |
| `{baseDir}/tools/report_audit.py` | 报告数据抽检准出（extract → verdict） |
| `{baseDir}/tools/morningstar_fair_value.py` | 晨星公允估值参考 |

## 快速开始

用户说"帮我研究一下腾讯"或"估值一下这家公司"时：

1. 读路由表选 `investment-research`（或 `investment-team` 团队化）。
2. 先做信息丰富度评级 + 偏见自查。
3. 按模块执行，数据双源 + 工具验算。
4. 报告写入 `reports/` 后跑数据抽检准出。

更多触发示例见 `{baseDir}/README.md`；fastagent 安装与常见问题见 `{baseDir}/references/fastagent-install.md`。

## 边界与责任

- 本框架是**研究工具**，不构成投资建议，不承诺任何收益。
- AI 置信度 ≠ 投资确定性：报告必须区分"哪些结论基于充分数据、哪些基于有限推理"。
- 未上市公司数据标记 `[估计]`，不执行交叉验证；涉密或一手信息缺失时诚实留白。
