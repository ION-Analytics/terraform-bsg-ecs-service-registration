terraform {
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "2.15.0"
      configuration_aliases = [
        consul.bsg_consul
      ]
    }
     aws = {
        source = "hashicorp/aws"
        configuration_aliases = [
            aws.dns,
            aws.cluster_provider
        ]
      }
  }
}

