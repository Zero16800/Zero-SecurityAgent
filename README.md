# Zero-SecurityAgent - AI 自动化渗透测试框架

## 项目简介

Zero-SecurityAgent 是一个基于 AI 的自动化渗透测试框架，支持 **Ollama / OpenAI / Claude** 三种 AI 模型。它可以自动完成信息收集、漏洞扫描、攻击模拟、报告生成等渗透测试全流程工作。

---

## 快速开始

### 1. 环境准备

```bash
# 安装依赖
pip install -r requirements.txt
```

依赖列表：
| 包名 | 用途 |
|------|------|
| requests | HTTP 请求（Web 扫描、API 调用） |
| urllib3 | HTTP 底层库（已禁用 SSL 验证） |
| paramiko | SSH 暴力破解模块 |
| scapy | PCAP 流量分析模块 |

> `paramiko` 和 `scapy` 是可选的——对应的模块会在缺失时自动跳过并提示。

### 2. 配置 AI 模型

首次使用前建议运行配置向导：

```bash
python -m security_agent.main --config
```

向导会依次询问：
1. **AI 提供商**：`ollama` / `openai` / `claude`
2. **API Key**（openai/claude 需要）
3. **模型名称**（如 `llama3`、`gpt-4`、`claude-3-opus-20240229`）
4. **Ollama 地址**（默认 `http://localhost:11434`）
5. **扫描线程数**（默认 50）
6. **超时时间**（默认 3 秒）
7. **报告输出目录**（默认 `./reports`）

或者直接通过命令行指定：

```bash
# 使用 Ollama
python -m security_agent.main -t http://172.16.32.10 --ai ollama --model llama3

# 使用 OpenAI
python -m security_agent.main -t http://172.16.32.10 --ai openai --model gpt-4 --api-key sk-xxx

# 使用 Claude
python -m security_agent.main -t http://172.16.32.10 --ai claude --model claude-3-opus-20240229 --api-key sk-ant-xxx
```

### 3. 查询本地模型列表

```bash
python -m security_agent.main --list-models
```

会查询 Ollama 的 `/api/tags` 和 `/v1/models` 两个端点，自动适配标准 Ollama 和 OpenAI 兼容模式。

---

## 命令行参数完整说明

| 参数 | 简写 | 说明 | 默认值 |
|------|------|------|--------|
| `--target` | `-t` | 目标 URL 或 IP 地址 | 必填 |
| `--quick` | `-q` | 快速模式（只扫 Top20 端口） | 关闭 |
| `--full` | | 完整模式（扫描全端口 1-65535） | 关闭 |
| `--pcap` | | 分析 PCAP 包捕获文件 | - |
| `--ai` | | AI 提供商: ollama/openai/claude | ollama |
| `--model` | | AI 模型名称 | 见配置 |
| `--api-key` | | API 密钥（openai/claude） | 空 |
| `--no-portscan` | | 禁用端口扫描 | 启用 |
| `--no-webscan` | | 禁用 Web 漏洞扫描 | 启用 |
| `--no-brute` | | 禁用暴力破解 | 启用 |
| `--no-traffic` | | 禁用流量分析 | 启用 |
| `--no-ai` | | 禁用 AI 智能分析 | 启用 |
| `--output` | | 报告输出目录 | ./reports |
| `--config` | | 运行配置向导 | - |
| `--list-models` | | 列出可用 AI 模型 | - |
| `--threads` | | 扫描线程数 | 50 |
| `--timeout` | | 超时时间（秒） | 5 |
| `--safe` | | 安全模式（仅扫描不攻击） | 关闭 |
| `--verbose` | `-v` | 详细输出模式 | 关闭 |

---

## 使用场景

### 场景 1：全自动渗透测试（推荐）

```bash
python -m security_agent.main -t http://172.16.32.10
```

自动执行：
1. ✅ 端口扫描（Top 1000 端口）
2. ✅ Web 漏洞扫描
3. ✅ 暴力破解（SSH/FTP/HTTP 表单）
4. ✅ AI 智能分析
5. ✅ 报告生成（JSON + Markdown + HTML）

### 场景 2：快速扫描（仅 Top 20 端口）

```bash
python -m security_agent.main -t http://172.16.32.10 --quick
```

### 场景 3：Web 专项扫描（禁用其他模块）

```bash
python -m security_agent.main -t http://172.16.32.10 --no-portscan --no-brute --no-traffic
```

### 场景 4：流量分析

```bash
python -m security_agent.main --pcap capture.pcap
```

