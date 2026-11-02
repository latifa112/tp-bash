
#!/bin/bash

set -Eeuo pipefail

DOSSIER="${1:-data}"
DESTINATION="${2:-backups}"

if [ ! -d "$DOSSIER" ]; then
    echo "Erreur : le dossier $DOSSIER n'existe pas."
    exit 1
fi

mkdir -p "$DESTINATION"

DATE=$(date +%Y-%m-%d_%H-%M-%S)

ARCHIVE="$DESTINATION/backup_$DATE.tar.gz"

echo "Creation de la sauvegarde..."

tar -czf "$ARCHIVE" -C "$(dirname "$DOSSIER")" "$(basename "$DOSSIER")"

echo "Sauvegarde creee : $ARCHIVE"

echo "Suppression des anciennes sauvegardes..."

for fichier in "$DESTINATION"/backup_*.tar.gz
do
    [ -f "$fichier" ] || continue

    ANCIEN=$(find "$fichier" -maxdepth 0 -type f -mtime +7 -print)

    if [ -n "$ANCIEN" ]; then
        rm -f "$fichier"
        echo "Ancienne sauvegarde supprimee : $fichier"
    fi
done

echo "Sauvegarde terminee avec succes."
