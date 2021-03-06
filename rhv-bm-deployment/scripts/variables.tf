variable "rhv-base-image" {
    type = "string"
    description = "image familt"
    default = "centos-cloud/centos-7"
}


variable "rhv-engine-name" {
    type = "string"
    description = "rhv engine VM instance name"
    default = "ocp-rhv-vm-engine"
}

variable "rhv_host_count" {
    type = number
    description = "Number of host instances to launch"
    default = 2
}

variable "rhv-engine-vcpu" {
    type = number
    description = "virtual cpu count"
    default = 4
}

variable "rhv-engine-memory" {
    type = number
    description = "memory in mega"
    default = 8192
}

variable "rhv-engine-disk-size" {
    type = number
    description = "rhev disk size in Giga"
    default = "40"
}

variable "rhv-host-vcpu" {
    type = number
    description = "virtual cpu count"
    default = 12
}

variable "rhv-host-memory" {
    type = number
    description = "memory in mega"
    default = 51200
}

variable "rhv-host-disk-size" {
    type = number
    description = "rhev disk size in Giga"
    default = 40

}
variable "rhv-host-name" {
    type = "string"
    description = "rhv first host VM instance name"
    default = "ocp-rhv-nested-vm-host"
}

variable "gce-ssh-user" {
    type = "string"
    description = "ssh username"
    default = "centos"
}


variable "gce-ssh-pub-key-file" {
    type = "string"
    description = "ssh public key file"
    default = "~/.ssh/id_rsa.pub"
}
