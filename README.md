# terraform


## Install Terraform

On Windows, I HIGHLY suggest first installing Chocolatey package manager. It will be used to install Terraform in the next steps. You can get that from here:
https://docs.chocolatey.org/en-us/choco/setup

Or by running in PowerShell:

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Install Terraform following these steps (for various OS platforms):
https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/install-cli

(At least on Windows, I would just skip the “Quick start tutorial” section. It tried to use some out of date docker provider syntax and you’ll spend some time troubleshooting what is supposed to be a quick start procedure.)

Verify Terraform is installed by running: terraform -version

Note: the above is all about command line Terraform

## Create a service account and retrieve the auth key for the account

https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#set-up-gcp
The .json file created will be used in your Terraform code to authenticate to GCP.

Add this as a var in terraform cloud

## Get your project ID to use in Terraform files

You’’ll need your project ID.

In the example below, the project ID is “flash-nimbus-341718”.

<img src="https://raw.githubusercontent.com/paulmsullivan/terraform/main/img/gcp-project.jpg"
  alt="Finding a project ID from GCP console"
  width="654" height="232">

 
## Write a main.tf file to define your resources:

Save this file as “main.tf” in your working directory. Setup the provider by first running “terraform init” in that directory. Then run “terraform apply” to use Terraform to create these resources.


## Google Cloud Platform free tier:

There is a free tier of products available that includes things like 1 very small VM, etc:
https://cloud.google.com/free
