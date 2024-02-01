provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-mysql"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  skip_final_snapshot = true
  db_name = "example_database"
  username = var.db_username
  password = var.db_password
}

module "webserver_cluster" {
  source = "../../../module/services/webserver-cluster"
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id
  from_port = 12345
  to_port = 12345
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


/*
terraform {
  backend "s3" {
    bucket = "terraform-state-cloudwave-st04-mysql"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}
*/
