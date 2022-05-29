# terraform-devops-tools
使用Terraform操作Docker部署DevOps工具链

- 需要Docker-CE环境
- 需要部署Terraform
- 修改docker主机的配置在main.tf



## 使用说明

```
terraform init
terraform plan
terraform apply 

# 仅部署某个资源   
terraform apply -target=docker_container.sonarqube 
````
