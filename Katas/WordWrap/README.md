# WordWrap Kata

Die Aufgabe ist es eine Funktion `wrap :: Int -> String -> String`
zu schreiben, die maximale Anzahl an Zeichen (`lineLen`) pro Linie und einen
Eingabetext entegegen nimmt und `\n` so einsetzt, dass der
entstehende Text niemals mehr als `lineLen` Zeichen hat.

Wörter sollen dabei nicht gebrochen werden, es sei denn, sie sind
länger als die erlaubte Zeilenlänge - dann soll das Wort nach dieser
Anzahl an Buchstaben (möglicherweise mehrmals) gebrochen werden.

## Beispiele

```haskell
> wrap 10 "a lot of words for a single line"
"a lot of\nwords for\na single\nline"

> wrap 6 "areallylongword"
"areall\nylongw\nord"
```
