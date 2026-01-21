resource "yandex_mdb_mysql_cluster" "mysql" {
  name            = var.mysql_cluster_name
  environment     = "PRODUCTION"
  network_id      = yandex_vpc_network.develop.id
  version         = "8.0"

  resources {
    resource_preset_id = "s2.micro"  
    disk_type_id       = "network-ssd"
    disk_size          = 10             # ГБ
  }

  

  host {
    zone   = var.default_zone
    subnet_id = yandex_vpc_subnet.develop.id
    assign_public_ip = false
  }
}

resource "yandex_mdb_mysql_database" "my_db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = var.mysql_db_name
}

resource "yandex_mdb_mysql_user" "app_user" {
  name     = var.mysql_user_name
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  password = var.mysql_user_password

  permission {
    database_name = var.mysql_db_name
    roles         = ["ALL"]
  }
  depends_on = [yandex_mdb_mysql_database.my_db]
}