group "default" {
  targets = ["builder", "latest"]
}

target "builder" {
  context    = "."
  dockerfile = "Dockerfile"
  platforms  = ["linux/amd64", "linux/arm64/v8"]
  tags = [
    "registry.cn-shanghai.aliyuncs.com/nethost/bun:1.2-builder",
    "docker.io/nethost/bun:1.2-builder",
    "quay.io/nethost/bun:1.2-builder",
    "ghcr.io/nethost/bun:1.2-builder",
  ]
  push = true
}

target "latest" {
  context    = "."
  dockerfile = "Dockerfile"
  platforms  = ["linux/amd64", "linux/arm64/v8"]
  tags = [
    "registry.cn-shanghai.aliyuncs.com/nethost/bun:1.2",
    "docker.io/nethost/bun:1.2",
    "quay.io/nethost/bun:1.2",
    "ghcr.io/nethost/bun:1.2",
  ]
  push = true
}