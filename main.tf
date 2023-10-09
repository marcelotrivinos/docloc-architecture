# main.tf file

# A provider is not used as we are not in the cloud

resource "kubernetes_persistent_volume" "mysql_pv" {
  metadata {
    name = "mysql-pv"  # PV name for MySQL
  }

  spec {
    capacity {
      storage = "5Gi"  # Desired storage capacity for MySQL PV
    }
    access_modes = ["ReadWriteOnce"]  # Access mode for MySQL PV
    persistent_volume_reclaim_policy = "Retain"  # PV reclaim policy
    storage_class_name = "mysql-storage"  # Storage class name for MySQL PV
    host_path {
      path = "/data/mysql"  # Host path where MySQL data will be stored
    }
  }
}

resource "null_resource" "install_kubernetes" {
  # There are no required attributes in this case

  # Run local commands to install Docker and Kubernetes
  provisioner "local-exec" {
    command = <<EOT
      # Update the package list and install Docker
      sudo apt-get update -y
      sudo apt-get install -y docker.io

      # Build images from Dockerfiles
      docker build -t fastapi-image:dev dockerfiles/fastapi
      docker build -t mysql-image:dev dockerfiles/mysql

      # Add the Kubernetes repository and GPG key
      sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
      sudo add-apt-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

      # Install kubeadm, kubectl, and kubelet
      sudo apt-get update -y
      sudo apt-get install -y kubeadm kubectl kubelet

      # Initialize the Kubernetes cluster (this is just an example, proper configuration should be followed)
      sudo kubeadm init --pod-network-cidr=10.244.0.0/16

      # Configure kubectl for the current user
      mkdir -p $HOME/.kube
      sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      sudo chown $(id -u):$(id -g) $HOME/.kube/config

      # Install a network plugin (example: Calico)
      kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml
	  
	    # Run the desired Kubernetes YAML file (replace with the location of your YAML file)
	    kubectl apply -f manifests/

      # Create the MySQL and RabbitMQ Persistent Volumes
      kubectl apply -f mysql-pv.yaml
    EOT
  }
}

# Run the provisioner when the configuration is applied
resource "null_resource" "apply_provisioner" {
  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [null_resource.install_kubernetes]
}