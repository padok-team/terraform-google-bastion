module "bastion" {
  source            = "../.."
  project_id        = "padok-playground"
  region            = "europe-west-3"
  name              = "bastion"
  network_self_link = "projects/padok-playground/regions/europe-west1/networks/production"
  subnet_self_link  = "projects/padok-playground/regions/europe-west1/subnetworks/production" 
  members           = ["user:annefloref@padok.fr"]
}
