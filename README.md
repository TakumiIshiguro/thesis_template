# thesis_template

千葉工業大学 未来ロボティクス学科 林原研究室向けの卒論・修論テンプレートです．
[matsumotokoki/thesis_template](https://github.com/matsumotokoki/thesis_template) を元にしています．

## 環境構築

Ubuntu（WSL を含む）を前提にしています．TeX Live（upLaTeX，upBibTeX，latexmk）を入れて，このリポジトリを clone します．

### 1. TeX Live を入れる

公式のインストーラで，ホームディレクトリの下（`~/.local/texlive/<年>`）に入れます．sudo は不要です．
`scheme-full` で数 GB あり，30 分〜1 時間ほどかかります．

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

手軽に済ませたい場合は apt でも入ります（Ubuntu の版によって TeX Live が古いことがあります）．

```bash
sudo apt install -y texlive-lang-japanese texlive-latex-extra latexmk
```

### 2. 入ったか確認する

```bash
latexmk -v
uplatex --version
kpsewhich jsbook.cls
kpsewhich -progname=upbibtex junsrt.bst
```

どれもバージョンかファイルのパスが表示されれば大丈夫です．

### 3. clone してビルドする

```bash
git clone git@github.com:TakumiIshiguro/thesis_template.git
cd thesis_template
make            # build/thesis.pdf ができる
```

### 4. VSCode（任意）

- 拡張機能 LaTeX Workshop を入れる（WSL の場合は WSL 拡張で WSL 側に接続してから入れる）．
- リポジトリのフォルダを開くと，`.vscode/settings.json` の設定で保存時に自動ビルドされ，PDF はタブで表示される．
- LaTeX Workshop の既定の設定は pdfLaTeX でビルドするため，このテンプレートではエラーになる．`.vscode/settings.json` は消さずに使う．
- `latexmk` が見つからないと言われる場合は，VSCode（WSL の場合は WSL 側）を再起動して，`PATH` の設定を読み込ませる．

## ビルド

```
make        # build/thesis.pdf を作る
make view   # ビルドして PDF を開く
make watch  # 保存するたびに再ビルド
make clean  # 中間ファイルと build/ を消す
```

## 書き換える場所

`thesis.tex` の「ここを書き換える」の部分だけです．

| 項目 | 書き方 |
|---|---|
| 論文種別 | `\thesis{卒 業 論 文}` または `\thesis{修 士 論 文}` |
| 題目 | `\title{...}` |
| 指導教員 | `\teacher{...}` |
| 学籍番号・氏名 | `\author{...}` |
| 所属 | `\organization{...}` |

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
| `\cite{nomad}` | [1] |

## 注意

- ビルドのたびに，すべての `.tex` の「、」「。」が「，」「．」に書き換えられます（ソースファイル自体が変わります）．
  不要なら `.latexmkrc` の `convert_punctuation();` の行を消してください．
- 図は PNG / JPG / PDF をそのまま `\includegraphics` できます．
