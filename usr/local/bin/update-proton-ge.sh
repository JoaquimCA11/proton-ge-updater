#!/usr/bin/env bash

# LISTA DE POSSÍVEIS PASTAS DO STEAM PROTON
CANDIDATES=(
    "$HOME/.steam/root/compatibilitytools.d"
    "$HOME/.local/share/Steam/compatibilitytools.d"
    "$HOME/.var/app/com.valvesoftware.Steam/data/Steam/compatibilitytools.d"
    "$HOME/snap/steam/common/.steam/steam/compatibilitytools.d"
)

DEST=""

# PROCURA A PRIMEIRA PASTA QUE EXISTE
for dir in "${CANDIDATES[@]}"; do
    if [ -d "$dir" ]; then
        DEST="$dir"
        break
    fi
done

# SE NENHUMA EXISTE, CRIAR A PRIMEIRA OPÇÃO
if [ -z "$DEST" ]; then
    DEST="${CANDIDATES[0]}"
    mkdir -p "$DEST"
fi

echo "Pasta de instalação detectada: $DEST"

# ------------------------------------------------------
# DAQUI PRA BAIXO CONTINUA O SCRIPT DE DOWNLOAD/UPDATE
# ------------------------------------------------------

LATEST=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest)
VERSION=$(echo "$LATEST" | grep tag_name | cut -d '"' -f 4)
TARGET_DIR="$DEST/$VERSION"

if [ -d "$TARGET_DIR" ]; then
    echo "Já existe a versão $VERSION instalada. Nada a fazer."
    exit 0
fi

URL=$(echo "$LATEST" | grep browser_download_url | grep tar.gz | cut -d '"' -f 4)

curl -L "$URL" -o /tmp/proton-ge.tar.gz
tar -xvf /tmp/proton-ge.tar.gz -C "$DEST"
rm /tmp/proton-ge.tar.gz

notify-send "Proton GE atualizado" "Nova versão instalada: $VERSION"