### 场景 5：内网横向移动（IP 目标）

```bash
python -m security_agent.main -t 192.168.1.1 --full
```

### 场景 6：使用指定 AI 模型

```bash
# 本地 Ollama
python -m security_agent.main -t http://172.16.32.10 --ai ollama --model qwen2:7b

# OpenAI
python -m security_agent.main -t http://172.16.32.10 --ai openai --model gpt-4-turbo --api-key sk-xxx

# Claude
python -m security_agent.main -t http://172.16.32.10 --ai claude --model claude-3-sonnet-20240229 --api-key sk-ant-xxx
```

---

## 模块功能详解

### 1. 端口扫描模块 (`modules/port_scanner.py`)

- **功能**：TCP 端口扫描 + Banner 抓取 + 服务识别
- **端口列表**：
  - `quick`: Top 20 端口
  - `top-1000`: 1000 个常用端口（默认）
  - `full`: 全端口 1-65535
- **服务识别**：内置 30+ 常见服务（HTTP/SSH/MySQL/RDP 等）
- **Banner 抓取**：自动识别服务版本信息

### 2. Web 漏洞扫描模块 (`modules/web_scanner.py`)

- **功能**：自动化 Web 漏洞检测
- **检测类型**：
  | 漏洞类型 | 检测方法 | 严重等级 |
  |----------|----------|----------|
  | SQL 注入 | 错误信息检测 + Payload 测试 | Critical |
  | XSS（反射型/存储型） | Payload 回显检测 | High |
  | LFI 本地文件包含 | 系统文件读取检测 | Critical |
  | RCE 命令执行 | 命令执行结果检测 | Critical |
  | SSRF | 内网地址访问检测 | High |
- **Pikachu 靶场专用**：自动发现并测试 Pikachu 的 12+ 漏洞页面
- **技术栈识别**：自动检测 Server/X-Powered-By/PHP/MySQL/jQuery

### 3. 暴力破解模块 (`modules/brute_forcer.py`)

- **SSH 暴力破解**：需要 `paramiko` 库
- **FTP 暴力破解**：纯 Socket 实现
- **HTTP 表单暴力破解**：POST 表单登录爆破
- **内置字典**：
  - 用户名：`admin` / `root` / `test` / `pikachu` 等
  - 密码：`admin` / `123456` / `password` / `pikachu` 等

### 4. 流量分析模块 (`modules/traffic_analyzer.py`)

- **功能**：网络流量异常检测
- **需要**：`scapy` 库（PCAP 文件分析）
- **检测能力**：
  - 异常流量模式（高频连接）
  - 端口扫描行为
  - DoS 攻击模式
  - 暴力破解目标识别

### 5. AI 智能分析模块 (`ai_provider.py`)

- **功能**：AI 驱动的漏洞分析和报告生成
- **支持的 AI 后端**：
  | 后端 | 协议 | 配置项 |
  |------|------|--------|
  | Ollama | 原生 API / OpenAI 兼容 | `base_url`, `model` |
  | OpenAI | OpenAI API | `api_key`, `model` |
  | Claude | Anthropic API | `api_key`, `model` |
- **分析能力**：
  - 漏洞自动识别与分类
  - 严重等级评估（Critical/High/Medium/Low）
  - 攻击路径链分析
  - 修复建议生成
  - 完整安全报告生成

### 6. 报告生成模块 (`report.py`)

自动生成三种格式报告：

| 格式 | 文件名示例 | 特点 |
|------|-----------|------|
| JSON | `security_report_20260524_210856.json` | 结构化数据，适合二次处理 |
| Markdown | `security_report_20260524_210856.md` | 可读性强，可直接查看 |
| HTML | `security_report_20260524_210856.html` | 可视化报表，带样式和统计图 |

HTML 报告包含：
- 执行摘要（漏洞统计、端口统计）
- 漏洞详情表格（按严重等级着色）
- 端口扫描结果
- 修复优先级建议列表

---

## AI 模型配置详解

### Ollama 配置

支持两种 API 模式：

1. **原生模式**（默认）：调用 `/api/generate`
   ```
   base_url: http://localhost:11434
   ```

2. **OpenAI 兼容模式**：调用 `/v1/chat/completions`
   ```
   base_url: http://localhost:11434
   model: llama3
   ```
   如果原生 API 失败，会自动降级到 OpenAI 兼容模式。

