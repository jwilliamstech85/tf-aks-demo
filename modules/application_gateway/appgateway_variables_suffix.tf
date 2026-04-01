variable "appgtw_public_ip_suffix" {
  type        = string
  default     = "pip"
  description = "Suffix of the Public IP resource."
}

variable "appgtw_suffix" {
  type        = string
  default     = "appgtw"
  description = "Suffix of the Application Gateway resource."
}

variable "diag_suffix" {
  type        = string
  default     = "diag"
  description = "Suffix of the Diagnostic Settings."
}