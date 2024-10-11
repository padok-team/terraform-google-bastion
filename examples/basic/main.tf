locals {
  project_id = "padok-cloud-factory"
  region     = "europe-west-3"
}

module "bastion" {
  source            = "../.."
  project_id        = local.project_id
  region            = local.project_id
  name              = "terratest-bastion-basic"
  network_self_link = "projects/${local.project_id}/regions/${local.project_id}/networks/default"
  subnet_self_link  = "projects/${local.project_id}/regions/${local.project_id}/subnetworks/default"
  members           = ["user:aurelien.vungoc@theodo.com", "user:clement.sol@theodo.com"]
}
