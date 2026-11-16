# dotfiles

## セットアップ

```sh
./setup.sh
```

Nix、mise の公式バイナリ、設定ファイルをセットアップする。
go-task 導入済みの環境では `task setup` も利用できる。

## mise

mise 本体は [公式インストーラー](https://mise.jdx.dev/installing-mise.html)で
`~/.local/bin/mise` に導入する。Nix の更新とは独立して更新できる。
dotfiles では導入スクリプト、シェル連携、ツール一覧を管理し、
mise 本体のバージョンは固定しない。

```sh
task install-mise  # 初回導入。導入済みならスキップ
task update-mise   # mise self-update で本体を更新
```

導入・更新時は公式の既定に従い、公開から24時間以上経過した安定版を選ぶ。
公開直後の版が必要な場合は `mise self-update --minimum-release-age 0s` を使う。

ランタイムや CLI の一覧は `config/mise/config.toml` で管理する。
このファイルは Home Manager により `~/.config/mise/config.toml` へリンクされる。

```sh
mise install      # 設定済みのツールを導入
mise upgrade      # 設定のバージョン指定に従ってツールを更新
```

Nix 管理の mise から切り替える既存環境では、次を実行する。

```sh
task install-mise
task nix:rebuild
exec zsh -l
```

`command -v mise` が `~/.local/bin/mise` を指すことを確認する。
以後、Nix の更新は `task nix:update`、mise 本体の更新は `task update-mise` を使う。
