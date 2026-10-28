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

## ghq / fzf / gwq / tmux

### 依存ツール

必須: `fzf`（0.53 以降）、`git`、`tmux`（3.2 以降。`Prefix + G` の move テーブルは 3.8 以降）

任意: `ghq`、`gwq`、`bat`（プレビュー。無ければ `head`）、`nvim`、`lazygit`

存在しないコマンドを使う関数・キーはエラーメッセージを表示するだけで、シェルや tmux セッションには影響しません。

### Zsh コマンド

設定は `.config/zsh/functions/fzf.zsh` にあり、`.zshrc` から読み込みます。

| コマンド / キー | 機能 |
|---|---|
| `gcd` / `Ctrl+G` | ghq 管理のリポジトリを選んで移動（プレビュー: `git status` と README） |
| `groot` | Git リポジトリのルートに移動 |
| `fbr` | ローカルブランチを選んで `git switch` |
| `fbrm` | リモートブランチを選んで切り替え（ローカルに無ければ追跡ブランチを作成） |
| `flog` | コミット履歴を検索し、選んだコミットを `git show` |
| `fe` | ファイルを選んで Neovim で開く（`Tab` で複数選択） |
| `Ctrl+T` / `Ctrl+R` / `Alt+C` | fzf 標準のファイル / 履歴 / ディレクトリ検索 |

- いずれも `Esc` でキャンセルでき、キャンセル時は何も変更しません。
- `fbr` / `fbrm` は stash を行いません。未コミット変更が切り替え先と衝突する場合は `git switch` がエラーで中断します。
- ファイル検索では `.git`、`node_modules`、`.venv`、`__pycache__` などを除外します。

### tmux 内外での違い

- tmux 内（`$TMUX_PANE` がある場合）: `FZF_TMUX_OPTS='-p 85%,85%'` により、上記コマンドと `Ctrl+T` / `Alt+C` は `fzf-tmux` の popup で開きます。`Ctrl+R`（履歴検索）だけは視線が動かないよう、tmux 内でもプロンプトの下に通常どおり表示します。
- tmux 外: `FZF_DEFAULT_OPTS` のとおり、画面下部 25% に通常の fzf を表示します。
- 配色は `--color=16` と `BAT_THEME=ansi` で、ターミナルの ANSI カラーに従います。

### gwq の Shell Integration

`.config/gwq/config.toml` で `cd.launch_shell = false` を設定しています。
`.zshrc` で `source <(gwq completion zsh)` を読み込むと補完に加えて `gwq()` ラッパー関数が定義され、
`gwq cd`（`-g` でグローバル）で選んだ Worktree へ子シェルを起動せず現在のシェルで移動します。
ラッパーは読み込み時の設定で生成されるため、設定を変更したら `exec zsh` してください。

### tmux キーバインド（ローカル、Prefix は `Ctrl+J`）

| キー | 機能 |
|---|---|
| `Prefix + F` | tmux-fzf メニュー（session / window / pane / command / keybinding） |
| `Prefix + f` | Window を fuzzy に選んで切り替え（tmux 標準の `find-window` を置き換え） |
| `Prefix + g` | 現在の Pane のディレクトリで lazygit を popup 表示 |
| `Prefix + G` | floating pane の move テーブル（tmux 3.8 の標準 `Prefix + g` から移動） |
| `Prefix + t` | 現在の Pane のディレクトリでファイルを選び、絶対パスをコピー（tmux 標準の `clock-mode` を置き換え） |

- `Prefix + t` はパスを tmux buffer に入れ（`Prefix + ]` で貼り付け可能）、`pbcopy` があればクリップボードにもコピーします。`set-clipboard on` により OSC 52 でもターミナルへ送ります。
- popup はシェルの子プロセスなので、popup 内で `cd` しても元の Pane の作業ディレクトリは変わりません。
- `Prefix + f` / `Prefix + F` は押したクライアントの tty を tmux-fzf に渡すため、複数クライアント接続時も切り替え対象は操作元のクライアントです。ただし tmux-fzf が内部で使う `fzf-tmux` の popup 自体は、直近に操作したクライアントに表示されます。

### 設定の反映

```sh
./link.sh          # .config/gwq と .config/zsh のリンクを追加
exec zsh           # Zsh の設定を再読み込み
```

tmux では `Prefix + r` で設定を再読み込みし、初回は `Prefix + I` で tmux-fzf をインストールします。

### SSH 先での制約

- `ssh.tmux.conf`（Prefix `Ctrl+O`、ステータスバー下）は変更していません。TPM を使っていないため tmux-fzf と `Prefix + F/f/g/t` は使えません。
- Zsh のコマンドは、SSH 先でも同じ `.zshrc` と `fzf` があれば動作します。tmux 3.2 未満では popup を使えないため、`FZF_TMUX_OPTS` を消すか tmux を更新してください。
- `ls -G` を使うプレビューは macOS 向けです。
