variable "resource_prefix" {
  description = "The prefix used for all resources in this example"
  default     = "Festive-Tech"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
  default     = "northeurope"
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
}