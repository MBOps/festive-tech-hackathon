variable "resource_prefix" {
  description = "The prefix used for all resources in this example"
  default     = "festive-tech"
}

variable "rglocation" {
  description = "The Azure location for the Resource Group"
  default     = "northeurope"
}

variable "subscription_id" {
  description = "Azure Subscription ID to be used for billing"
}

variable "admin_username" {
  description = "Azure Subscription ID to be used for billing"
}

variable "admin_password" {
  description = "Azure Subscription ID to be used for billing"
}

variable "registry_name" {
  description = "Azure Subscription ID to be used for billing"
}
variable "tag_name" {
  description = "Azure Subscription ID to be used for billing"
}

variable "branch" {
  description = "Github Branch used for deployment"
  default     = "main"
}

variable "repo_url" {
  description = "Github Repo for WebApp deployment"
  default     = "https://github.com/whaakman/festive-tech-santa-wishlist"
}

variable "regions" {
  default = {
    eu-west  = { name = "West Europe", shortname = "euw" }
    uk-south = { name = "UK South", shortname = "uks" }
    eu-north = { name = "North Europe", shortname = "eun" }
  }
}

variable "geos" {
  default = {
    eu = {
      name = "eu"
      regions = {
        eu-west  = { name = "West Europe", shortname = "euw" }
        eu-north = { name = "North Europe", shortname = "eun" }
      }
    }

    uk = {
      name = "uk"
      regions = {
        uk-south = { name = "UK South", shortname = "uks" }
      }
    }
  }
}

variable "geos2" {
  type = list(object({
    geo_id = string
    regions = list(object({
      region_id = string
      name      = string
      shortname = string
    }))
  }))

  default = [
    { geo_id = "eu"
      regions = [
        { region_id = "eu-west", name = "West Europe", shortname = "euw" },
        { region_id = "eu-north", name = "North Europe", shortname = "eun" }
    ] },
    { geo_id = "uk"
      regions = [
        { region_id = "uk-south", name = "UK South", shortname = "uks" }
    ] }
  ]
}

variable "regions2" {
  description = "Regions to be used"
  default = {
    us-west          = { name = "West US", shortname = "", region = "" }
    us-west-2        = { name = "West US 2", shortname = "", region = "" }
    us-central       = { name = "Central US", shortname = "", region = "" }
    us-west-central  = { name = "West Central US", shortname = "", region = "" }
    us-south-central = { name = "South Central US", shortname = "", region = "" }
    us-north-central = { name = "North Central US", shortname = "", region = "" }
    us-east          = { name = "East US", shortname = "", region = "" }
    us-east-2        = { name = "East US 2", shortname = "", region = "" }
    can-central      = { name = "Canada Central", shortname = "", region = "" }
    can-east         = { name = "Canada East", shortname = "", region = "" }
    bra-south        = { name = "Brazil South", shortname = "", region = "" }
    uk-south         = { name = "UK South", shortname = "", region = "" }
    uk-west          = { name = "UK West", shortname = "", region = "" }
    eu-north         = { name = "North Europe", shortname = "", region = "" }
    eu-west          = { name = "West Europe", shortname = "", region = "" }
    fr-central       = { name = "France Central", shortname = "", region = "" }
    ger-west-central = { name = "Germany West Central", shortname = "", region = "" }
    swz-north        = { name = "Switzerland North", shortname = "", region = "" }
    norw-east        = { name = "Norway East", shortname = "", region = "" }
    saf-north        = { name = "South Africa North", shortname = "", region = "" }
    ind-west         = { name = "West India", shortname = "", region = "" }
    ind-central      = { name = "Central India", shortname = "", region = "" }
    ind-south        = { name = "South India", shortname = "", region = "" }
    asia-south-east  = { name = "Southeast Asia", shortname = "", region = "" }
    asia-east        = { name = "East Asia", shortname = "", region = "" }
    kor-central      = { name = "Korea Central", shortname = "", region = "" }
    kor-south        = { name = "Korea South", shortname = "", region = "" }
    jap-east         = { name = "Japan East", shortname = "", region = "" }
    jap-west         = { name = "Japan West", shortname = "", region = "" }
    aus-central      = { name = "Australia Central", shortname = "", region = "" }
    aus-east         = { name = "Australia East", shortname = "", region = "" }
    aus-south-east   = { name = "Australia Southeast", shortname = "", region = "" }
    uae-north        = { name = "UAE North", shortname = "", region = "" }


    #aus-central-2    = { name = "Australia Central 2", shortname = "", region = "" }
    #ch-north         = { name = "China North", shortname = "", region = "" }
    #ch-east          = { name = "China East", shortname = "", region = "" }
    #ch-north-2       = { name = "China North 2", shortname = "", region = "" }
    #ch-east-2        = { name = "China East 2", shortname = "", region = "" }
    #bra-south-east   = { name = "Brazil Southeast", shortname = "", region = "" }
    #fr-south         = { name = "France South", shortname = "", region = "" }
    #ger-north-east   = { name = "Germany Northeast", shortname = "", region = "" }
    #ger-central      = { name = "Germany Central", shortname = "", region = "" }
    #norw-west        = { name = "Norway West", shortname = "", region = "" }
    #saf-west         = { name = "South Africa West", shortname = "", region = "" }
    #swz-west         = { name = "Switzerland West", shortname = "", region = "" }
    #uae-central      = { name = "UAE Central" , shortname = "", region = "" }
  }
}

variable "short_names" {
  description = "Shortnames for Regions to be used in Naming Conventions"
  default = {
    "us-east"          = "ue"
    "us-east-2"        = "ue2"
    "us-central"       = "uc"
    "us-north-central" = "unc"
    "us-south-central" = "usc"
    "us-west-central"  = "uwc"
    "us-west"          = "uw"
    "us-west-2"        = "uw2"
    "can-east"         = "cae"
    "can-central"      = "cac"
    "bra-south"        = "brs"
    "eu-north"         = "eun"
    "eu-west"          = "euw"
    "fr-central"       = "frc"
    "fr-south"         = "frs"
    "uk-west"          = "ukw"
    "uk-south"         = "uks"
    "ger-central"      = "gce"
    "ger-north-east"   = "gne"
    "ger-north"        = "gno"
    "ger-west-central" = "gwc"
    "swz-north"        = "swn"
    "swz-west"         = "sww"
    "norw-east"        = "noe"
    "norw-west"        = "now"
    "asia-south-east"  = "ase"
    "asia-east"        = "ae"
    "aus-east"         = "aue"
    "aus-south"        = "aus"
    "aus-central"      = "auc"
    "aus-central-2"    = "auc2"
    "ch-east"          = "che"
    "ch-north"         = "chn"
    "ch-east-2"        = "che2"
    "ch-north-2"       = "chn2"
    "ind-central"      = "inc"
    "ind-west"         = "inw"
    "ind-south"        = "ins"
    "jap-east"         = "jpe"
    "jap-west"         = "jpw"
    "kor-central"      = "krc"
    "kor-south"        = "krs"
    "saf-west"         = "saw"
    "saf-north"        = "san"
    "uae-central"      = "uaec"
    "uae-north"        = "uaen"
    "aus-south-east"   = "ause"
    "bra-south-east"   = "brse"
  }
}
