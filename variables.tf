variable "resource_prefix" {
  description = "The prefix used for all resources in this example"
  default     = "Festive-Tech"
}

variable "rglocation" {
  description = "The Azure location for the Resource Group"
  default     = "northeurope"
}

variable "webapplocations" {
  description = "array of locations for webapps"
  type        = list(string)
  default     = ["northeurope", "uksouth", "westeurope"]
}
 
variable "subscription_id" {
  description = "Azure Subscription ID to be used for billing"
}

variable  "branch" {
  description = "Github Branch used for deployment"
  default = "main"
}

variable "repo_url" {
  description = "Github Repo for WebApp deployment"
  default = "https://github.com/whaakman/festive-tech-santa-wishlist"
}