locals {
  volumes = [
    {
      container_path = "/data/devops4/sonarqube/sonarqube_conf"
      host_path      = "/opt/sonarqube/conf"
    },
    {
      container_path = "/data/devops4/sonarqube/sonarqube_extensions"
      host_path      = "/opt/sonarqube/extension"
    },
    {
      container_path = "/data/devops4/sonarqube/sonarqube_logs"
      host_path      = "/opt/sonarqube/logs"
    },
    {
      container_path = "/data/devops4/sonarqube/sonarqube_data"
      host_path      = "/opt/sonarqube/data"
    }
  ]
}


resource "docker_image" "sonar" {
  name         = "sonarqube:8.9.8-community"
  keep_locally = true //销毁时不删除本地镜像
}

resource "docker_container" "sonarqube" {
  image = docker_image.sonar.name
  name  = "sonarqube"
  ports {
    internal = 9000
    external = 9000
  }

  dynamic "volumes" {
    for_each = local.volumes
    content {
      container_path = volumes.value["container_path"]
      host_path      = volumes.value["host_path"]
    }
  }
}
