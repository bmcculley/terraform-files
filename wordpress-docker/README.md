# Terraform WordPress Docker

Use Terraform to setup a WordPress site on Docker.

Note: This assumes you already have a host machince setup with Terraform and Docker.

In order to use this first update the `variables.tf` with your values.

```hcl
variable "mariadb_root_password" {
  default = "<password>" # the MariaDB root user password
}
variable "mariadb_user" {
  default = "<user>" # MariaDB user that WordPress will use to connect.
}
variable "mariadb_password" {
  default = "<password>" # MariaDB password that the WordPress user from above will use to connect.
}
variable "wordpress_port" {
  default = "<8001>" # The port to expose WordPress on the host machine.
}
variable "wordpress_host_path" {
  default = "/path/to/wordpress/on/host" # Path to store WordPress files on the host machine.
}
```

Once the variables are updated:

 - `terraform init`
 - `terraform apply`

At this point WordPress should now be running.