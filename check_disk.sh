
#!/bin/bash

SEUIL=${1:-80}

UTILISATION=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ -z "$UTILISATION" ]; then
    echo "Erreur : impossible de lire l'utilisation du disque."
    exit 1
fi

echo "Utilisation du disque : $UTILISATION %"
echo "Seuil autorise : $SEUIL %"

if [ "$UTILISATION" -ge "$SEUIL" ]; then
    echo "ALERTE : espace disque insuffisant !"
    exit 1
else
    echo "OK : espace disque suffisant."
    exit 0
fi