配置示例：
```json
{
  "ai": {
    "provider": "ollama",
    "ollama": {
      "model": "llama3",
      "base_url": "http://localhost:11434",
      "temperature": 0.3
    }
  }
}
```

### OpenAI 配置

```json
{
  "ai": {
    "provider": "openai",
    "openai": {
      "api_key": "sk-xxxxxxxx",
      "model": "gpt-4",
      "base_url": "https://api.openai.com/v1",
      "temperature": 0.3,
      "max_tokens": 4096
    }
  }
}
```

### Claude 配置

```json
{
  "ai": {
    "provider": "claude",
    "claude": {
      "api_key": "sk-ant-xxxxxxxx",
      "model": "claude-3-opus-20240229",
      "base_url": "https://api.anthropic.com/v1",
      "max_tokens": 4096
    }
  }
}
```

---

## 项目结构

```
E:\ZeroClaw\dayZero\
├── security_agent/           # 主程序包
│   ├── __init__.py           # 版本信息
│   ├── main.py               # CLI 入口
│   ├── config.py             # 配置管理
│   ├── ai_provider.py        # AI 模型集成
│   ├── report.py             # 报告生成
│   ├── utils.py              # 工具函数
│   └── modules/              # 功能模块
│       ├── __init__.py
│       ├── port_scanner.py   # 端口扫描
│       ├── web_scanner.py    # Web 漏洞扫描
│       ├── brute_forcer.py   # 暴力破解
│       └── traffic_analyzer.py # 流量分析
├── reports/                  # 报告输出目录
├── docs/                     # 文档目录
├── requirements.txt          # 依赖列表
├── run.bat                   # 快速启动脚本
└── README.md                 # 本文件
```

---

## 测试结果（Pikachu 靶场）

以 Pikachu 靶场（`http://172.16.32.10`）测试结果：

```
[+] Target: http://172.16.32.10
[+] Start Time: 2026-05-24 21:07:52

[*] Starting port scan: 172.16.32.10
  [+] Port 25/tcp  SMTP
  [+] Port 80/tcp  HTTP
  [+] Port 110/tcp  POP3
  [+] Port 135/tcp  MSRPC
  [+] Port 143/tcp  IMAP
  [+] Port 443/tcp  HTTPS
  [+] Port 445/tcp  SMB
  [+] Port 3306/tcp  MySQL [5.7.26-log]
  ...
  Port scan done: 10 open (42.8s)

[*] Starting web vulnerability scan
  Target reachable: HTTP 200
  Found 0 forms, 71 links
  Found Pikachu page: /vul/sqli/sqli_str.php
  Found Pikachu page: /vul/sqli/sqli_id.php
  Found Pikachu page: /vul/xss/xss_reflected_get.php
  Found Pikachu page: /vul/rce/rce_eval.php
  ...
  [!] Pikachu SQL injection confirmed: /vul/sqli/sqli_str.php
  [!] Pikachu SQL injection confirmed: /vul/sqli/sqli_id.php

[v] Auto Pentest Complete!
[v] Total Time: 64.6s
[v] Vulnerabilities Found: 4
```

---

## 适用场景

| 场景 | 说明 |
|------|------|
| 红队演练 | 模拟真实攻击，评估企业安全防御能力 |
| CTF 比赛 | 自动化信息收集和漏洞发现，加速解题 |
| Web 应用渗透测试 | 检测 SQL 注入、XSS、RCE 等常见 Web 漏洞 |
| 内网横向移动 | 端口扫描 + 服务识别 + 弱口令爆破 |
| 密码破解与暴力攻击 | SSH/FTP/HTTP 表单登录爆破 |
| 流量分析与威胁检测 | PCAP 包分析 + 异常流量识别 + 攻击行为检测 |
| APT 攻击模拟 | 多阶段攻击链模拟 + AI 路径规划 |
| 漏洞赏金挑战 | 快速扫描 + AI 分析 + 报告生成 |
| 企业安全评估 | 中小企业低成本安全检测方案 |

---

## 注意事项

1. **合法使用**：本工具仅用于授权的安全测试和教育目的
2. **Ollama 兼容性**：如果使用 Ollama 的 OpenAI 兼容模式，需确保 Ollama 版本支持 `/v1/chat/completions` 端点
3. **扫描速度**：全端口扫描 1-65535 可能需要较长时间，建议先用 `--quick` 模式
4. **防火墙绕过**：部分目标可能触发 IDS/IPS，请谨慎使用
5. **依赖缺失**：`paramiko`（SSH 爆破）和 `scapy`（流量分析）为可选依赖
