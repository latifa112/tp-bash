
#!/bin/bash

set -Eeuo pipefail

REPO_URL="${1:-https://github.com/latifa112/tp-bash.git}"
DOSSIER="${2:-../tp-bash-ci}"
LOG_FILE="ci.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log "Debut de l'integration continue."

# Etape 1 : recuperer le depot
if [ -d "$DOSSIER/.git" ]; then
    log "Depot deja present : mise a jour."

    if ! git -C "$DOSSIER" pull; then
        log "ERREUR : mise a jour impossible."
        exit 1
    fi
else
    log "Clonage du depot."

    if ! git clone "$REPO_URL" "$DOSSIER"; then
        log "ERREUR : clonage impossible."
        exit 1
    fi
fi

# Etape 2 : verifier les scripts
log "Verification des scripts."

for script in check_disk.sh backup.sh
do
    if [ ! -f "$DOSSIER/$script" ]; then
        log "ERREUR : $script introuvable."
        exit 1
    fi

    if ! bash -n "$DOSSIER/$script"; then
        log "ERREUR : syntaxe incorrecte dans $script."
        exit 1
    fi

    log "OK : $script"
done

# Etape 3 : verifier les permissions
for script in check_disk.sh backup.sh
do
    if [ ! -x "$DOSSIER/$script" ]; then
        log "ERREUR : $script n'est pas executable."
        exit 1
    fi
done

log "Tous les tests sont reussis."
log "Fin de l'integration continue."

exit 0
