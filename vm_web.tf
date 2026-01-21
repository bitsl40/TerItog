data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_cores_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_nat
    security_group_ids = [yandex_vpc_security_group.web-app.id]
  }

  metadata = {
    serial-port-enable = var.vm_metadata.serial-port-enable
    ssh-keys           = var.vm_metadata.ssh-keys
    user-data = <<EOF
${file("${path.module}/cloud-init.yaml")}
  - |
    echo "${var.token}" | docker login --username oauth --password-stdin cr.yandex
    docker run -d --name app -p 80:5000 \
      -e DB_HOST="c-${yandex_mdb_mysql_cluster.mysql.id}.rw.mdb.yandexcloud.net" \
      -e DB_NAME="${var.mysql_db_name}" \
      -e DB_USER="${var.mysql_user_name}" \
      -e DB_PASSWORD="${var.mysql_user_password}" \
      --restart always \
      ${docker_registry_image.push-image.name}
EOF
  }
  depends_on = [
    yandex_mdb_mysql_user.app_user,
    docker_registry_image.push-image
  ]
}