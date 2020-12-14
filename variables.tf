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

variable "geographies" {
  default = {
    eu = {
      name = "Europe"
      regions = {
        eu-west  = { name = "West Europe", shortname = "euw", tag = "" }
        eu-north = { name = "North Europe", shortname = "eun", tag = "v1" }
      }
    }
    # uk = {
    #   name = "United Kingdom"
    #   regions = {
    #     uk-south = { name = "UK South", shortname = "uks", tag = "" }
    #     uk-west  = { name = "UK West", shortname = "ukw", tag = "" }
    #   }
    # }
    # us = {
    #   name = "United States"
    #   regions = {
    #     us-west          = { name = "West US", shortname = "uw", tag = "" }
    #     us-west-2        = { name = "West US 2", shortname = "uw2", tag = "" }
    #     us-central       = { name = "Central US", shortname = "uc", tag = "" }
    #     us-west-central  = { name = "West Central US", shortname = "uwc", tag = "" }
    #     us-south-central = { name = "South Central US", shortname = "usc", tag = "" }
    #     us-north-central = { name = "North Central US", shortname = "unc", tag = "" }
    #     us-east          = { name = "East US", shortname = "ue", tag = "" }
    #     us-east-2        = { name = "East US 2", shortname = "ue2", tag = "" }
    #   }
    # }
    # can = {
    #   name = "Canada"
    #   regions = {
    #     can-central = { name = "Canada Central", shortname = "cac", tag = "" }
    #     can-east    = { name = "Canada East", shortname = "cae", tag = "" }
    #   }
    # }
    # bra = {
    #   name = "Brazil"
    #   regions = {
    #     bra-south = { name = "Brazil South", shortname = "brs", tag = "" }
    #     #bra-south-east   = { name = "Brazil Southeast", shortname = "brse", tag = "" }
    #   }
    # }
    # fr = {
    #   name = "France"
    #   regions = {
    #     fr-central = { name = "France Central", shortname = "frc", tag = "" }
    #     #fr-south         = { name = "France South", shortname = "frs", tag = "" }
    #   }
    # }
    # ger = {
    #   name = "Germany"
    #   regions = {
    #     ger-west-central = { name = "Germany West Central", shortname = "gwc", tag = "" }
    #     #ger-north-east   = { name = "Germany Northeast", shortname = "gne", tag = "" }
    #     #ger-central      = { name = "Germany Central", shortname = "gce", tag = "" }
    #   }
    # }
    # swz = {
    #   name = "Switzerland"
    #   regions = {
    #     swz-north = { name = "Switzerland North", shortname = "swn", tag = "" }
    #     #swz-west         = { name = "Switzerland West", shortname = "sww", tag = "" }
    #   }
    # }
    # norw = {
    #   name = "Norway"
    #   regions = {
    #     norw-east = { name = "Norway East", shortname = "noe", tag = "" }
    #     #norw-west        = { name = "Norway West", shortname = "now", tag = "" }
    #   }
    # }
    # saf = {
    #   name = "South Africa"
    #   regions = {
    #     saf-north = { name = "South Africa North", shortname = "san", tag = "" }
    #     #saf-west         = { name = "South Africa West", shortname = "saw", tag = "" }
    #   }
    # }
    # ind = {
    #   name = "India"
    #   regions = {
    #     ind-west    = { name = "West India", shortname = "inw", tag = "" }
    #     ind-central = { name = "Central India", shortname = "inc", tag = "" }
    #     ind-south   = { name = "South India", shortname = "ins", tag = "" }
    #   }
    # }
    # asia = {
    #   name = "Asia"
    #   regions = {
    #     asia-south-east = { name = "Southeast Asia", shortname = "ase", tag = "" }
    #     asia-east       = { name = "East Asia", shortname = "ae", tag = "" }
    #   }
    # }
    # kor = {
    #   name = "Korea"
    #   regions = {
    #     kor-central = { name = "Korea Central", shortname = "krc", tag = "" }
    #     kor-south   = { name = "Korea South", shortname = "krs", tag = "" }
    #   }
    # }
    # jap = {
    #   name = "Japan"
    #   regions = {
    #     jap-east = { name = "Japan East", shortname = "jpe", tag = "" }
    #     jap-west = { name = "Japan West", shortname = "jpw", tag = "" }
    #   }
    # }
    # aus = {
    #   name = "Australia"
    #   regions = {
    #     aus-central    = { name = "Australia Central", shortname = "auc", tag = "" }
    #     aus-east       = { name = "Australia East", shortname = "aue", tag = "" }
    #     aus-south-east = { name = "Australia Southeast", shortname = "ause", tag = "" }
    #     #aus-central-2    = { name = "Australia Central 2", shortname = "auc2", tag = "" }
    #   }
    # }
    # uae = {
    #   name = "UAE"
    #   regions = {
    #     uae-north = { name = "UAE North", shortname = "uaen", tag = "" }
    #     #uae-central      = { name = "UAE Central" , shortname = "uaec", tag = "" }
    #   }
    # }
    # #     ch = {
    # #   name = "China"
    # #   regions = {
    # #     ch-north         = { name = "China North", shortname = "chn", tag = "" }
    # #     ch-east          = { name = "China East", shortname = "che", tag = "" }
    # #     ch-north-2       = { name = "China North 2", shortname = "chn2", tag = "" }
    # #     ch-east-2        = { name = "China East 2", shortname = "che2", tag = "" }
    # #   }
    # # }

  }

}
