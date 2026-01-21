# Итоговый проект модуля «Облачная инфраструктура. Terraform».

В рамках итогового проекта выполнено следующее:

* Собрано простое web-приложение (с описанием Dockerfile).
* Настроена инфраструктура в Yandex Cloud и развернуто приложение в облачной среде, используя Terraform.

## Задание 1. Развертывание инфраструктуры в Yandex Cloud.

Описаны и созданы следующие ресурсы в облаке Яндекс с помощью конструкции Terraform:

## Virtual Private Cloud (VPC). 
```hcl
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
```
## Подсети.
```hcl
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}
```
## Виртуальная машина (VM)
```hcl

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
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vm_web_nat
    security_group_ids = [yandex_vpc_security_group.web-app.id]
  }
}
............................................
```
## ВГруппы безопасности
```hcl

resource "yandex_vpc_security_group" "web-app" {
  name       = "web-app"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description    = "SSH access"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTP access"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTPS access"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Allow all outbound traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
```
## БД MySQL в Yandex Cloud
```hcl

resource "yandex_mdb_mysql_cluster" "mysql" {
  name        = var.mysql_cluster_name
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.develop.id
  version     = "8.0"

  resources {
    resource_preset_id = "s2.micro"  
    disk_type_id       = "network-ssd"
    disk_size          = 10
  }

  host {
    zone             = var.default_zone
    subnet_id        = yandex_vpc_subnet.develop.id
    assign_public_ip = false
  }
}

resource "yandex_mdb_mysql_database" "my_db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = var.mysql_db_name
}

resource "yandex_mdb_mysql_user" "app_user" {
  name       = var.mysql_user_name
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  password   = var.mysql_user_password

  permission {
    database_name = var.mysql_db_name
    roles         = ["ALL"]
  }
  depends_on = [yandex_mdb_mysql_database.my_db]
}
```
## Container Registry
```hcl

resource "yandex_container_registry" "my-registry" {
  name = "my-registry"
}

resource "yandex_container_repository" "my-repository" {
  name = "${yandex_container_registry.my-registry.id}/my-repository"
}
```
