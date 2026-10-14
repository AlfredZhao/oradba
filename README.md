# oradba

基于 **SQLcl** 的只读 Oracle DBA 脚本包与统一入口。它不替代 SQLcl，也不重复实现 SQLcl 原生能力；目标是把经过筛选的成熟诊断 SQL，以统一的只读边界、参数校验、授权提示和输出规范交付给 DBA 使用。目标环境为 Oracle AI Database 26ai，同时兼容 Oracle Database 19c。

## 前提

- 已安装 SQLcl，并且 `sql -v` 可用。
- SQLcl Connection Manager 已配置连接，例如 `test_alfred`：`sql /nolog` 后执行 `connmgr list`。
- 使用专用只读 DBA 运维账号。
- AWR/ASH 功能需要已获准使用 Oracle Diagnostics Pack，且账号具备相关视图和 `DBMS_WORKLOAD_REPOSITORY` 权限。

## 启动一个持续的 SQLcl 会话

```bash
./bin/oradba
```

首次通过 `./bin/oradba` 启动时，启动器会自动将项目的 `bin` 目录加入当前用户的 shell 启动文件：macOS 的默认 zsh 使用 `~/.zshrc`；bash 在 Linux 使用 `~/.bashrc`，在 macOS 使用 `~/.bash_profile`。这是通过配置 `PATH` 实现的，不会写入密码或连接信息。

**当前终端无法被子进程修改**，因此首次启动完成后请新开一个终端；或者按启动器显示的命令重新加载配置文件。之后可以从任意路径直接运行：

```bash
oradba
oradba sessions
```

如果只想配置命令路径（例如 SQLcl 还未安装完成），可显式执行：

```bash
./bin/oradba install
```

对于 bash/zsh 以外的 shell，或需要指定配置文件时，可自行添加以下变量到对应的启动文件：

```bash
export PATH="/absolute/path/to/oradba/bin:$PATH"
```

默认使用 SQLcl Connection Manager 中的 `test_alfred`。启动器只创建本次输出目录并打开一个 SQLcl 进程；连接与后续诊断均在该进程中完成：

```sql
connect -name test_alfred
```

### 在新环境中指定连接

`test_alfred` 只是项目的默认示例连接名；新环境未配置该连接时，请先确认 SQLcl Connection Manager 中已有可用连接：

```bash
./bin/oradba connections
```

启动交互会话时，通过 `--connection` 指定连接名：

```bash
./bin/oradba --connection your_connection_name
```

批处理命令也使用相同方式：

```bash
./bin/oradba --connection your_connection_name sessions
```

如需在当前终端中持续使用该连接，可设置环境变量：

```bash
export ORADBA_CONNECTION=your_connection_name
./bin/oradba
```

连接名必须是 SQLcl Connection Manager 已保存的名称；若未保存，请先在 SQLcl 中创建或导入连接。

会话内可执行：

```sql
ora_env
ora_tablespaces
ora_sessions
ora_longops
ora_blocking
ora_awr_snapshots

-- SQLcl 原生 AWR HTML 导出（文件写入启动时显示的输出目录）
awr create html <begin_snap> <end_snap>
```

如果保存连接未保存密码，SQLcl 会在终端安全提示输入；密码不会由 oradba 保存、打印或写入命令参数。

列出 SQLcl Connection Manager 连接：

```bash
./bin/oradba connections
```

## 批处理命令

以下命令适合自动化或只执行一个检查的场景；启动器会校验结构化参数后再交给 SQLcl：

```bash
./bin/oradba env
./bin/oradba sessions
./bin/oradba sql-id 0123456789abc 7
./bin/oradba ash-top-waits 24
./bin/oradba awr-snapshots
./bin/oradba awr-report 100 101
```

可用 `--connection NAME` 指定 SQLcl 已保存的连接，或使用 `ORADBA_CONNECTION` 环境变量。`awr-report` 使用 SQLcl 原生 `awr create html`；它按 SQLcl 当前连接的实例生成报告。RAC 的跨实例/全局报告不在这个轻量封装范围内。

## 一期功能

- CDB/PDB、实例、数据库角色与版本环境信息
- 永久/临时表空间使用率
- 活跃用户会话、长操作、当前阻塞会话
- 按 SQL ID 的当前游标、SQL 文本、AWR 历史与实际执行计划
- SQLcl 原生 AWR 快照列表与 HTML 报告导出
- ASH Top Waits

所有一期脚本均为查询或 SQLcl 原生 AWR 报告生成，不包含 DDL/DML、SQL Profile 变更或数据库参数修改。AWR/ASH 的使用仍须具备并遵守 Oracle Diagnostics Pack 的授权与权限要求。
