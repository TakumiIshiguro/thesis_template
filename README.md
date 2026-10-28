# thesis_template

林原研究室向けの卒論・修論テンプレートです．
[matsumotokoki/thesis_template](https://github.com/matsumotokoki/thesis_template) を元にしています．

## 動作確認済み環境

| 項目 | バージョン |
|---|---|
| OS | Ubuntu 20.04.6 LTS |
| TeX Live | 2026（`~/.local/texlive/2026`，scheme-full） |
| latexmk | 4.88 |
| e-upTeX | 3.141592653-p4.1.2-u2.02-251130-2.6 |
| upBibTeX | 0.99e-j0.36-u2.02 |
| dvipdfmx | 20260317 |
| VSCode | 1.139.0 |
| LaTeX Workshop | 10.20.0 |

## 環境構築

Ubuntu（WSL を含む）を前提にしています．TeX Live（upLaTeX，upBibTeX，latexmk）を入れて，VSCode でビルドします．

### 1. TeX Live を入れる

公式のインストーラで，ホームディレクトリの下（`~/.local/texlive/<年>`）に入れます．
`scheme-full` で数 GB あります．

```bash
sudo apt install -y wget perl
cd /tmp
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar xzf install-tl-unx.tar.gz
cd install-tl-2*

YEAR=$(date +%Y)   # インストーラの年と違う場合は合わせる（例: 2026）
perl ./install-tl --no-interaction \
  --scheme=full \
  --no-doc-install --no-src-install \
  --texdir="$HOME/.local/texlive/$YEAR" \
  --texmflocal="$HOME/.local/texlive/texmf-local" \
  --paper=a4
```

`PATH` に追加して，読み込み直します．

```bash
echo 'export PATH="$HOME/.local/texlive/'"$YEAR"'/bin/x86_64-linux:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 2. インストールの確認

```bash
latexmk -v
uplatex --version
kpsewhich jsbook.cls
kpsewhich -progname=upbibtex junsrt.bst
```

どれもバージョンかファイルのパスが表示されれば大丈夫です．

### 3. テンプレートを取得する

```bash
git clone https://github.com/TakumiIshiguro/thesis_template.git
cd thesis_template
code . 
```

### 4. VSCode

- 拡張機能 LaTeX Workshop を入れます．
- リポジトリのフォルダを開くと，`.vscode/settings.json` の設定で保存時に自動ビルドされ，PDF はタブで表示されます．
- `.vscode/settings.json` は，LaTeX Workshop に upLaTeX でビルドさせるための設定です．消すと既定の pdfLaTeX でビルドされ，日本語を処理できずにエラーになります．
- `latexmk` が見つからないと言われる場合は，VSCode を再起動して，`PATH` の設定を読み込ませてください．

## ビルド

基本は VSCode でファイルを保存すれば自動でビルドされ，`build/thesis.pdf` ができます．
ターミナルからビルドする場合は次のコマンドが使えます．

| コマンド | 内容 |
|---|---|
| `make` | ビルドして `build/thesis.pdf` を作る |
| `make view` | ビルドして PDF を開く |
| `make watch` | 保存するたびに自動でビルドする |
| `make clean` | 中間ファイルと `build/` を消す |

## 構成

```
thesis.tex              全体（章の追加はここ）
.vscode/                VSCode（LaTeX Workshop）のビルド設定
thesis.sty              表紙，参照用コマンド
frontmatter/            概要，目次
chapters/<章>/main.tex  各章（序論，関連研究，提案手法，実験，結論）
backmatter/             参考文献，付録，謝辞
main_bibliography.bib   参考文献（junsrt，`\nocite{*}` で全件を掲載）
images/                 図
```

章を増やすときは `chapters/` にディレクトリを作り，`thesis.tex` に `\include{chapters/<章>/main}` を追加します．

## 参照用コマンド

| コマンド | 出力 |
|---|---|
| `\figref{fig:sample}` | Fig. 1.1 |
| `\tabref{tab:sample}` | Table 4.1 |
| `\eqnref{eq:control}` | Eq. (3.1) |
| `\chapref{chap:method}` | 第3章 |
| `\secref{sec:background}` | 1.1節 |
| `\cite{scenario_si2023}` | [1] |

## 注意

- ビルドのたびに，すべての `.tex` の「、」「。」が「，」「．」に書き換えられます（ソースファイル自体が変わります）．
  不要なら `.latexmkrc` の `convert_punctuation();` の行を消してください．