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

import std / algorithm

type
  EntityType* = enum
    enBold, enItalic, enCode, enPre, enTextUrl,
    enMentionName, enUnderline, enStrike, enBlockquote
  
  Entity* = object
    offset*: int ## Starting character of the entity
    length*: int ## Number of characters to which it applies
    kind*: EntityType ## Actual type of this entity
    extra*: string ## Needed for enPre, enTextUrl and enMentionName
  
  ParseMode* = enum
    pmMarkdown, pmHtml

converter toRange*(e: Entity): HSlice[system.int, system.int] =
  return e.offset..(e.offset + e.length - 1)

proc entityCmp(x, y: Entity): int =
  return cmp(x.offset, y.offset)
proc specialCmp(x, y: Entity): int =
  return cmp(x.length, y.length)

proc sortAll*(entities: openArray[Entity]): seq[Entity] =
  let part = sorted(entities, entityCmp)
  var cset: seq[Entity]

  for e in part:
    if (not cset.len > 0) or (cset[0].offset != e.offset):
      result.add(sorted(cset, specialCmp))
      cset.setLen(0)
    cset.add(e)
