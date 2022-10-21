module "bastion" {
  source           = "../.."
  project_id       = "padok-playground"
  name             = "bastion"
  subnet_self_link = "projects/padok-playground/regions/europe-west1/subnetworks/production"
  members          = ["user:annefloref@padok.fr"]
}
