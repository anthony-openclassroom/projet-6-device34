# ================================
# Stage 1 : Build
# JDK 21 (Adoptium) pour compiler avec Gradle
# ================================
FROM eclipse-temurin:21-jdk AS builder

WORKDIR /app

# Copie du wrapper Gradle en premier pour profiter du cache des layers Docker
COPY gradlew gradlew.bat ./
COPY gradle/ gradle/
RUN chmod +x gradlew

# Résolution des dépendances séparément : ce layer n'est recalculé
# que si build.gradle ou settings.gradle change
COPY build.gradle settings.gradle ./
RUN ./gradlew dependencies --no-daemon

# Copie des sources et compilation en WAR exécutable (sans les tests)
COPY src/ src/
RUN ./gradlew bootWar --no-daemon -x test

# ================================
# Stage 2 : Runtime
# JRE 21 uniquement — pas besoin du JDK complet en production
# ================================
FROM eclipse-temurin:21-jre

WORKDIR /app

# Récupération du WAR produit par le stage builder
COPY --from=builder /app/build/libs/*.war app.war

# Utilisateur système dédié — le conteneur ne s'exécute pas en root
RUN groupadd --system spring && useradd --system --gid spring spring
USER spring

EXPOSE 8080

# Le WAR Spring Boot est auto-exécutable via java -jar
ENTRYPOINT ["java", "-jar", "app.war"]
