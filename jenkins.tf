resource "docker_image" "jenkins" {
  name         = "jenkins/jenkins:2.332.2-centos7-jdk8"
  keep_locally = true //销毁时不删除本地镜像
}

resource "docker_container" "jenkins" {
  image = docker_image.jenkins.name
  name  = "devops_tutorial"
  ports {
    internal = 8080
    external = 8080
  }
  ports {
    internal = 50000
    external = 50000
  }
  volumes {
    container_path = "/var/jenkins_home"
    host_path      = "/data/devops4/jenkins_home"
  }
}
