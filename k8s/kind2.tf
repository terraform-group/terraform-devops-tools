terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.0.12"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }
  }
}

provider "kind" {}

variable "kind_cluster_config_path" {
  type    = string
  default = "/root/.kube/config"

}

output "kubeconfig" {
  value = kind_cluster.default.kubeconfig
}

resource "kind_cluster" "default" {
  name            = "test-cluster"
  node_image      = "kindest/node:v1.24.0"
  kubeconfig_path = pathexpand(var.kind_cluster_config_path)
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      kubeadm_config_patches = [
        <<-EOT
          kind: InitConfiguration
          imageRepository: registry.aliyuncs.com/google_containers
          networking:
            serviceSubnet: 10.0.0.0/16
          nodeRegistration:
            kubeletExtraArgs:
              node-labels: "ingress-ready=true"
          ---
          kind: KubeletConfiguration
          cgroupDriver: systemd
          cgroupRoot: /kubelet
          failSwapOn: false
        EOT
      ]

      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
      }
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
  }
}
resource "null_resource" "wait_for_instatll_ingress" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      kind load  docker-image k8s.gcr.io/ingress-nginx/controller:v1.2.0 --name test-cluster
      kind load  docker-image k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1  --name test-cluster
      kubectl create ns ingress-nginx
      kubectl apply -f ingress.yaml -n ingress-nginx
      printf "\nWaiting for the nginx ingress controller...\n"
      kubectl wait --namespace ingress-nginx \
        --for=condition=ready pod \
	--selector=app.kubernetes.io/component=controller \
        --timeout=90s
    EOF
  }

  depends_on = [kind_cluster.default]
}
