# Bun Container

A production-ready, multi-architecture Docker image for [Bun](https://bun.sh), built from scratch on top of [Debian Bookworm Slim](https://hub.docker.com/_/debian) (or `nethost/debian:12`), with secure signature verification and user namespace hardening.

> **Maintainer:** <hi@billgo.me>

---

## Features

- 🏗 **Multi-stage build:** Downloads and verifies the Bun binary from GitHub Releases using GPG and SHA256.
- 🔒 **Minimal & secure:** No extra packages, runs as non-root user by default.
- 🐧 **Based on Debian Bookworm Slim:** (or optionally `nethost/debian:12`) for a familiar runtime environment.
- 🤝 **Symlinks included:** `/usr/local/bin/bun`, `/usr/local/bin/bunx`, `/usr/local/bun-node-fallback-bin/node` for Node.js compatibility.
- 📦 **Supports global install:** `bun install -g` works out of the box.
- 🔁 **Custom entrypoint:** Use `docker-entrypoint.sh` to control launch behavior.
- ✅ **ARM64 & AMD64:** Architecture detection and correct Bun binary download.
