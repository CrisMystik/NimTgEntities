#[
  Copyright 2021 CrisMystik (https://github.com/CrisMystik)

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
]#

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

template escape*(s: string, pm: ParseMode): string =
  ## Some characters may have a special meaning
  ## in the parse mode used; this template will
  ## replace these characters with safe variants
  var result: string
  if escapeSyntax.hasKey(pm):
    if escapeSyntax[pm].hasKey(s):
      result = escapeSyntax[pm][s]
    else:
      result = s
  result

template toEntities*() =
  discard

template toFormatting*(e: Entity, closing: bool, pm: ParseMode): string =
  ## Converts the given entity (`e`) in the
  ## representation of given parse mode (`pm`)
  ## `closing` should be true
  ## if this is entity's ending
  formatSyntax[pm][e.kind][int(closing)] % e.extra
