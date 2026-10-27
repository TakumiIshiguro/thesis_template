INPUT  = thesis.tex
OUTPUT = thesis

all:
	latexmk -jobname=$(OUTPUT) $(INPUT)

# PDF を開く（ビューアは latexmk の既定，Linux では xdg-open）
view:
	latexmk -pv -jobname=$(OUTPUT) $(INPUT)

# 保存するたびに再ビルドする
watch:
	latexmk -pvc -jobname=$(OUTPUT) $(INPUT)

clean:
	latexmk -C -jobname=$(OUTPUT) $(INPUT)
	rm -rf build

.PHONY: all view watch clean
