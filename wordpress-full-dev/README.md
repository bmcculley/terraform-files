# Terraform Full WordPress Development Environment

This will use Terraform to setup a full WordPress development environment, using Docker images for MariaDB, WordPress (apache), and Coder Server (edit WordPress right in the browser).

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
variable "docker_user" {
  default = "<linux_user>" # This should be set to the user from the host machine.
}
```

Once the variables are updated:

 - `terraform init`
 - `terraform apply`

At this point WordPress and Coder should now be running.

Happy developing!