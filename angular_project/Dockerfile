# ─── Stage 1 : Build ─────────────────────────────────────────────────────────
# On part d'une image Node.js légère (Alpine) pour compiler l'application.
# L'alias "builder" permet de référencer ce stage depuis le stage suivant.
FROM node:20-alpine AS builder

# Définit le répertoire de travail dans le conteneur
WORKDIR /app

# Copie uniquement les fichiers de dépendances en premier.
# Cela exploite le cache Docker : si package.json n'a pas changé,
# la couche npm ci n'est pas reconstruite inutilement.
COPY package.json package-lock.json ./

# Installe les dépendances de manière reproductible (basé sur package-lock.json)
RUN npm ci

# Copie le reste du code source (src/, angular.json, tsconfig*, etc.)
COPY . .

# Lance le build de production Angular → génère dist/olympic-games-starter/
RUN npm run build


# ─── Stage 2 : Serve ─────────────────────────────────────────────────────────
# Image finale, beaucoup plus légère : seulement Nginx + les fichiers compilés.
# Node.js, npm et le code source sont complètement absents de cette image.
FROM nginx:alpine

# Remplace la configuration Nginx par défaut par notre configuration personnalisée
# (gzip, cache des assets, fallback index.html pour le routing Angular)
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copie uniquement le dossier dist/ produit par le stage "builder"
# et le place dans /app, chemin attendu par nginx.conf (directive root /app)
COPY --from=builder /app/dist/olympic-games-starter/browser /app

# Documente le port exposé par le conteneur (Nginx écoute sur 80)
EXPOSE 80
