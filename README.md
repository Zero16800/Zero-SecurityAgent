# SecurityAgent — AI 自动化渗透测试框架

> 版本 1.0.0 | 支持 Ollama / OpenAI / Claude / 自定义 API

---

## 目录

1. [项目概述](#1-项目概述)
2. [快速开始](#2-快速开始)
3. [项目结构](#3-项目结构)
4. [CLI 命令行工具](#4-cli-命令行工具)
5. [Web UI 使用指南](#5-web-ui-使用指南)
6. [Agent 角色系统](#6-agent-角色系统)
7. [技能库 (Skill Library)](#7-技能库-skill-library)
8. [模块详解](#8-模块详解)
9. [AI 模型配置](#9-ai-模型配置)
10. [报告系统](#10-报告系统)
11. [API 接口参考](#11-api-接口参考)
12. [配置文件参考](#12-配置文件参考)
13. [自定义扩展](#13-自定义扩展)
14. [常见问题](#14-常见问题)

---

## 1. 项目概述

SecurityAgent 是一个基于 **AI 驱动的自动化渗透测试框架**，支持多种 AI 后端（Ollama / OpenAI / Claude / 自定义 API）。它可以自动完成：

- **信息收集**：端口扫描 + Banner 抓取 + 服务识别
- **Web 漏洞扫描**：SQL 注入、XSS、LFI、RCE、SSRF
- **暴力破解**：SSH / FTP / HTTP 表单
- **漏洞利用**：SQLi 利用、RCE 执行、LFI 文件读取、文件上传、反弹 Shell
- **流量分析**：PCAP 包异常检测
- **AI 智能分析**：漏洞识别、攻击路径规划、修复建议
- **报告生成**：JSON / Markdown / HTML 三种格式
- **内置 754 项安全技能库**：覆盖 26 个安全领域
- **Pikachu 靶场专用模块**：自动发现并利用 12+ 漏洞页面

### 技术栈

| 组件          | 技术                                               |
| ------------- | -------------------------------------------------- |
| 后端语言      | Python 3.9+                                        |
| Web 框架      | Flask                                              |
| AI 协议       | OpenAI 兼容 API (支持 Ollama/OpenAI/Claude/自定义) |
| 端口扫描      | Socket + 多线程                                    |
| Web 扫描      | Requests + 正则 Payload 检测                       |
| SSH 爆破      | Paramiko（可选）                                   |
| 流量分析      | Scapy（可选）                                      |
| 前端          | Bootstrap 5 + Bootstrap Icons                      |
| Markdown 渲染 | marked.js                                          |

---

## 2. 快速开始

### 2.1 环境准备

```bash
cd E:\ZeroClaw\dayZero
pip install -r requirements.txt
```

依赖清单：

| 包名     | 用途                | 必需   |
| -------- | ------------------- | ------ |
| requests | HTTP 请求           | ✅      |
| urllib3  | HTTP 底层库         | ✅      |
| pyyaml   | YAML 解析（技能库） | ✅      |
| paramiko | SSH 暴力破解        | ❌ 可选 |
| scapy    | PCAP 流量分析       | ❌ 可选 |

### 2.2 启动方式

**方式一：Web UI（推荐）**

```bash
run.bat start
# 访问 http://localhost:5000
```

**方式二：Web UI（前台）**

```bash
python -m security_agent.web_ui --port 5000
```

**方式三：CLI 命令行**

```bash
python -m security_agent.main -t http://172.16.32.10
```

**方式四：VBS 后台启动**

```bash
wscript.exe start_server.vbs
```

### 2.3 运行管理

| 命令             | 说明                                |
| ---------------- | ----------------------------------- |
| `run.bat start`  | 启动 Web UI（后台，自动打开浏览器） |
| `run.bat stop`   | 停止 Web UI                         |
| `run.bat status` | 检查运行状态                        |

---

## 3. 项目结构

```
E:\ZeroClaw\dayZero\
├── security_agent/                # 主程序包
│   ├── __init__.py                # 版本信息
│   ├── main.py                    # CLI 入口（argparse）
│   ├── web_ui.py                  # Web UI 入口
│   ├── ai_provider.py             # AI 模型适配器
│   ├── config.py                  # 配置管理（单例）
│   ├── config.json                # 配置文件
│   ├── report.py                  # 报告生成器
│   ├── utils.py                   # 工具函数
│   ├── modules/                   # 功能模块
│   │   ├── port_scanner.py        # 端口扫描
│   │   ├── web_scanner.py         # Web 漏洞扫描
│   │   ├── brute_forcer.py        # 暴力破解
│   │   ├── traffic_analyzer.py    # 流量分析
│   │   ├── exploit.py             # 漏洞利用引擎
│   │   ├── ai_pentest.py          # AI 驱动渗透引擎
│   │   ├── skill_library.py       # 技能库加载器
│   │   └── kali_integration.py    # Kali 工具集成
│   └── web/                       # Flask Web UI
│       ├── app.py                 # 路由与 API（910+ 行）
│       ├── templates/             # Jinja2 模板
│       │   ├── base.html          # 基础布局 + 侧边栏
│       │   ├── dashboard.html     # 控制台首页
│       │   ├── scan.html          # 自动渗透
│       │   ├── ai_pentest.html    # AI 渗透测试（含 Agent + 技能库）
│       │   ├── scanners.html      # 独立扫描器
│       │   ├── exploit.html       # 漏洞利用
│       │   ├── kali.html          # Kali 工具集
│       │   ├── reports.html       # 报告中心
│       │   └── config.html        # 系统配置
│       └── static/
│           ├── css/ai_pentest.css
│           └── js/ai_pentest.js
├── skills_library/                # 754 项安全技能库（git clone）
│   └── skills/                    # 每个技能一个目录
├── agents.json                    # 自定义 Agent 配置
├── targets.json                   # 目标列表
├── chat_history.json              # 聊天历史
├── reports/                       # 报告输出目录
├── uploads/                       # 文件上传目录
├── docs/                          # 文档
├── requirements.txt               # Python 依赖
├── run.bat                        # 服务管理脚本
└── start_server.vbs               # 后台启动脚本
```

---

## 4. CLI 命令行工具

### 4.1 基本用法

```bash
python -m security_agent.main -t <目标地址>
```

### 4.2 完整参数

| 参数            | 简写 | 说明                    | 默认      |
| --------------- | ---- | ----------------------- | --------- |
| `--target`      | `-t` | 目标 URL 或 IP          | 必填      |
| `--quick`       | `-q` | 快速模式（Top 20 端口） | 关闭      |
| `--full`        |      | 全端口扫描（1-65535）   | 关闭      |
| `--pcap`        |      | 分析 PCAP 捕获文件      | -         |
| `--ai`          |      | AI 提供商               | ollama    |
| `--model`       |      | 指定 AI 模型            | 见配置    |
| `--api-key`     |      | API 密钥                | -         |
| `--no-portscan` |      | 禁用端口扫描            | 启用      |
| `--no-webscan`  |      | 禁用 Web 扫描           | 启用      |
| `--no-brute`    |      | 禁用暴力破解            | 启用      |
| `--no-traffic`  |      | 禁用流量分析            | 启用      |
| `--no-ai`       |      | 禁用 AI 分析            | 启用      |
| `--output`      |      | 报告输出目录            | ./reports |
| `--config`      |      | 运行配置向导            | -         |
| `--list-models` |      | 列出可用模型            | -         |
| `--threads`     |      | 扫描线程数              | 50        |
| `--timeout`     |      | 超时秒数                | 5         |
| `--safe`        |      | 安全模式（仅扫描）      | 关闭      |
| `--verbose`     | `-v` | 详细输出                | 关闭      |

### 4.3 使用示例

```bash
# 全自动渗透测试
python -m security_agent.main -t http://172.16.32.10

# 快速扫描（仅 Top 20 端口）
python -m security_agent.main -t 192.168.1.1 --quick

# 仅 Web 漏洞扫描
python -m security_agent.main -t http://example.com --no-portscan --no-brute

# 全端口扫描 + 指定 AI 模型
python -m security_agent.main -t 10.0.0.5 --full --ai ollama --model llama3

# 流量分析
python -m security_agent.main --pcap capture.pcap

# 查看可用模型
python -m security_agent.main --list-models

# 运行配置向导
python -m security_agent.main --config
```

---

## 5. Web UI 使用指南

访问 `http://localhost:5000`，左侧导航栏进入各功能页面。

### 5.1 控制台 (`/`)

概览面板，显示：

- 扫描统计（总扫描次数、漏洞总数、报告数）
- 最近扫描记录
- AI 模型信息

### 5.2 自动渗透 (`/scan`)

标准的自动化渗透测试界面：

1. 填写目标地址
2. 选择扫描模式（标准/快速/全量）
3. 选择启用模块（端口扫描/Web扫描/爆破/AI分析）
4. 点击启动，实时查看日志输出
5. 完成后自动生成报告

### 5.3 AI 渗透测试 (`/ai_pentest`)

AI 驱动的智能渗透测试（核心功能）：

- 顶部：目标输入 + Agent 角色选择器
- 左侧：AI 助手对话（支持 Markdown）
- 右上：AI 实时推理面板
- 右下：执行日志
- 快捷技能按钮栏
- 技能库面板

### 5.4 独立扫描器 (`/scanners`)

单独调用各扫描模块：

- 端口扫描（指定主机 + 端口范围）
- Web 漏洞扫描（输入 URL）
- 暴力破解（选择服务类型）
- 流量分析（上传 PCAP 文件）

### 5.5 漏洞利用 (`/exploit`)

漏洞利用工具集：

- SQL 注入利用（GET/POST）
- 命令执行（RCE）
- 文件包含（LFI）
- 反弹 Shell（bash/python/powershell/nc/php）
- Pikachu 靶场一键利用（SQLi + RCE + LFI + 文件上传）

### 5.6 Kali 工具集 (`/kali`)

Kali Linux 工具集成（通过 WSL）：

- 信息收集（nmap/masscan/dnsenum/whatweb/nikto 等）
- Web 应用（sqlmap/dirb/gobuster/wpscan 等）
- 密码攻击（hydra/john/hashcat 等）
- 漏洞利用（metasploit/searchsploit 等）
- 自动生成扫描工作流

### 5.7 报告中心 (`/reports`)

查看和下载已生成的报告（JSON / Markdown / HTML）。

### 5.8 系统配置 (`/config_page`)

配置 AI 模型、扫描参数、报告输出等。

---

## 6. Agent 角色系统

### 6.1 内置 Agent

| ID               | 名称         | 定位               | 系统提示词风格           |
| ---------------- | ------------ | ------------------ | ------------------------ |
| `pentest_expert` | 渗透测试专家 | 全能渗透测试       | 专业、全面、系统化       |
| `red_team`       | 红队专家     | 激进攻击模拟       | 激进、实战、以突破为目标 |
| `web_security`   | Web 安全专家 | Web 漏洞深度检测   | 细致、深入、代码级       |
| `network_expert` | 网络专家     | 网络架构与内网渗透 | 系统化、架构视角         |
| `code_auditor`   | 代码审计专家 | 源代码安全审计     | 严谨、代码级             |
| `defender`       | 安全运维专家 | 防守与修复         | 保守、务实、可落地       |

### 6.2 切换 Agent

Web UI → AI 渗透测试页面 → 目标输入框下方的 **Agent 下拉选择器** → 选择角色。

切换后 AI 的系统提示词随之改变，回答风格和专业方向也会不同。

### 6.3 自定义 Agent

编辑项目根目录 `agents.json`：

```json
[
  {
    "id": "my_agent",
    "name": "自定义Agent",
    "description": "描述",
    "icon": "bi-robot",
    "system_prompt": "你是一名... 用中文回答，侧重...",
    "skills": ["port_scan", "web_scan", "exploit"]
  }
]
```

| 字段            | 类型     | 说明                        |
| --------------- | -------- | --------------------------- |
| `id`            | string   | 唯一标识，小写字母+下划线   |
| `name`          | string   | 显示名称                    |
| `description`   | string   | 简短描述                    |
| `icon`          | string   | Bootstrap Icons 类名        |
| `system_prompt` | string   | 系统提示词，定义 Agent 身份 |
| `skills`        | string[] | 可用技能 ID 列表            |

可用技能 ID：

- `port_scan` - 端口扫描
- `web_scan` - Web 漏洞扫描
- `brute_force` - 弱口令爆破
- `exploit` - 漏洞利用
- `full_test` - 完整渗透

编辑后刷新页面即可，无需重启服务。

---

## 7. 技能库 (Skill Library)

集成了 **Anthropic Cybersecurity Skills**（754 项结构化网络安全技能，覆盖 26 个领域，映射 MITRE ATT&CK / NIST CSF 2.0 / MITRE ATLAS / D3FEND / NIST AI RMF 五个框架）。

### 7.1 AI 自动引用

在聊天中输入问题时，AI 会自动：

1. 从 754 个技能中检索最匹配的 1-2 个
2. 将技能的标准化 Workflow 注入到 AI 上下文
3. 基于专业流程给出回答

例如输入 `检测 172.16.32.10 的 SQL 注入漏洞` → AI 自动引用 `exploiting-sql-injection-vulnerabilities` 技能。

### 7.2 手动浏览

Web UI → AI 渗透测试页面 → 点击「技能库」按钮 → 右侧滑出面板：

- 按子领域分类浏览（45 个领域）
- 搜索框实时检索
- 点开技能查看详情（描述/标签/框架映射/步骤）

### 7.3 覆盖领域

cloud-security, threat-hunting, threat-intelligence, network-security, web-application-security, malware-analysis, digital-forensics, soc-operations, identity-access-management, incident-response, container-security, api-security, ot-ics-security, vulnerability-management, red-teaming, penetration-testing 等 45 个领域。

### 7.4 更新技能库

```bash
cd skills_library
git pull
```

重启服务即可加载最新技能。

---

## 8. 模块详解

### 8.1 端口扫描 (`modules/port_scanner.py`)

- TCP connect 扫描
- Banner 抓取（支持 HTTP/HTTPS/通用服务）
- 服务识别（30+ 常见服务映射）
- 多线程并发
- 四种模式：quick（20 端口）/ top-100（100 端口）/ top-1000（1000 端口）/ full（65535 端口）

### 8.2 Web 漏洞扫描 (`modules/web_scanner.py`)

| 漏洞类型      | 检测方法                    | 严重等级 |
| ------------- | --------------------------- | -------- |
| SQL 注入      | 错误信息检测 + Payload 测试 | Critical |
| XSS（反射型） | Payload 回显检测            | High     |
| LFI 文件包含  | 系统文件读取检测            | Critical |
| RCE 命令执行  | 命令执行结果检测            | Critical |
| SSRF          | 内网地址访问检测            | High     |

Pikachu 靶场专用：自动检测 12+ 预置漏洞页面。

### 8.3 暴力破解 (`modules/brute_forcer.py`)

- **SSH 爆破**：需要 paramiko，内置 8 个用户名 × 20 个密码
- **FTP 爆破**：纯 Socket 实现
- **HTTP 表单爆破**：POST 登录表单

### 8.4 流量分析 (`modules/traffic_analyzer.py`)

- 需要 scapy 库
- 解析 PCAP 文件
- 统计 TOP IP / 端口 / 协议
- 异常检测：高频连接、端口扫描、DoS 模式

### 8.5 漏洞利用 (`modules/exploit.py`)

| 功能             | 说明                                   |
| ---------------- | -------------------------------------- |
| SQLi 利用        | 联合查询注入，提取数据库/用户/版本信息 |
| RCE 利用         | 命令执行（管道/分号/反引号）           |
| LFI 利用         | 目录穿越读取文件                       |
| 文件上传         | Pikachu 靶场绕过上传                   |
| 反弹 Shell       | bash / python / powershell / nc / php  |
| Pikachu 一键利用 | SQLi + RCE + LFI + 文件上传全自动      |

### 8.6 Kali 工具集成 (`modules/kali_integration.py`)

- 通过 WSL 调用 Kali Linux 工具
- 自动检测工具是否可用
- 覆盖信息收集 / Web 应用 / 密码攻击 / 漏洞利用 / 无线网络 / 逆向工程 /  sniffing 等类别
- 自动生成扫描工作流

### 8.7 AI 驱动渗透引擎 (`modules/ai_pentest.py`)

AI 驱动的全自动渗透测试：

- AI 制定攻击计划（`step_plan`）
- AI 解释端口扫描结果并给出建议（`step_port_scan`）
- AI 分析 Web 漏洞并推荐利用顺序（`step_web_scan`）
- AI 决策弱口令爆破（`step_brute_force`）
- AI 漏洞利用方案（`step_exploit`）
- AI 生成总结报告（`step_summary`）
- 交互式聊天（`chat`）：AI 理解用户指令并执行对应操作

---

## 9. AI 模型配置

### 9.1 支持的 AI 后端

| 后端   | 协议                   | 配置文件位置 |
| ------ | ---------------------- | ------------ |
| Ollama | 原生 API / OpenAI 兼容 | `ai.ollama`  |
| OpenAI | OpenAI API             | `ai.openai`  |
| Claude | Anthropic API          | `ai.claude`  |
| 自定义 | OpenAI 兼容            | `ai.custom`  |

### 9.2 配置文件 (`config.json`)

```json
{
  "ai": {
    "provider": "custom",
    "custom": {
      "api_key": "sk-xxx",
      "model": "mimo-v2.5-pro",
      "base_url": "https://your-api.com/v1",
      "temperature": 0.4
    },
    "ollama": {
      "model": "llama3.1",
      "base_url": "http://localhost:11434",
      "temperature": 0.3
    }
  },
  "scanning": {
    "threads": 50,
    "timeout": 5,
    "ports": "top-1000"
  },
  "reporting": {
    "format": "html",
    "output_dir": "./reports"
  },
  "modules": {
    "port_scan": true,
    "web_scan": true,
    "brute_force": true,
    "traffic_analysis": true,
    "ai_analysis": true
  }
}
```

### 9.3 在 Web UI 中配置

系统配置页面：`http://localhost:5000/config_page`

支持：

- 选择 AI 提供商
- 填写 API Key 和 Base URL
- 测试 AI 连接
- 查询可用模型列表
- 修改扫描参数

### 9.4 命令行配置

```bash
# 使用 Ollama
python -m security_agent.main -t http://target --ai ollama --model llama3

# 使用 OpenAI
python -m security_agent.main -t http://target --ai openai --model gpt-4 --api-key sk-xxx

# 使用 Claude
python -m security_agent.main -t http://target --ai claude --model claude-3-opus-20240229 --api-key sk-ant-xxx
```

---

## 10. 报告系统

### 10.1 报告格式

| 格式     | 文件名                                 | 特点                     |
| -------- | -------------------------------------- | ------------------------ |
| JSON     | `security_report_YYYYMMDD_HHMMSS.json` | 结构化数据，适合二次处理 |
| Markdown | `security_report_YYYYMMDD_HHMMSS.md`   | 可读性强                 |
| HTML     | `security_report_YYYYMMDD_HHMMSS.html` | 可视化报表，带样式和统计 |

### 10.2 报告内容

- 执行摘要（漏洞总数、风险等级）
- 端口扫描结果（端口/服务/Banner 表格）
- Web 扫描结果（技术栈/表单/链接）
- 漏洞详情（按严重等级排序：Critical → High → Medium → Low）
- 修复建议
- AI 攻击路径分析
- 优先处理建议

### 10.3 输出目录

默认 `./reports/`，可在配置中修改。

---

## 11. API 接口参考

### 11.1 扫描相关

| 方法 | 路径                            | 说明                  |
| ---- | ------------------------------- | --------------------- |
| POST | `/api/scan/start`               | 启动标准扫描          |
| GET  | `/api/scan/<session_id>/logs`   | SSE 实时日志流        |
| GET  | `/api/scan/<session_id>/status` | 扫描状态查询          |
| POST | `/api/modules/port_scan`        | 独立端口扫描          |
| POST | `/api/modules/web_scan`         | 独立 Web 扫描         |
| POST | `/api/modules/brute_force`      | 独立暴力破解          |
| POST | `/api/modules/traffic_analysis` | 流量分析（上传 PCAP） |

### 11.2 AI 渗透测试

| 方法 | 路径                                  | 说明                |
| ---- | ------------------------------------- | ------------------- |
| POST | `/api/ai_pentest/start`               | 启动 AI 渗透测试    |
| POST | `/api/ai_pentest/chat`                | AI 对话             |
| POST | `/api/ai_pentest/chat_stream`         | AI 对话（SSE 流式） |
| GET  | `/api/ai_pentest/<session_id>/status` | 查询 AI 会话状态    |
| POST | `/api/ai_pentest/<session_id>/stop`   | 停止 AI 会话        |
| GET  | `/api/ai_pentest/history`             | 获取聊天历史        |

### 11.3 Agent 与技能库

| 方法 | 路径                                  | 说明                      |
| ---- | ------------------------------------- | ------------------------- |
| GET  | `/api/agents`                         | 获取所有 Agent + 技能列表 |
| POST | `/api/agents/execute`                 | 执行指定技能              |
| GET  | `/api/skill-library/stats`            | 技能库统计                |
| GET  | `/api/skill-library/search?q=`        | 搜索技能                  |
| GET  | `/api/skill-library/get/<id>`         | 获取技能详情              |
| GET  | `/api/skill-library/subdomain/<name>` | 按领域获取技能            |

### 11.4 漏洞利用

| 方法 | 路径                         | 说明             |
| ---- | ---------------------------- | ---------------- |
| POST | `/api/exploit/sqli`          | SQL 注入利用     |
| POST | `/api/exploit/rce`           | 命令执行         |
| POST | `/api/exploit/lfi`           | 文件包含         |
| POST | `/api/exploit/reverse_shell` | 反弹 Shell       |
| POST | `/api/exploit/pikachu`       | Pikachu 一键利用 |

### 11.5 目标与报告

| 方法            | 路径                      | 说明          |
| --------------- | ------------------------- | ------------- |
| GET/POST/DELETE | `/api/targets`            | 目标管理      |
| GET             | `/api/reports`            | 报告列表      |
| GET             | `/api/reports/<filename>` | 下载报告      |
| GET             | `/api/config`             | 获取/修改配置 |
| POST            | `/api/config/test_ai`     | 测试 AI 连接  |

### 11.6 Kali 工具

| 方法 | 路径                 | 说明           |
| ---- | -------------------- | -------------- |
| GET  | `/api/kali/check`    | 检查 Kali 工具 |
| POST | `/api/kali/command`  | 生成工具命令   |
| GET  | `/api/kali/search`   | 搜索工具       |
| POST | `/api/kali/workflow` | 生成扫描工作流 |

---

## 12. 配置文件参考

### 12.1 `config.json`

AI 模型、扫描参数、报告设置。详见 [9.2 节](#92-配置文件-configjson)。

### 12.2 `targets.json`

预设目标列表：

```json
[
  {"name": "Demo", "url": "http://172.16.32.10", "mode": "standard"}
]
```

### 12.3 `agents.json`

自定义 Agent 角色。详见 [6.3 节](#63-自定义-agent)。

### 12.4 `chat_history.json`

AI 对话历史记录，自动保存最近 100 条消息。

---

## 13. 自定义扩展

### 13.1 添加自定义 Agent

编辑 `agents.json` → 添加 Agent 配置 → 刷新页面。

### 13.2 添加自定义技能

编辑 `agents.json` 中的 `skills` 列表 → 在 `ai_pentest.py` 的 `execute_skill` 方法中添加新 action 的处理逻辑。

### 13.3 添加新的扫描模块

1. 在 `modules/` 下创建新模块文件
2. 在 `main.py` 的 `SecurityAgent` 类中添加调用
3. 在 `web/app.py` 中添加 API 路由
4. 在 Web UI 模板中添加对应页面

### 13.4 更新外部技能库

```bash
cd skills_library
git pull
```

---

## 14. 常见问题

**Q: 启动时提示端口被占用？**
A: 先 `run.bat stop` 或 `taskkill /f /im python.exe` 再启动。

**Q: AI 模型无法连接？**
A: 检查 `config.json` 中的 `base_url`、`api_key`、`model` 是否正确。在 Web UI 配置页面点击「测试连接」。

**Q: 技能库加载失败？**
A: 确保 `skills_library/skills/` 目录存在且有 SKILL.md 文件。如果缺失，重新 clone：

```bash
rmdir /s skills_library
git clone https://github.com/mukul975/Anthropic-Cybersecurity-Skills.git skills_library
```

**Q: 扫描结果不准确？**
A: 扫描结果受网络环境、目标防护措施等因素影响。建议：

- 确保网络连通性
- 适当增加超时时间（`--timeout 10`）
- 使用全端口模式（`--full`）

**Q: 如何更新到最新版本？**
A: 该项目为本地项目，更新需要从源代码仓库拉取或手动覆盖文件。
