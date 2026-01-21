resource "yandex_vpc_security_group" "web-app" {
  name       = "web-app"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description = "SSH access"
    protocol    = "TCP"
    port        = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    protocol    = "TCP"
    port        = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

 
  ingress {
    description = "HTTPS access"
    protocol    = "TCP"
    port        = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  
  egress {
    description = "Allow all outbound traffic"
    protocol    = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}