#!/bin/bash

# Verzeichnis mit den Markdown-Dateien
DIRECTORY="/Users/breiting/notes/Journal/2025/01/"

# Durchlaufe alle Markdown-Dateien im Verzeichnis
for file in "$DIRECTORY"/*.md; do
    # Überprüfen, ob die Datei existiert
    if [[ -f "$file" ]]; then
        # Ersetze die Frontmatter mit gsed
        gsed -i \
            -e '/^---$/,/^---$/ {                       # Zwischen den ersten beiden --- Zeilen:
      s/^Datum:/date:/
      s/^  - journal$/  - Daily/
    }' "$file"

        echo "Updated: $file"
    else
        echo "Skipped (not a file): $file"
    fi

done
