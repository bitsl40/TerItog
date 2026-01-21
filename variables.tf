###cloud vars

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "web-app"
  description = "VPC network&subnet name"
}

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство образа ОС"
}


variable "vm_web_name" {
  type        = string
  default     = "platform-web"
  description = "Имя ВМ"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "тип платофрмы"
}


variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "Количество ядер"
}

variable "vm_web_memory" {
  type        = number
  default     = 4
  description = "Количество ОЗУ"
}

variable "vm_web_cores_fraction" {
  type        = number
  default     = 20
  description = "Доля ядра"
}

variable "vm_web_preemptible" {
  type    = bool
  default = true
  description = "Прерываемую ВМ (preemptible)"
}

variable "vm_web_nat" {
  type    = bool
  default = true
  description = "Состояние вкл/выкл NAT"
}


variable "vm_metadata" {
  type = object({
    serial-port-enable = number
    ssh-keys           = string
  })
  description = "Общие metadata для всех ВМ: включение serial‑порта и SSH‑ключи"
  default = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINe5CQPAWspyy56JMMB5js6mo0aI2X6owapwEEd19Tjf <опциональный_комментарий>"
  }
}




variable "token" {
  description = "OAuth-токен для Yandex Cloud"
  type        = string
}

variable "cloud_id" {
  description = "ID облака в Yandex Cloud"
  type        = string
}

variable "folder_id" {
  description = "ID папки (folder) в облаке"
  type        = string
}


variable "mysql_cluster_name" {
  description = "Имя кластера MySQL"
  type        = string
  default     = "my-mysql-cluster"
}

variable "mysql_db_name" {
  description = "Имя базы данных"
  type        = string
  default     = "app_db"
}

variable "mysql_user_name" {
  description = "Имя пользователя БД"
  type        = string
  default     = "app_user"
}

variable "mysql_user_password" {
  description = "Пароль пользователя БД"
  type        = string
  sensitive   = true
}
