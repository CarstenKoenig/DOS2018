---
title:
- Haskell Workshop

author:
- Developer Open Space 2018

theme:
- Copenhagen
---

# Kata's

- Coin Change
- Overlapping Rectangles
- Word Wrap

# Coin Change

Deine Aufgabe ist es, eine Funktion 

    wechsle :: Betrag -> [Muenze]
    
zu schreiben.
Die Funktion soll eine Liste von Münzen zurückliefern, deren Wert sich zum übergebenen
Betrag summiert. `Betrag` ist dabei ein ganzzahliger Cent-Wert $\geq 0$.

Die Ausgabe soll die kleinste Anzahl an Münzen mit absteigend angeordnet liefern.

Gültige Münzen sind unsere EUR Münzen (2€, 1€, 50ct, 20ct, 10ct, 5ct, 2ct, 1ct)

## Beispiel

```haskell
wechsle 173 -- = [ 100, 50, 20, 2, 1 ]
```

# WordWrap Kata

Die Aufgabe ist es eine Funktion 

    wrap :: Int -> String -> String

zu schreiben, die maximale Anzahl an Zeichen (`lineLen`) pro Linie und einen
Eingabetext entegegen nimmt und `\n` so einsetzt, dass der
entstehende Text niemals mehr als `lineLen` Zeichen hat.

Wörter sollen dabei nicht gebrochen werden, es sei denn, sie sind
länger als die erlaubte Zeilenlänge - dann soll das Wort nach dieser
Anzahl an Buchstaben (möglicherweise mehrmals) gebrochen werden.

---

## Beispiele

```haskell
> wrap 10 "a lot of words for a single line"
"a lot of\nwords for\na single\nline"

> wrap 6 "areallylongword"
"areall\nylongw\nord"
```
