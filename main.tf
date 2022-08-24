resource "libvirt_volume" "os_image_sles" {
  name   = "os_image_sles"
  source = "./images/SLES15-SP1-JeOS.x86_64-15.1-OpenStack-Cloud-GM.qcow2"
}

resource "libvirt_volume" "os_image_opensuse" {
  name   = "os_image_opensuse"
  source = "https://download.opensuse.org/repositories/Cloud:/Images:/Leap_15.2/images/openSUSE-Leap-15.2.x86_64-1.0.1-NoCloud-Build5.118.qcow2"
}


resource "libvirt_volume" "os_image_debian" {
  name   = "os_image_debian"
  source = "https://cloud.debian.org/images/cloud/buster/20190909-10/debian-10-generic-amd64-20190909-10.qcow2"
}


resource "libvirt_volume" "os_image_ubuntu" {
  name   = "os_image_ubuntu"
  source = "http://cloud-images-archive.ubuntu.com/releases/focal/release-20200423/ubuntu-20.04-server-cloudimg-amd64.img"
}


resource "libvirt_volume" "os_image_alma" {
  name   = "os_image_alma"
  source = "https://repo.almalinux.org/almalinux/8.6/cloud/x86_64/images/AlmaLinux-8-GenericCloud-8.6-20220513.x86_64.qcow2"
}



resource "libvirt_volume" "volume_sles" {
  count  =  var.sles_count
  name   = "volume-sles${count.index}"
  pool   = "default"
  base_volume_id = libvirt_volume.os_image_sles.id
  size = var.disk_size * 1024 * 1024 * 1024 
}



resource "libvirt_volume" "volume_opensuse" {
  count  =  var.opensuse_count
  name   = "volume-opensuse${count.index}"
  pool   = "default"
  base_volume_id = libvirt_volume.os_image_opensuse.id
  size = var.disk_size * 1024 * 1024 * 1024
}

resource "libvirt_volume" "volume_debian" {
  count  =  var.debian_count
  name   = "volume-debian${count.index}"
  pool   = "default"
  base_volume_id = libvirt_volume.os_image_debian.id
  size = var.disk_size * 1024 * 1024 * 1024

}


resource "libvirt_volume" "volume_ubuntu" {
  count  =  var.ubuntu_count
  name   = "volume-ubuntu${count.index}"
  pool   = "default"
  base_volume_id = libvirt_volume.os_image_ubuntu.id
  size = var.disk_size * 1024 * 1024 * 1024
}


resource "libvirt_volume" "volume_alma" {
  count  =  var.alma_count
  name   = "volume-alma${count.index}"
  pool   = "default"
  base_volume_id = libvirt_volume.os_image_alma.id
}


data "template_file" "sles_user_data" {
  count = var.sles_count
  template = file("${path.module}/templates/cloud_init_sles.cfg")
     vars = {
    ssh_user = var.ssh_user
    ssh_key = var.ssh_key
    scc_activation_key = var.scc_activation_key
    node_hostname = "sles-${count.index}"
  }
}



data "template_file" "opensuse_user_data" {
  count = var.opensuse_count
  template = file("${path.module}/templates/cloud_init.cfg")
     vars = {
    ssh_user = var.ssh_user
    ssh_key = var.ssh_key
    node_hostname = "opensuse-${count.index}"
  }
}


data "template_file" "debian_user_data" {
  count = var.debian_count
  template = file("${path.module}/templates/cloud_init.cfg")
     vars = {
    ssh_user = var.ssh_user
    ssh_key = var.ssh_key
    node_hostname = "debian-${count.index}"
  }
}

data "template_file" "ubuntu_user_data" {
  count = var.ubuntu_count
  template = file("${path.module}/templates/cloud_init.cfg")
     vars = {
    ssh_user = var.ssh_user
    ssh_key = var.ssh_key
    node_hostname = "ubuntu-${count.index}"
  }
}


data "template_file" "alma_user_data" {
  count = var.alma_count
  template = file("${path.module}/templates/cloud_init.cfg")
     vars = {
    ssh_user = var.ssh_user
    ssh_key = var.ssh_key
    node_hostname = "alma-${count.index}"
  }
}



data "template_file" "network_config" {
  template = file("${path.module}/templates/network_config.cfg")
}

