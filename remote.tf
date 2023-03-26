resource "null_resource" "remote"{
	connection {
       		type = "ssh"
       		user = "ubuntu"
       		private_key = file("CIaCS_key.ppk")
       		host  = aws_instance.ciacs.public_ip
	}
	provisioner "remote-exec" {
         	inline = [
			"sudo apt update && sudo apt install apache2 -y",
                       	"sudo git clone https://github.com/SmithaVerity/ABTestingApp.git /var/www/html/",
		]
	}
}
