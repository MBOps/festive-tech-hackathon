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
#  default     = ["northeurope", "uksouth", "westeurope"]
  default     = ["northeurope"]
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

  variable "regions" {
  default = {
    us-west          = "West US"
    us-west-2        = "West US 2"
    us-west-central  = "West Central US"
    us-south-central = "South Central US"
    us-north-central = "North Central US"
    us-east          = "East US"
    us-east-2        = "East US 2"
    can-central      = "Canada Central"
    can-east         = "Canada East"
    bra-south        = "Brasil South"
    uk-south         = "UK South"
    uk-west          = "UK West"
    eu-north         = "North Europe"
    eu-west          = "West Europe"
    fr-central       = "France Central"
    fr-south         = "France South"
    ger-north-east   = "Germany Northeast"
    ger-central      = "Germany Central"
    ger-west-central = "Germany West Central"
    swz-north        = "Switzerland North"
    swz-west         = "Switzerland West"
    norw-east        = "Norway East"
    norw-west        = "Norway West"
    saf-west         = "South Africa West"
    saf-north        = "South Africa North"
    ind-west         = "West India"
    ind-central      = "Central India"
    ind-south        = "South India"
    asia-south-east  = "Southeast Asia"
    asia-east        = "East Asia"
    ch-north         = "China North"
    ch-east          = "China East"
    kor-central      = "Korea Central"
    kor-south        = "Korea South"
    jap-east         = "Japan East"
    jap-west         = "Japan West"
    aus-central      = "Australia Central"
    aus-central-2    = "Australia Central 2"
    aus-east         = "Australia East"
    aus-south-east   = "Australia Southeast"
    uae-central      = "UAE Central" # United Arab Emirates
    uae-north        = "UAE North"   # United Arab Emirates
  }
  }

  variable "short_names" {
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
    "cn-east"          = "cne"
    "cn-north"         = "cnn"
    "cn-east-2"        = "cne2"
    "cn-north-2"       = "cnn2"
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

    ch-north         = "chn"
    ch-east          = "che"
    aus-south-east   = "ause"
  }
  } 