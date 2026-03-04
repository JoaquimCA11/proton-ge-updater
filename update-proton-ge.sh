#!/usr/bin/env bash

CANDIDATES=(
    "$HOME/.steam/root/compatibilitytools.d"
    "$HOME/.local/share/Steam/compatibilitytools.d"
    "$HOME/.var/app/com.valvesoftware.Steam/data/Steam/compatibilitytools.d"
    "$HOME/snap/steam/common/.steam/steam/compatibilitytools.d"
)

DEST=""
for dir in "${CANDIDATES[@]}"; do
    [ -d "$dir" ] && DEST="$dir" && break
done

[ -z "$DEST" ] && DEST="${CANDIDATES[0]}" && mkdir -p "$DEST"

echo "Pasta de instalação detectada: $DEST"

# --- DOWNLOAD DA RELEASE ---
LATEST=$(curl -H "User-Agent: curl" -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest)
VERSION=$(echo "$LATEST" | grep tag_name | cut -d '"' -f 4)

URL=$(echo "$LATEST" \
    | grep browser_download_url \
    | grep ".tar.gz" \
    | head -n 1 \
    | cut -d '"' -f 4)

if [ -z "$URL" ]; then
    echo "❌ ERRO: GitHub não retornou link de download. Tente novamente."
    exit 1
fi

echo "Baixando $VERSION..."
curl -L "$URL" -o /tmp/proton-ge.tar.gz

echo "Extraindo..."
tar -xvf /tmp/proton-ge.tar.gz -C "$DEST"
rm /tmp/proton-ge.tar.gz

notify-send "Proton GE atualizado" "Nova versão instalada: $VERSION"
echo "✔ Instalação concluída!"

