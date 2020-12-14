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
        eu-west  = { name = "West Europe", shortname = "euw", }
        eu-north = { name = "North Europe", shortname = "eun", tag = "v1" }
      }
    }
    # uk = {
    #   name = "United Kingdom"
    #   regions = {
    #     uk-south = { name = "UK South", shortname = "uks" }
    #     uk-west  = { name = "UK West", shortname = "ukw" }
    #   }
    # }
    # us = {
    #   name = "United States"
    #   regions = {
    #     us-west          = { name = "West US", shortname = "uw" }
    #     us-west-2        = { name = "West US 2", shortname = "uw2" }
    #     us-central       = { name = "Central US", shortname = "uc" }
    #     us-west-central  = { name = "West Central US", shortname = "uwc" }
    #     us-south-central = { name = "South Central US", shortname = "usc" }
    #     us-north-central = { name = "North Central US", shortname = "unc" }
    #     us-east          = { name = "East US", shortname = "ue" }
    #     us-east-2        = { name = "East US 2", shortname = "ue2" }
    #   }
    # }
    # can = {
    #   name = "Canada"
    #   regions = {
    #     can-central = { name = "Canada Central", shortname = "cac" }
    #     can-east    = { name = "Canada East", shortname = "cae" }
    #   }
    # }
    # bra = {
    #   name = "Brazil"
    #   regions = {
    #     bra-south = { name = "Brazil South", shortname = "brs" }
    #     #bra-south-east   = { name = "Brazil Southeast", shortname = "brse" }
    #   }
    # }
    # fr = {
    #   name = "France"
    #   regions = {
    #     fr-central = { name = "France Central", shortname = "frc" }
    #     #fr-south         = { name = "France South", shortname = "frs" }
    #   }
    # }
    # ger = {
    #   name = "Germany"
    #   regions = {
    #     ger-west-central = { name = "Germany West Central", shortname = "gwc" }
    #     #ger-north-east   = { name = "Germany Northeast", shortname = "gne" }
    #     #ger-central      = { name = "Germany Central", shortname = "gce" }
    #   }
    # }
    # swz = {
    #   name = "Switzerland"
    #   regions = {
    #     swz-north = { name = "Switzerland North", shortname = "swn" }
    #     #swz-west         = { name = "Switzerland West", shortname = "sww" }
    #   }
    # }
    # norw = {
    #   name = "Norway"
    #   regions = {
    #     norw-east = { name = "Norway East", shortname = "noe" }
    #     #norw-west        = { name = "Norway West", shortname = "now" }
    #   }
    # }
    # saf = {
    #   name = "South Africa"
    #   regions = {
    #     saf-north = { name = "South Africa North", shortname = "san" }
    #     #saf-west         = { name = "South Africa West", shortname = "saw" }
    #   }
    # }
    # ind = {
    #   name = "India"
    #   regions = {
    #     ind-west    = { name = "West India", shortname = "inw" }
    #     ind-central = { name = "Central India", shortname = "inc" }
    #     ind-south   = { name = "South India", shortname = "ins" }
    #   }
    # }
    # asia = {
    #   name = "Asia"
    #   regions = {
    #     asia-south-east = { name = "Southeast Asia", shortname = "ase" }
    #     asia-east       = { name = "East Asia", shortname = "ae" }
    #   }
    # }
    # kor = {
    #   name = "Korea"
    #   regions = {
    #     kor-central = { name = "Korea Central", shortname = "krc" }
    #     kor-south   = { name = "Korea South", shortname = "krs" }
    #   }
    # }
    # jap = {
    #   name = "Japan"
    #   regions = {
    #     jap-east = { name = "Japan East", shortname = "jpe" }
    #     jap-west = { name = "Japan West", shortname = "jpw" }
    #   }
    # }
    # aus = {
    #   name = "Australia"
    #   regions = {
    #     aus-central    = { name = "Australia Central", shortname = "auc" }
    #     aus-east       = { name = "Australia East", shortname = "aue" }
    #     aus-south-east = { name = "Australia Southeast", shortname = "ause" }
    #     #aus-central-2    = { name = "Australia Central 2", shortname = "auc2" }
    #   }
    # }
    # uae = {
    #   name = "UAE"
    #   regions = {
    #     uae-north = { name = "UAE North", shortname = "uaen" }
    #     #uae-central      = { name = "UAE Central" , shortname = "uaec" }
    #   }
    # }
    # #     ch = {
    # #   name = "China"
    # #   regions = {
    # #     ch-north         = { name = "China North", shortname = "chn" }
    # #     ch-east          = { name = "China East", shortname = "che" }
    # #     ch-north-2       = { name = "China North 2", shortname = "chn2" }
    # #     ch-east-2        = { name = "China East 2", shortname = "che2" }
    # #   }
    # # }

  }

}