data "template_file" "ubuntu_network_config" {
  template = file("${path.module}/templates/ubuntu_network_config.cfg")
}


resource "libvirt_cloudinit_disk" "sles" {
  count = var.sles_count
  name  = "cloudinit-sles-${count.index}.iso"
  user_data      = data.template_file.sles_user_data[count.index].rendered
  network_config = data.template_file.network_config.rendered
}



resource "libvirt_cloudinit_disk" "opensuse" {
  count = var.opensuse_count
  name  = "cloudinit-opensuse-${count.index}.iso"
  user_data      = data.template_file.opensuse_user_data[count.index].rendered
  network_config = data.template_file.network_config.rendered
}


resource "libvirt_cloudinit_disk" "debian" {
  count = var.debian_count
  name  = "cloudinit-debian-${count.index}.iso"
  user_data      = data.template_file.debian_user_data[count.index].rendered
  network_config = data.template_file.network_config.rendered
}


resource "libvirt_cloudinit_disk" "ubuntu" {
  count = var.ubuntu_count
  name  = "cloudinit-ubuntu-${count.index}.iso"
  user_data      = data.template_file.ubuntu_user_data[count.index].rendered
  network_config = data.template_file.ubuntu_network_config.rendered
}


resource "libvirt_cloudinit_disk" "alma" {
  count = var.alma_count
  name  = "cloudinit-alma-${count.index}.iso"
  user_data      = data.template_file.alma_user_data[count.index].rendered
  network_config = data.template_file.network_config.rendered
}



# Create sles vms
resource "libvirt_domain" "sles" {
  count =  var.sles_count
  name = "sles-${count.index}"
  disk {
    volume_id = libvirt_volume.volume_sles[count.index].id
  }
  memory = var.sles_node_memory
  vcpu   = var.sles_node_vcpu

  cloudinit = libvirt_cloudinit_disk.sles[count.index].id

  network_interface {
    network_name = var.network_name
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "local-exec" {
    command = "sleep 60"
    interpreter = ["/bin/bash", "-c"]
  }

}


# Create opensuse vms
resource "libvirt_domain" "opensuse" {
  count =  var.opensuse_count
  name = "opensuse-${count.index}"
  disk {
    volume_id = libvirt_volume.volume_opensuse[count.index].id
  }
  memory = var.opensuse_node_memory
  vcpu   = var.opensuse_node_vcpu

  cloudinit = libvirt_cloudinit_disk.opensuse[count.index].id

  network_interface {
    network_name = var.network_name
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "local-exec" {
    command = "sleep 60"
    interpreter = ["/bin/bash", "-c"]
  }

}




resource "libvirt_domain" "debian" { 
  count =  var.debian_count
  name = "debian-${count.index}"
  disk {
    volume_id = libvirt_volume.volume_debian[count.index].id
  }
  memory = var.debian_node_memory
  vcpu   = var.debian_node_vcpu

  cloudinit = libvirt_cloudinit_disk.debian[count.index].id

  network_interface {
    network_name = var.network_name
    wait_for_lease = true 
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "local-exec" {
    command = "sleep 60"
    interpreter = ["/bin/bash", "-c"]
  }

}



# Create ubuntu vms
resource "libvirt_domain" "ubuntu" { 
  count =  var.ubuntu_count
  name = "ubuntu-${count.index}"
  disk {
    volume_id = libvirt_volume.volume_ubuntu[count.index].id
  }
  memory = var.ubuntu_node_memory
  vcpu   = var.ubuntu_node_vcpu

  cloudinit = libvirt_cloudinit_disk.ubuntu[count.index].id

  network_interface {
    network_name = var.network_name
    wait_for_lease = true 
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "local-exec" {
    command = "sleep 60"
    interpreter = ["/bin/bash", "-c"]
  }

}


# Create alma vms
resource "libvirt_domain" "alma" {
  count =  var.alma_count
  name = "alma-${count.index}"
  disk {
    volume_id = libvirt_volume.volume_alma[count.index].id
  }
  memory = var.alma_node_memory
  vcpu   = var.alma_node_vcpu

  cloudinit = libvirt_cloudinit_disk.alma[count.index].id

  network_interface {
    network_name = var.network_name
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "local-exec" {
    command = "sleep 60"
    interpreter = ["/bin/bash", "-c"]
  }

}



