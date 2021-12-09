# variables that can be overriden
variable "hostname" { default = "k8s02" }
variable "domain" { default = "lan.kroy.io" }
variable "memory" { default = 8*1024 }
variable "disk_size" { default = "60G" }
variable "datastore" { default = "microntank" }
variable "cpus" { default = 2 }
variable "node" { default = "odo" }
variable "vlan" { default = "20" }
