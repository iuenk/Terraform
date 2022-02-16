variable "rgname" {
  description = "Resource Group Name"
  default     = "github-action"
  type        = string
}
variable "location" {
  description = "Azure location"
  default     = "West Europe"
  type        = string
}
variable "sname" {
  description = "Azure Storage Account"
  type        = string
}