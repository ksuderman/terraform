locals {
    key = pathexpand("~/.ssh/${var.key_pair}.pem")
    ips = openstack_compute_floatingip_v2.floating_ips
    nodes = openstack_compute_instance_v2.nodes
}

# output "ip_addresses" {
#     count = var.num_nodes
#     value = "${openstack_compute_instance_v2.nodes[count.index].name} = ${openstack_compute_floatingip_v2.floating_ips[count.index].address}"
# } 

resource "local_file" "ipfile" {
    #count = var.num_nodes
    # for_each = var.flavors
    count = var.num_nodes
    content = templatefile("./templates/cluster.tpl", { ip=local.ips[count.index].address, key=local.key})
    filename = pathexpand("~/.cluster/${var.instance_name}${count.index}")
}

resource "local_file" "inventories" {
    #count = var.num_nodes
    content = templatefile("./templates/inventory.tpl", { ip=local.ips, key=local.key})
    filename = pathexpand("~/.inventories/${var.instance_name}.ini")
    #filename = "/tmp/bench${count.index+1}.ini"
}