# Fcitx5 码表与输入法描述（原仓库 fcitx5/ 目录内容迁入此处）。
# 将 *.dict 放在同目录下的 fcitx5-dicts/ 中（与下方 conf 里 File=table/… 文件名一致）。
{ pkgs, lib, ... }:

let
  dictDir = ./fcitx5-dicts;
  hasDictDir = builtins.pathExists dictDir;

  flypyConf = pkgs.writeText "flypy.conf" ''
    [InputMethod]
    Name[da]=flypy
    Name[de]=flypy
    Name[ko]=flypy
    Name[zh_CN]=小鹤音形
    Name=flypy
    Icon=fcitx-shuangpin
    Label=鹤
    LangCode=zh_CN
    Addon=table
    Configurable=True

    [Table]
    File=table/flypy.dict
    PageSize=5
    CommitAfterSelect=True
    CommitWhenDeactivate=True
    CommitInvalidSegment=False
    UseFullWidth=False
    IgnorePunc=False
    FirstCandidateAsPreedit=False
    QuickPhraseKey=
    QuickPhraseText=
    NoSortInputLength=
    OrderPolicy=No
    UseSystemLanguageModel=False
    UseContextRelatedOrder=False
    MatchingKey=`
    PinyinKey=
    AutoSelect=True
    AutoSelectLength=-1
    AutoSelectRegex=^;.$|^\\w{4}$
    NoMatchAutoSelectLength=-1
    NoMatchAutoSelectRegex=
    AutoPhraseLength=0
    SaveAutoPhraseAfter=-1
    ExactMatch=True
    Learning=False
    Hint=False
    DisplayCustomHint=False
    HintSeparator=
    CandidateLayoutHint=


    [Table/PrevPage]
    0=Up
    1=minus

    [Table/NextPage]
    0=Down
    1=equal

    [Table/PrevCandidate]
    0=Left

    [Table/NextCandidate]
    0=Right

    [Table/SecondCandidate]
    0=semicolon
  '';

  tigerConf = pkgs.writeText "tiger.conf" ''
    [InputMethod]
    Name=虎码-单字
    Icon=fcitx-tiger
    Label=虎码-单字
    LangCode=zh_CN
    Addon=table
    Configurable=True

    [Table]
    File=table/tiger.main.dict
    AutoSelect=True
    AutoSelectLength=-1
    NoMatchAutoSelectLength=-1
    NoSortInputLength=2
    Hint=True
    MatchingKey=`
    PinyinKey=*
    OrderPolicy=No
    UseFullWidth=True
    QuickPhraseKey=semicolon
    AutoPhraseLength=4
    SaveAutoPhraseAfter=3
    UseContextRelatedOrder=False
    QuickPhraseText=ABCDEFGHIJLKLMNOPQRSTUVWXYZ
    HintSeparator=

    [Table/PrevPage]
    0=Up
    1=minus

    [Table/NextPage]
    0=Down
    1=equal
  '';

  tigressConf = pkgs.writeText "tigress.conf" ''
    [InputMethod]
    Name=虎码-字词
    Icon=fcitx-tiger
    Label=虎码-字词
    LangCode=zh_CN
    Addon=table
    Configurable=True

    [Table]
    File=table/tigress.main.dict
    AutoSelect=True
    AutoSelectLength=-1
    NoMatchAutoSelectLength=-1
    NoSortInputLength=2
    Hint=True
    MatchingKey=`
    PinyinKey=*
    OrderPolicy=No
    UseFullWidth=True
    QuickPhraseKey=semicolon
    AutoPhraseLength=4
    SaveAutoPhraseAfter=3
    UseContextRelatedOrder=False
    QuickPhraseText=ABCDEFGHIJLKLMNOPQRSTUVWXYZ
    HintSeparator=

    [Table/PrevPage]
    0=Up
    1=minus

    [Table/NextPage]
    0=Down
    1=equal
  '';
in
{
  # 码表 .conf / .dict 只注册输入法；哪些出现在切换栏由 ~/.config/fcitx5/profile 决定（见 home/fcitx5-profile.nix）。
  i18n.inputMethod.fcitx5.addons = [
    (pkgs.runCommand "fcitx5-bundled-tables" { } ''
      mkdir -p "$out/share/fcitx5/inputmethod" "$out/share/fcitx5/table"
      install -Dm644 ${flypyConf} "$out/share/fcitx5/inputmethod/flypy.conf"
      install -Dm644 ${tigerConf} "$out/share/fcitx5/inputmethod/tiger.conf"
      install -Dm644 ${tigressConf} "$out/share/fcitx5/inputmethod/tigress.conf"
      ${lib.optionalString hasDictDir ''
        shopt -s nullglob
        for f in ${dictDir}/*.dict; do
          [[ -f "$f" ]] || continue
          install -Dm644 "$f" "$out/share/fcitx5/table/$(basename "$f")"
        done
      ''}
    '')
  ];
}
