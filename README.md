# Google Bastion Terraform module

Terraform module that creates a bastion VM you can connect to through IAP using the outputted `command_to_connect`

This module uses the OSLogin feature of GCP, this makes the legacy SSH Metadata setup stop working on the bastion VM.

> :information the OSLogin 2FA option to connect to bastion instance is enabled by default. Set variable `two_factor` to `false` if not needed.

> :warning: For users external to your organization you will need to give them at org-level this role `roles/compute.osLoginExternalUser`

> :information_source: You can also use shuttle by piping the command like that `sshuttle -e 'gcloud compute ssh --tunnel-through-iap --project <GCP-PROJECT> --zone europe-west1-b' -r bastion 10.0.0.0/16`

## Usage

```hcl
module "bastion" {
  source           = "https://github.com/padok-team/terraform-google-bastion"
  project_id       = "project"
  name             = "bastion"
  subnet_self_link = "projects/<project>/regions/<region>/subnetworks/<subnet_name>"
  members          = ["user:test@padok.fr", "group:test-group@padok.fr"]
}
```

## Examples

- [Default](examples/default/main.tf)

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name to give the bastion VM | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | ID of the project in which the bastion VM will be deployed | `string` | n/a | yes |
| <a name="input_subnet_self_link"></a> [subnet\_self\_link](#input\_subnet\_self\_link) | Subnet self\_link in which the bastion VM will be deploy | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to add to the bastion VM | `map(string)` | `{}` | no |
| <a name="input_members"></a> [members](#input\_members) | List of members inside the organization that can connect to the bastion VM through IAP | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Network tags to add to the bastion VM | `list(string)` | `[]` | no |
| <a name="input_two_factor"></a> [two\_factor](#input\_two\_factor) | Enable the 2FA option to connect to bastion instance | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_command_to_connect"></a> [command\_to\_connect](#output\_command\_to\_connect) | Command to connect to the bastion instance |
<!-- END_TF_DOCS -->
