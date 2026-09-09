# Neovim / Android Kotlin LSP（NixOS）

仅使用 JetBrains 官方 Kotlin LSP，不安装或回退到 fwcd/kotlin-language-server。Java 仍由 jdtls 提供。

## 本次故障与修复

1. `262.9593.0` 在启动时输出 `This build of intellij-server has expired` 并退出；`--version` 成功并不能证明 LSP 可用。
2. JetBrains 在 [#271](https://github.com/Kotlin/kotlin-lsp/issues/271) 发布了 `263.4421.0` 的官方下载链接，但 GitHub Releases / Homebrew 配方暂未同步。`home/lsp-servers.nix` 覆盖现有 flake 的版本和源归档，保留 autoPatchelf 与自带 JBR。
3. 新版还有 [#243](https://github.com/Kotlin/kotlin-lsp/issues/243) 的 Android 导入故障：`IdeaKotlinResolvedBinaryDependency cannot be cast to IdeaKotlinDependency`。本地 Nix 打包补丁从 Gradle importer JAR 去除重复的 `org/jetbrains/kotlin/gradle/idea/tcs/` 类，并让其显式依赖 `org.jetbrains.ls.plugin.kotlin`。构建时要求 47 个条目与 Kotlin 插件保留副本逐字节相同，否则构建失败；不修改源归档、JVM 字节码或过期检查。
4. 包提供标准 `kotlin-lsp` 命令，同时保留原 flake 的 `intellij-server` / `kotlin_lsp` 兼容入口。Neovim 只启用 `kotlin_lsp` 配置，已删除旧服务器配置。

这是基于官方包的**本地打包修复**，不是上游已合并的修复；更新版本时必须重新验证补丁及 Android 语义功能。EAP 仍可能过期，不自动下载浮动最新版，也不修改系统时间绕过过期。

## 为什么不单独开发 Android LSP

官方 `kotlin-lsp` 已负责 Kotlin 的补全、悬浮、诊断和 Gradle 项目代码导航，并支持 Android Gradle 项目导入；但 Android/AGP 支持仍是实验性能力。SDK 源码、`R.*`/`@resource`、XML widget 和 `tools:context` 跳转属于 Android 专用导航，已由 `dotfile/nvim/lua/android/` 作为 Neovim 侧轻量集成处理。只有在官方服务已成功 attach、真实项目导入成功，且确认存在稳定复现并且无法由该集成补足的 Android 语义缺口时，才应评估独立 LSP 项目。

## 构建与激活

在 `~/nixos-config` 执行：

```sh
# 只构建，不激活；可以不使用 sudo。
nix build --no-link .#nixosConfigurations.ser.config.system.build.toplevel
# 激活系统和集成式 Home Manager，再重启 Neovim。
sudo nixos-rebuild switch --flake .#ser
kotlin-lsp --version  # ILS-263.4421.0
```

本机 Home Manager 使用 `useUserPackages = true`，包来自 `/etc/profiles/per-user/jiannlee22`。**不要混用** `home-manager switch --flake .#jiannlee22`：独立配置不包含系统注入的字体设置，干跑确认会删除当前的 fontconfig 链接。

不激活系统也能单独构建并测试新服务器：

```sh
lsp=$(nix build --impure --no-link --print-out-paths --expr '
  let f = builtins.getFlake (toString ./.);
  in builtins.head (builtins.filter (p: (p.pname or "") == "kotlin_lsp")
    f.homeConfigurations.jiannlee22.config.home.packages)')
KOTLIN_LSP_CMD="$lsp/bin/kotlin-lsp" \
  nvim --headless -u NONE -l tests/kotlin-lsp-smoke.lua
```

默认测试使用临时 Gradle 根目录和嵌套 Kotlin 文件，检查根目录选择、真实 LSP 初始化/attach、存活及 hover/definition/completion 能力。**只通过握手不等于 Android 导入成功。**

Android 语义测试（导入所选项目，会运行 Gradle 并可能下载依赖、写入构建缓存）：

```sh
KOTLIN_LSP_CMD="$lsp/bin/kotlin-lsp" \
KOTLIN_LSP_FILE="$HOME/Project/musicApp/app/src/main/java/com/example/musicapp/MainActivity.kt" \
KOTLIN_LSP_HOVER=4:20 \
  nvim --headless -u NONE -l tests/kotlin-lsp-smoke.lua
```

`KOTLIN_LSP_HOVER` 是 1-based 行号和 UTF-16 列号；上例对应当前文件的 `import android.os.Bundle`。文件变化后需要调整。测试等待最多 180 秒取得非空悬浮结果；项目导入异常直接失败。本次成功返回 `class Bundle : BaseBundle(), Cloneable, Parcelable`。

## Java 补全与 jdtls 排查

Kotlin 和 Java 使用不同的 LSP：Kotlin 使用 `kotlin_lsp`，Java 使用 `jdtls`。在 Java buffer 中先执行 `:JavaLspInfo`：必须显示 `jdtls` 已 attach、正确的 Gradle 根目录以及 `completion: yes`。如果未 attach，检查文件是否位于包含 `gradlew`/`settings.gradle(.kts)`/`build.gradle(.kts)` 的项目中；如果 attach 但没有项目类或 Android 类补全，先在项目根执行 `./gradlew :app:assembleDebug`，再删除对应的 `~/.cache/nvim/jdtls/workspace/<project>-<hash>` 目录并重启 Neovim，让 jdtls 重新导入 classpath。

`jdtls` 运行时要求 Java 21+；Nix 的 `jdt-language-server` wrapper 通常会固定使用打包的 Java 21，`JAVA_HOME` 主要影响 Gradle 项目导入，不依赖 `/usr/lib/jvm` 固定路径。`:LspInfo`、`:JavaLspInfo` 和 `:lua print(vim.lsp.log.get_filename())` 可区分服务未启动、Java 版本错误和 Gradle 导入失败。

## 剩余限制与排查

- 官方 Android Gradle 支持仍是实验性功能；一个项目通过不代表所有 AGP/Kotlin/Gradle 组合兼容。
- `Couldn't resolve ... android:r:null` 或 `.../classes.jar` 表示缺少所选 variant 的生成产物；在项目中构建对应 variant（例如 `./gradlew :app:assembleDebug`），然后重启 LSP。不要通过切换旧服务器掩盖导入问题。
- `:checkhealth vim.lsp` 检查客户端，`:lua print(vim.lsp.log.get_filename())` 定位日志。服务器的 stderr 启动提示也会被 Neovim 标成 `[ERROR]`，必须看内容，不能只看标签。
- 快速握手后立即退出时，上游可能输出 `ClosedSendChannelException`；语义测试同时检查服务存活及实际 RPC 返回，避免误把启动成功当作完整可用。
- 后续升级修改 `home/lsp-servers.nix` 的 `version`、URL、官方 SHA-256，复核 #243 是否修复，再重跑构建及语义测试。不能只更新 `flake.lock`，因为本地 override 仍会覆盖输入版本。
