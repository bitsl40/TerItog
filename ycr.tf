resource "yandex_container_registry" "my-registry" {
  name = "my-registry"
}

resource "yandex_container_repository" "my-repository" {
  name = "${yandex_container_registry.my-registry.id}/my-repository"
}

resource "docker_image" "my-app-image" {
  
  name = "cr.yandex/${yandex_container_registry.my-registry.id}/my-app:v1"
  
  build {
    context = "." 
  }
}
resource "docker_registry_image" "push-image" {
  name          = docker_image.my-app-image.name
  keep_remotely = true
}