output "sles_ips" {
  value = flatten(libvirt_domain.sles.*.network_interface.0.addresses)
}

output "opensuse_ips" {
  value = flatten(libvirt_domain.opensuse.*.network_interface.0.addresses)
}


output "debian_ips" {
  value = flatten(libvirt_domain.debian.*.network_interface.0.addresses)
}


output "ubuntu_ips" {
  value = flatten(libvirt_domain.ubuntu.*.network_interface.0.addresses)
}

output "alma_ips" {
  value = flatten(libvirt_domain.alma.*.network_interface.0.addresses)
}


