# device34 — Monorepo Hub

This repository is a **monorepo hub**. Each subdirectory is an independent project with its own tech stack, Dockerfile, and documentation. They share a single CI/CD pipeline at the root level.

---

## Projects

| Directory | Description | Stack |
|---|---|---|
| [`angular_project/`](angular_project/README.md) | Olympic Participation Tracker — tracks countries' participation and medals in the Olympic Games | Angular 20, Node 20, Nginx |
| [`java_project/`](java_project/README.md) | Workshop Organizer Web API — manages registrations, schedules and resources for public workshops | Spring Boot 3.2, Java 21, PostgreSQL 13, Gradle 8.7 |

> New projects can be added as new subdirectories. The CI pipeline is designed to accommodate additional `test-*` and `build-*` jobs alongside the existing ones.

---

## CI/CD Pipeline

The pipeline is defined in [`.github/workflows/ci.yml`](.github/workflows/ci.yml) and runs on every push and pull request.

```
push / pull_request
        │
        ├── test-angular   ──► build-angular ──┐
        │                                      ├──► release (main only)
        └── test-java      ──► build-java   ──┘
```

### Stages

| Stage | Job | Description |
|---|---|---|
| **Test** | `test-angular` | Runs Karma/Jasmine unit tests, publishes JUnit report |
| **Test** | `test-java` | Runs Gradle/JUnit tests, publishes JUnit report |
| **Build** | `build-angular` | Builds and pushes the Angular Docker image to GHCR |
| **Build** | `build-java` | Builds and pushes the Spring Boot Docker image to GHCR |
| **Release** | `release` | Runs `semantic-release` on `main`, creates a GitHub release, tags Docker images with the semantic version |

### Docker images (GHCR)

Images are published to the GitHub Container Registry under:

```
ghcr.io/<owner>/<repo>/angular:<tag>
ghcr.io/<owner>/<repo>/java:<tag>
```

Tags produced per run: `sha-<short-sha>`, `<branch-name>` (or `pr-<number>`).  
On a release: `<semver>` is added on top (e.g. `1.2.0`).

---

## Versioning

Releases follow **[Conventional Commits](https://www.conventionalcommits.org/)** and are automated by [`semantic-release`](https://semantic-release.surge.sh/) via [`.releaserc.json`](.releaserc.json).

| Commit prefix | Version bump |
|---|---|
| `fix:` | patch — `x.x.1` |
| `feat:` | minor — `x.1.0` |
| `feat!:` / `BREAKING CHANGE` | major — `1.0.0` |

On each release, `semantic-release` automatically:
- Bumps the version in `angular_project/package.json` and `java_project/build.gradle`
- Updates `CHANGELOG.md`
- Creates a GitHub Release with generated notes
- Re-tags the Docker images with the new semver

---

## Quick Start

### Angular — Olympic Participation Tracker

**Dev server (local)**
```bash
cd angular_project
npm ci
npm start            # http://localhost:4200
```

**Docker** (builds the image and serves via Nginx)
```bash
cd angular_project
docker compose up -d  # http://localhost:80
```

---

### Spring Boot — Workshop Organizer API

**Local** (requires a running PostgreSQL instance)
```bash
cd java_project
./gradlew bootRun
```

**Docker** (spins up the API + a PostgreSQL 13 container)
```bash
cd java_project
docker compose up -d  # http://localhost:8080
```

The `docker compose` stack waits for the database health check before starting the app. Data is persisted in a named Docker volume (`postgres_data`).

---

### Run all tests

```bash
# Angular
cd angular_project && npm test

# Spring Boot
cd java_project && ./gradlew test
```

Or use the helper script at the root:

```bash
./run-tests.sh
```

---

## Repository Structure

```
device34/
├── .github/
│   └── workflows/
│       └── ci.yml          # Shared CI/CD pipeline
├── .releaserc.json          # semantic-release configuration
├── angular_project/         # Olympic Participation Tracker (Angular)
├── java_project/            # Workshop Organizer Web API (Spring Boot)
└── README.md                # You are here
```
