import std / tables
import types

const formatSyntax = {
  pmMarkdown: {
    enBold: ["**", "**"],
    enItalic: ["__", "__"],
    enCode: ["`", "`"],
    enPre: ["```$1\n", "\n```"],
    enTextUrl: ["[", "]($1))"],
    enMentionName: ["[", "](tg://user?id=$1)"],
    enUnderline: ["--", "--"],
    enStrike: ["~~", "~~"],
    enBlockquote: ["```\n", "\n```"]
  }.toTable,
  pmHtml: {
    enBold: ["<b>", "</b>"],
    enItalic: ["<i>", "</i>"],
    enCode: ["<code>", "</code>"],
    enPre: ["<pre><code class=\"language-$1\">", "</pre>"],
    enTextUrl: ["<a href=\"$1\">", "</a>"],
    enMentionName: ["<a href=\"tg://user?id=$1\">", "</a>"],
    enUnderline: ["<u>", "</u>"],
    enStrike: ["<s>", "</s>"],
    enBlockquote: ["<pre>", "</pre>"]
  }.toTable
}.toTable

const escapeSyntax = {
  pmHtml: {
    "<": "&lt;",
    ">": "&gt;",
    "&": "&amp;"
  }.toTable
}.toTable

template escape*(s: string, pm: ParseMode) =
  if escapeSyntax.hasKey(pm):
    if escapeSyntax[pm].hasKey(s):
      escapeSyntax[pm][s]
    else: s

template toParseSyntax*(e: Entity, closing: bool, pm: ParseMode) =
  formatSyntax[pm][e.kind][int(closing)] % e.extra
