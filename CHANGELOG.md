## [1.1.2](https://github.com/anthony-openclassroom/projet-6-device34/compare/v1.1.1...v1.1.2) (2026-05-12)


### Bug Fixes

* **sonar:** exclude swagger-ui vendor files and generated code from analysis ([619e302](https://github.com/anthony-openclassroom/projet-6-device34/commit/619e302ab4ad2ee25fbba324e4a9a5c0ea09994a))

## [1.1.1](https://github.com/anthony-openclassroom/projet-6-device34/compare/v1.1.0...v1.1.1) (2026-05-12)


### Bug Fixes

* **security:** externalize database credentials to environment variables ([28c22d2](https://github.com/anthony-openclassroom/projet-6-device34/commit/28c22d2c595e1b7f66b83d5960f01a18012e554c))

# [1.1.0](https://github.com/anthony-openclassroom/projet-6-device34/compare/v1.0.0...v1.1.0) (2026-05-12)


### Features

* **ci:** add scheduled CI job to run every Monday at 8:00 UTC for regression detection ([8340bfa](https://github.com/anthony-openclassroom/projet-6-device34/commit/8340bfaf5bd5689c692333dbfe6fdb68b4ac0062))

# 1.0.0 (2026-05-01)


### Bug Fixes

* copy browser/ subfolder to fix 403 on Angular 17+ build output ([3772133](https://github.com/anthony-openclassroom/projet-6-device34/commit/3772133a6f6e035aa6727d6547ff70ac856282ad))
* restore port 80 mapping ([31cb2a2](https://github.com/anthony-openclassroom/projet-6-device34/commit/31cb2a232963974c97f2b86c334ec3cb77ca4e24))
* upgrade to node:22-alpine, required by Angular 20 ([2372475](https://github.com/anthony-openclassroom/projet-6-device34/commit/23724751c8ba24739a2a950c5fedabb6f32caf4c))
* use port 8080 to avoid conflict with port 80 ([594ac41](https://github.com/anthony-openclassroom/projet-6-device34/commit/594ac41063a88b400a13c39f82cca0d5c3f09890))
* use workshops_user as owner in SQL dump to match POSTGRES_USER ([c31a694](https://github.com/anthony-openclassroom/projet-6-device34/commit/c31a6949c2251d20120c3b3a7e3d979e5ced5f81))


### Features

* add multi-stage Dockerfile with Gradle builder and JRE runtime ([0cb292b](https://github.com/anthony-openclassroom/projet-6-device34/commit/0cb292b486639d948caf5e42931c6359f55a944d))
* configure docker-compose with healthcheck, persistence volume and env vars ([1b26675](https://github.com/anthony-openclassroom/projet-6-device34/commit/1b2667588dd1bb81315784b14b65297adfccca6e))
* **tests:** add run-tests.sh script to automate test execution and reporting ([f5389e5](https://github.com/anthony-openclassroom/projet-6-device34/commit/f5389e5fddd69bfb14210b7cbfbb59d1622a2aae))
