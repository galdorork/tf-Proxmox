## Terraform example file for Proxmox Provisioner

Upgraded to work with Terraform 1.0.

	- Added required providers block to work with a specific telmate version
	- No need to download and compile the module now, it just downloads it from the Terraform Registry; more info here: https://registry.terraform.io/providers/Telmate/proxmox/latest/docs 
	- Currently using Telmate's Proxmox Provider version 2.7.1
	- There's a current issue with the interaction between Proxmox's guest agent and the Proxmox API that causes the terraform creation to last atleast 10 minutes. -> Added the `agent` entry on `0` to disable it.


Make sure you set up the variables needed to run the .tf:

	- ${PROXMOX_URL}
	- ${PROXMOXSUPERSECRETPASSWORD}
	- ${NODETOBEDEPLOYED}
	- ${SSHPERSONALPUBLICKEY}
	- IP Range

Terraform 1.0 here: https://www.terraform.io/downloads.html


