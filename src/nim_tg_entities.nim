import std / strutils
import std / unicode
import nim_tg_entities / private / data
import nim_tg_entities / private / types

proc parseFormatting*(text: string, pm: ParseMode): seq[Entity] =
  discard

proc parseEntities*(text: string, entities: openArray[Entity], pm: ParseMode): string =
  let entities = entities.sortAll()
  var
    chars: seq[seq[Entity]]
    open: seq[Entity]

  for e in entities:
    for i in e.toRange():
      chars[i].add(e)
  
  for i, c in chars:
    for o in open:
      if o notin c:
        result.add(toParseSyntax(o, true, pm))
        open.del(e)
    for e in c:
      if e notin open:
        result.add(toParseSyntax(e, false, pm))
        open.add(e)
    result.add(escape($text.runeAt(i), pm))
  
  for o in open:
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

#[
var a: seq[Entity]
let b = Entity(offset: 2, length: 1, kind: enBold)
echo b notin a
]#