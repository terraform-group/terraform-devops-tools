resource "docker_image" "gitlab" {
  name         = "gitlab/gitlab-ce:14.9.3-ce.0"
  keep_locally = true  //销毁时不删除本地镜像
}

resource "docker_container" "gitlab" {
  image = docker_image.gitlab.name
  name  = "devops_tutorial_gitlab"
  ports {
    internal = 80
    external = 80
  }
  ports {
      internal = 22
      external = 2222
  }
  volumes{
      container_path = "/etc/gitlab"
      host_path = "/data/devops4/gitlab/config"
  }
  volumes{
      container_path = "/var/log/gitlab"
      host_path = "/data/devops4/gitlab/logs"
  }
  volumes{
      container_path = "/var/opt/gitlab"
      host_path = "/data/devops4/gitlab/data"
  }
}
