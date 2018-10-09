# Coin Change Problem

Deine Aufgabe ist es, eine Funktion `wechsle :: Betrag -> [Muenze]` zu schreiben.
Die Funktion soll eine Liste von Münzen zurückliefern, deren Wert sich zum übergebenen
Betrag summiert. `Betrag` ist dabei ein ganzzahliger Cent-Wert >= 0.

Die Ausgabe soll die kleinste Anzahl an Münzen mit absteigend angeordnet liefern.

Gültige Münzen sind unsere EUR Münzen (2€, 1€, 50ct, 20ct, 10ct, 5ct, 2ct, 1ct)

## Beispiel

```haskell
wechsle 173 -- = [ 100, 50, 20, 2, 1 ]
```
