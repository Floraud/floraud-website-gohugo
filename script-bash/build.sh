#!/bin/sh

# Générer le site Hugo
hugo --source ../src

# Installer Node.js et Pagefind en global pour que ça fonctionne
apk add nodejs npm
npm install -g pagefind

# Lancer Pagefind pour indexer les fichiers
pagefind --site ../src/public/postes

# Lancer le serveur
hugo server --source ../src --bind 0.0.0.0 --port 1313