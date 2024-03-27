terraform {
  backend "s3" {
    bucket  = "github-oidc-terraform-aws-tfstates-orquestracao"
    encrypt = true
    key     = "orquestracao_rodolfo.tfstate"
    region  = "us-east-1"
  }
}