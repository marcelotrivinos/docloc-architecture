# main.tf file

# A provider is not used as we are not in the cloud

# Resource to run local commands
resource "null_resource" "install_rabbitmq" {
  # There are no required attributes in this case

  # # Run local commands to install RabbitMQ
  provisioner "local-exec" {
    command = <<EOT
      # Update the package list and install RabbitMQ
      sudo apt-get update -y
      sudo apt-get install -y rabbitmq-server

      # Enable and start the RabbitMQ service
      sudo systemctl enable rabbitmq-server
      sudo systemctl start rabbitmq-server

      # Configure RabbitMQ to listen on all interfaces
      sudo sed -i 's/127.0.0.1/0.0.0.0/' /etc/rabbitmq/rabbitmq.conf

      # Restart RabbitMQ to apply the configuration
      sudo systemctl restart rabbitmq-server
    EOT
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
	  kubectl apply -f deployment.yaml
    EOT
  }
}

resource "null_resource" "install_mysql" {
  # There are no required attributes in this case

  # Run local commands to install MySQL
  provisioner "local-exec" {
    command = <<EOT
      # Install MySQL Server.
      sudo apt-get update
      sudo apt-get install -y mysql-server

      # Start the MySQL service
      sudo systemctl start mysql

      # Make sure MySQL starts automatically on boot
      sudo systemctl enable mysql
	  
	  # Connect to MySQL as the administrator user
	  sudo mysql -u root -p
	  
	  # Create the news database
	  CREATE DATABASE database1;

	  # Select the news database
	  USE database1;

	  # Create a table in the news database
	  CREATE TABLE table1 (
		id INT PRIMARY KEY,
		name VARCHAR(255)
	  );

	  # Create the locations database
	  CREATE DATABASE database1;

	  # Select the locations database
	  USE database1;

	  # Create a table in the locations database
	  CREATE TABLE table1 (
		id INT PRIMARY KEY,
		name VARCHAR(255)
	  );
	  
	  # Create the api user
	  CREATE USER 'api'@'localhost' IDENTIFIED BY 'contraseña';
	  
	  # Grant permissions to the api user for both databases
	  GRANT ALL PRIVILEGES ON news.* TO 'api'@'localhost';
	  GRANT ALL PRIVILEGES ON locations.* TO 'api'@'localhost';
	  
	  # Create the admin user
	  CREATE USER 'admin'@'localhost' IDENTIFIED BY 'contraseña';
	  
	  # Grant permissions to the admin user for both databases
	  GRANT ALL PRIVILEGES ON news.* TO 'admin'@'localhost';
	  GRANT ALL PRIVILEGES ON locations.* TO 'admin'@'localhost';
	  
	  # Apply the changes
	  FLUSH PRIVILEGES;
	  
	  # Close the connection
	  EXIT;
    EOT
  }
}

# Run the provisioner when the configuration is applied
resource "null_resource" "apply_provisioner" {
  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [null_resource.install_rabbitmq, null_resource.install_kubernetes, null_resource.install_mysql]
}