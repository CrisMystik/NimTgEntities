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

import std / strutils
import std / unicode
import nim_tg_entities / private / data
import nim_tg_entities / private / types

proc parseFormatting*(text: string, pm: ParseMode): seq[Entity] =
  ## Converts given `text` in a list of entities,
  ## assuming it uses given parse mode (`pm`)

proc parseEntities*(text: string, entities: openArray[Entity], pm: ParseMode): string =
  ## Takes `text` and `entities`, and returns input text with
  ## entities represented on it, based on given parse mode (`pm`)
  let entities = entities.sortAll()
  var
    chars: seq[seq[Entity]]
    open: seq[Entity]

  # Associates each rune
  # with its set of entities
  for e in entities:
    for i in e.toRange():
      chars[i].add(e)
  
  for i, c in chars:
    # First, close previous entities
    for i, e in open:
      if e notin c:
        result.add(toParseSyntax(e, true, pm))
        open.del(i)
    # Next, open new entities
    for e in c:
      if e notin open:
        result.add(toParseSyntax(e, false, pm))
        open.add(e)
    # Allowing escape is literally
    # the point of this shit
    result.add(escape($text.runeAt(i), pm))
  
  # Let's not trust the user/Telegram's backend
  # and check for entities still not closed
  for e in open:
    result.add(toParseSyntax(e, true, pm))

when defined(NimgramSupport):
  include nim_tg_entities / ngsupport

#region Test
when isMainModule:
  discard parseEntities("aa", @[
    Entity(offset: 0, length: 1),
    Entity(offset: 1, length: 1)
  ], pmHtml)
#endregion
