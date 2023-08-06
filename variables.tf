variable "token" {
  description = "YC token"
  type        = string
  sensitive   = true
}

variable "cloud_id" {
  description = "YC Cloud id"
  type        = string
  sensitive   = true
}

variable "folder_id" {
  description = "YC folder id"
  type        = string
  sensitive   = true
}

variable "ssh-key" {
  description = "SSH Key"
  type        = string
  sensitive   = true
}

variable "ssh-login" {
  description = "SSH Login"
  type        = string
  sensitive   = true
}
