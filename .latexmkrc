#!/usr/bin/env perl
# upLaTeX + upBibTeX（junsrt）．Ubuntu（WSL を含む）を前提にしている．

use utf8;
use File::Find;
use File::Path qw(make_path);

# 中間ファイルと PDF は build/ に出す
$out_dir = 'build';

# コンパイルのたびに，.tex 中の「、」「。」を「，」「．」へ書き換えてから uplatex を呼ぶ
# （ソースファイル自体が変わる）．不要なら convert_punctuation() の行を消す．
$latex = 'internal uplatex_with_punct %O %S';
$bibtex = 'upbibtex %O %S';
$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'makeindex %O -o %D %S';

# upLaTeX -> dvipdfmx
$pdf_mode = 3;
$max_repeat = 10;

sub uplatex_with_punct {
  convert_punctuation();
  make_out_subdirs();
  return system('uplatex', '-synctex=1', '-interaction=nonstopmode',
                '-file-line-error', '-halt-on-error', @_);
}

sub skip_dir {
  return $File::Find::name =~ m{^\./(build|\.git|\.vscode)(/|$)};
}

sub convert_punctuation {
  find({ no_chdir => 1, wanted => sub {
    if (-d $_ && skip_dir()) { $File::Find::prune = 1; return; }
    return unless -f $_ && /\.tex$/;
    open(my $in, '<:encoding(UTF-8)', $_) or return;
    local $/; my $text = <$in>; close($in);
    (my $new = $text) =~ tr/、。/，．/;
    return if $new eq $text;
    open(my $out, '>:encoding(UTF-8)', $_) or return;
    print $out $new; close($out);
  }}, '.');
}

# \include した章の .aux は build/ の下の同じ相対パスに書かれるため，
# ディレクトリを先に作っておく（無いと 1 回ごとに 1 つずつしか作られず失敗する）．
sub make_out_subdirs {
  find({ no_chdir => 1, wanted => sub {
    return unless -d $_;
    if (skip_dir() || $File::Find::name =~ m{^\./images(/|$)}) {
      $File::Find::prune = 1; return;
    }
    make_path("$out_dir/$File::Find::name");
  }}, '.');
}
