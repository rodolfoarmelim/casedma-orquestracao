variable "conta_aws" {
  type        = string
  description = "Variável para especificar a conta AWS"
}

variable "sf_role" {
  type        = string
  description = "Variável para especificar o SF Role"
}

variable "eventbridge_role" {
  type        = string
  description = "Variável para especificar o EventBridge Role"
}

variable "tags" {
  type        = map(string)
  description = "Variável para especificar as tags"
}
