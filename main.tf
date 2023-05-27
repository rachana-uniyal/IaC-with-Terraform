resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cider_block
  tags       = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
  source                 = "./modules/subnet"
  avail_zone             = var.avail_zone
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  env_prefix             = var.env_prefix
  subnet_cider_block     = var.subnet_cider_block
  vpc_id                 = aws_vpc.myapp-vpc.id
}

module "myapp-server" {
  source              = "./modules/webserver"
  avail_zone          = var.avail_zone
  default_sg_id       = aws_vpc.myapp-vpc.default_security_group_id
  env_prefix          = var.env_prefix
  instance_type       = var.instance_type
  my_ip               = var.my_ip
  public_key_location = var.public_key_location
  subnet_id           = module.myapp-subnet.subnet.id
  vpc_id              = aws_vpc.myapp-vpc.id
  image_name          = var.image_name
}
