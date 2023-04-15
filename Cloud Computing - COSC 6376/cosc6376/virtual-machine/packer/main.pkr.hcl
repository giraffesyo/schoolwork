packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.0.0"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}


source "googlecompute" "google" {
  project_id = var.gcp_project_id
  source_image_project_id = ["rocky-linux-cloud"]
  source_image_family = "rocky-linux-9-optimized-gcp"
  ssh_username = "packer"
  image_name = "nodejs-app-image"
  image_family = "nodejs-app"
  zone = var.gcp_zone
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
  image_description = "Node.js app image on Rocky Linux"
}

build {
  sources = [
    "source.googlecompute.google"
  ]

  provisioner "file" {
    source      = "./build.zip"
    destination = "/tmp/build.zip"
  }

  provisioner "file" {
    source      = "./nodejs-app.service"
    destination = "/tmp/nodejs-app.service"
  }

  provisioner "shell" {
    inline = [
      "sudo dnf install -y epel-release",
      "sudo dnf install -y curl",
      "curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -",
      "sudo dnf install -y nodejs",
      "sudo unzip /tmp/build.zip -d /tmp/app",
      "sudo mkdir /opt/nodejs-app",
      "sudo mv /tmp/app/* /opt/nodejs-app/",
      "cd /opt/nodejs-app && sudo yarn",
      "sudo mv /tmp/nodejs-app.service /etc/systemd/system/",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable nodejs-app",
      "sudo systemctl start nodejs-app"
    ]
  }
}





