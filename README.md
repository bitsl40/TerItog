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

## Подсети.
```hcl
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}
