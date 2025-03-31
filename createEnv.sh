#!/bin/bash

# Définition des variables
LOG_FILE="$(dirname "$0")/update.log"
PARENT_DIR="$(dirname "$0")/.."
REPOS=(
    "apiCodeine|https://github.com/DuncanC42/apiCodeine.git"
    "frontend|https://github.com/DuncanC42/frontend.git"
    "panelAdmin|https://github.com/DuncanC42/panelAdmin.git"
)

# Fonction pour écrire dans le log
log() {
    echo "$(date "+%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

log "Début de la mise à jour des dépôts."

# Vérification et mise à jour ou clonage des dépôts
total=${#REPOS[@]}
count=0
for repo in "${REPOS[@]}"; do
    IFS='|' read -r name url <<< "$repo"
    dir="$PARENT_DIR/$name"
    ((count++))
    log "[$count/$total] Traitement du dépôt: $name"

    if [ -d "$dir/.git" ]; then
        log "Le dossier $name existe, mise à jour avec git pull."
        cd "$dir" && git pull origin main 2>&1 | tee -a "$LOG_FILE"
        if [ $? -ne 0 ]; then
            log "Erreur lors du git pull pour $name."
        else
            log "Mise à jour réussie pour $name."
        fi
    else
        log "Le dossier $name n'existe pas, clonage du dépôt..."
        git clone "$url" "$dir" 2>&1 | tee -a "$LOG_FILE"
        if [ $? -ne 0 ]; then
            log "Erreur lors du clonage de $name."
        else
            log "Clonage réussi pour $name."
        fi
    fi
    log "---------------------------------------------"
done

log "Mise à jour des dépôts terminée."
