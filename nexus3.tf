
resource "docker_image" "nexus3" {
  name         = "sonatype/nexus3"
  keep_locally = true //销毁时不删除本地镜像
}

resource "docker_container" "nexus3" {
  image = docker_image.nexus3.name
  name  = "nexus3"
  user  = "root"
  ports {
    internal = 8081
    external = 8081
  }

  volumes {
    container_path = "/nexus-data"
    host_path      = "/data/devops3/nexus3/data"
  }
}

resource "null_resource" "init" {

  provisioner "local-exec" {
    command = <<-EOF
              until [[ -f /data/devops3/nexus3/data/admin.password ]] ;do
                  sleep 1
              done
              
              cat /data/devops3/nexus3/data/admin.password
              EOF




  }

  depends_on = [
    docker_container.nexus3
  ]
}
