# terraform-devops-tools
使用Terraform操作Docker部署DevOps工具链




## 使用说明

```
terraform init
terraform plan
terraform apply 

# 仅部署某个资源   
terraform apply -target=docker_container.sonarqube 
````
