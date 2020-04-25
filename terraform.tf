variable "do_token" {}
variable "rancher_api_url" {}
variable "rancher_token_key" {}

data "digitalocean_ssh_key" "ondrejsika" {
  name = "ondrejsika"
}

provider "digitalocean" {
  token = var.do_token
}

provider "rancher2" {
  api_url = var.rancher_api_url
  token_key = var.rancher_token_key
}

resource "rancher2_user" "foo" {
  name = "Foo User"
  username = "foo"
  password = "foo"
  enabled = true
}

resource "rancher2_global_role_binding" "foo" {
  name = "foo"
  global_role_id = "user"
  user_id = rancher2_user.foo.id
}

resource "rancher2_user" "bar" {
  name = "Bar User"
  username = "bar"
  password = "bar"
  enabled = true
}

resource "rancher2_global_role_binding" "bar" {
  name = "bar"
  global_role_id = "user"
  user_id = rancher2_user.bar.id
}

resource "rancher2_cloud_credential" "do" {
  name = "do"
  description = "do"
  digitalocean_credential_config {
    access_token  = var.do_token
  }
}

resource "rancher2_node_template" "do" {
  name = "do"
  description = "foo test"
  digitalocean_config {
    access_token = rancher2_cloud_credential.do.id
    image = "debian-9-x64"
    region = "fra1"
    size = "s-2vcpu-4gb"
  }
}
