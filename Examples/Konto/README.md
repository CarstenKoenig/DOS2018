# Konto

kleine Beispielapplikation zum Demonstrieren des EventStore

## Benutzung:

Aufruf mit `stack exec Konto -- `
Mögliche Kommandos sind:

- `--help` Hilfe anzeigen
- `stand` Kontostand anzeigen
- `einzahlen [-t TEXT] BETRAG` Betrag einzahlen
- `abheben [-t TEXT] BETRAG` Betrag abheben

### Beispiel:

    stack exec Konto -- abheben -t "tanken" 80
    stack exec Konto -- stand
