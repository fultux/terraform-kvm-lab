variable url_sles {
  type = string
  description = "Location of the qcow image for SLES"
}

variable url_opensuse {
  type = string
  description = "Location of the qcow image for OpenSUSE"
}

variable url_debian {
  type = string
  description = "Location of the qcow image for Debian"
 }

variable url_ubuntu {
  type = string
  description = "Location of the qcow image for Ubuntu"
}

variable url_alma {
  type = string
  description = "Location of the qcow image for Alma Linux"
}

variable url_rocky {
  type = string
  description = "Location of the qcow image for Rocky"
}


variable ssh_key {
  type        = string
  description = "SSH key to add to the cloud-init for user access"
}

variable ssh_user {
  type        = string
  description = "SSH key to add to the cloud-init for user access"
}

variable "ssh_key_file" {
    type = string
    description = "ssh key"
    default = "~/.ssh/id_rsa"
}


variable sles_count {
  type        = number
  default = 1
  description = "Number of SLES vm"
}

variable sles_node_memory {
  type        = string
  description = "The amount of RAM for each SLES vm"
}

variable sles_node_vcpu {
  type        = number
  description = "Number of vcpu for the SLES vm"
}


variable scc_activation_key {
  type 	= string
  description = "SUSE Customer activation key for SLES"
}


variable opensuse_count {
  type        = number
  default = 1
  description = "Number of OpenSUSE vm"
}

variable opensuse_node_memory {
  type        = string
  description = "The amount of RAM for each OpenSUSE vm"
}

variable opensuse_node_vcpu {
  type        = number
  description = "Number of vcpu for the OpenSUSE vm"
}



variable debian_count {
  type        = number
  default = 1
  description = "Number of debian vm"
}

variable debian_node_memory {
  type        = string
  description = "The amount of RAM for each debian vm"
}

variable debian_node_vcpu {
  type        = number
  description = "Number of vcpu for the debian vm"
}

variable ubuntu_count {
  type        = number
  default = 1
  description = "Number of ubuntu vm"
}

variable ubuntu_node_memory {
  type        = string
  description = "The amount of RAM for each ubuntu vm"
}

variable ubuntu_node_vcpu {
  type        = number
  description = "Number of vcpu for the ubuntu vm"
}



variable alma_count {
  type        = number
  default = 1
  description = "Number of debian vm"
}

variable alma_node_memory {
  type        = string
  description = "The amount of RAM for each debian vm"
}

variable alma_node_vcpu {
  type        = number
  description = "Number of vcpu for the debian vm"
}



variable rocky_count {
  type        = number
  default = 1
  description = "Number of debian vm"
}

variable rocky_node_memory {
  type        = string
  description = "The amount of RAM for each debian vm"
}

variable rocky_node_vcpu {
  type        = number
  description = "Number of vcpu for the debian vm"
}




variable network_name {
  type        = string
  description = "Name of the vm network"
}




variable disk_size {
  type = number
  description = "Disk size in Gigabytes"
}


variable storage_pool {
  type = string
  description = "Name of the Storage pool to use"
  default = "default"
}



