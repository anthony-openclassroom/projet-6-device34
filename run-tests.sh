#!/bin/bash
set -euo pipefail

ROOT_DIR="${1:-$(pwd)}"
RESULTS_DIR="$ROOT_DIR/test-results"

# --- Détection du type de projet ---
detect_project_type() {
    local dir="$1"
    if [ -f "$dir/package.json" ] && grep -q '"@angular/cli"' "$dir/package.json"; then
        echo "angular"
    elif [ -f "$dir/build.gradle" ] && grep -q "org.springframework.boot" "$dir/build.gradle"; then
        echo "spring-boot"
    else
        echo "unknown"
    fi
}

# --- Exécution des tests d'un projet ---
run_tests() {
    local project_dir="$1"
    local project_name
    project_name=$(basename "$project_dir")
    local type
    type=$(detect_project_type "$project_dir")

    echo ""
    echo "==> Projet : $project_name  [type détecté : $type]"

    case "$type" in
        angular)
            echo "    Lancement des tests Angular..."
            rm -rf "$project_dir/reports"
            (cd "$project_dir" && npm test 2>&1) || { GLOBAL_EXIT=1; echo "    [ECHEC] Tests Angular échoués."; }
            if ls "$project_dir/reports/"*.xml 1>/dev/null 2>&1; then
                cp "$project_dir/reports/"*.xml "$RESULTS_DIR/"
                echo "    Rapport XML copié dans test-results/"
            else
                echo "    [AVERTISSEMENT] Aucun rapport XML trouvé dans $project_name/reports/"
            fi
            ;;

        spring-boot)
            echo "    Lancement des tests Spring Boot..."
            (cd "$project_dir" && ./gradlew clean test 2>&1) || { GLOBAL_EXIT=1; echo "    [ECHEC] Tests Spring Boot échoués."; }
            if ls "$project_dir/build/test-results/test/"*.xml 1>/dev/null 2>&1; then
                cp "$project_dir/build/test-results/test/"*.xml "$RESULTS_DIR/"
                echo "    Rapports XML copiés dans test-results/"
            else
                echo "    [AVERTISSEMENT] Aucun rapport XML trouvé dans $project_name/build/test-results/test/"
            fi
            ;;

        *)
            echo "    Type inconnu — ignoré."
            ;;
    esac
}

# --- Nettoyage ---
echo "==> Nettoyage de test-results..."
rm -rf "$RESULTS_DIR"
mkdir -p "$RESULTS_DIR"

GLOBAL_EXIT=0
FOUND=0

echo "==> Détection et exécution des tests..."

# Cas 1 : ROOT_DIR est lui-même un projet Angular ou Spring Boot
self_type=$(detect_project_type "$ROOT_DIR")
if [ "$self_type" != "unknown" ]; then
    FOUND=1
    run_tests "$ROOT_DIR"
else
    # Cas 2 : ROOT_DIR est un dossier parent — on parcourt ses sous-répertoires
    for project_dir in "$ROOT_DIR"/*/; do
        [ -d "$project_dir" ] || continue
        sub_type=$(detect_project_type "$project_dir")
        if [ "$sub_type" != "unknown" ]; then
            FOUND=1
            run_tests "$project_dir"
        fi
    done
fi

if [ "$FOUND" -eq 0 ]; then
    echo ""
    echo "==> Aucun projet Angular ou Spring Boot trouvé dans : $ROOT_DIR"
    exit 1
fi

echo ""
echo "==> Contenu final de test-results :"
ls "$RESULTS_DIR" 2>/dev/null || echo "    (aucun rapport généré)"
echo ""

if [ "$GLOBAL_EXIT" -eq 0 ]; then
    echo "==> TOUS LES TESTS ONT REUSSI (exit 0)"
    if [ -d "/Applications/Raycast.app" ]; then
        open raycast://confetti
    fi
else
    echo "==> DES TESTS ONT ECHOUE (exit $GLOBAL_EXIT)"
fi

exit "$GLOBAL_EXIT"
