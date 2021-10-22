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
