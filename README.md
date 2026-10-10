# dotfiles

## 使ってるツール

- `fzf`
- `ghq`
- `gwq`

## tmux の別設定

既存の `.config/tmux/.tmux.conf` と `ssh.tmux.conf` はそのままです。
[izumin5210/dotfiles](https://github.com/izumin5210/dotfiles) の設定を
`.config/tmux/izumin5210/` に追加しています。

リポジトリのルートから次のコマンドで起動できます。

```sh
./.config/tmux/izumin5210/start.sh
```

`link.sh` 実行済みの場合は `~/.config/tmux/izumin5210/start.sh` でも起動できます。
詳細と依存ツールは [別設定の README](.config/tmux/izumin5210/README.md) を参照してください。
