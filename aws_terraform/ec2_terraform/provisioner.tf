  provisioner "remote-exec" {
    inline = ["sudo dnf -y install python"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("keys/mykeypair")}"
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i '${self.public_ip},' --private-key ${file("keys/mykeypair")} provision.yml" 
  }