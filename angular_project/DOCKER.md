# Lancer l'application avec Docker

## Prérequis

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installé et démarré

## Démarrage

```bash
docker compose up -d
```

L'application est accessible sur **http://localhost**

---

## Problème : port 80 déjà utilisé

Si vous obtenez l'erreur suivante :

```
Error response from daemon: ports are not available: exposing port TCP 0.0.0.0:80 -> 127.0.0.1:0: listen tcp 0.0.0.0:80: bind: address already in use
```

Un service occupe déjà le port 80 sur votre machine. Voici comment identifier et libérer ce port selon votre système.

### macOS / Linux

**Identifier le processus :**

```bash
sudo lsof -nP -iTCP:80 -sTCP:LISTEN
```

**Cas courant — Apache est démarré :**

```bash
sudo apachectl stop
```

**Cas courant — Nginx système est démarré :**

```bash
sudo nginx -s stop
# ou
sudo systemctl stop nginx
```

**Stopper n'importe quel processus par son PID** (remplacer `<PID>` par la valeur trouvée) :

```bash
sudo kill -9 <PID>
```

### Windows

**Identifier le processus :**

```powershell
netstat -ano | findstr :80
```

Repérer le PID dans la dernière colonne, puis :

```powershell
taskkill /PID <PID> /F
```

---

Une fois le port libéré, relancer :

```bash
docker compose up -d
```

---

## Publier l'image sur GitHub Container Registry

GitHub utilise **ghcr.io** (GitHub Container Registry) à la place de GitLab Registry.

### Prérequis

Créer un token GitHub avec la permission `write:packages` :
**Settings → Developer settings → Personal access tokens → Generate new token**

### Variables nécessaires

| Variable | Description |
|----------|-------------|
| `GITHUB_USERNAME` | Votre nom d'utilisateur GitHub |
| `GITHUB_TOKEN` | Le token généré ci-dessus |
| `GITHUB_REPOSITORY` | Ex : `votre-username/olympic-games-starter` |

### Étapes

**1. Se connecter au registry :**

```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin
```

**2. Construire et tagger l'image :**

```bash
docker build -t ghcr.io/$GITHUB_REPOSITORY:latest .
```

**3. Publier l'image :**

```bash
docker push ghcr.io/$GITHUB_REPOSITORY:latest
```

### Utiliser l'image publiée dans docker-compose.yml

Une fois l'image publiée, vous pouvez remplacer le `build` par une référence directe à l'image :

```yaml
services:
  app:
    image: ghcr.io/votre-username/olympic-games-starter:latest
    ports:
      - "80:80"
    restart: unless-stopped
```
