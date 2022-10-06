# resource "citrixadc_password_resetter" "primaryadc_resetpwd" {
#     provider = citrixadc.adc01
#     username = "nsroot"
#     password = data.terraform_remote_state.adc.outputs.adc01_instance_id
#     new_password = var.password
# }

# resource "citrixadc_password_resetter" "secondaryadc_resetpwd" {
#     provider = citrixadc.adc02
#     username = "nsroot"
#     password = data.terraform_remote_state.adc.outputs.adc02_instance_id
#     new_password = var.password
# }

resource "citrixadc_nshostname" "hostname_primary" {
    provider = citrixadc.adc01
    hostname = "adc01"
}

resource "citrixadc_nshostname" "hostname_secondary" {
    provider = citrixadc.adc02
    hostname = "adc02"
}

resource "citrixadc_hanode" "local_node" {
    provider = citrixadc.adc01
    hanode_id     = 0       //the id of local_node is always 0
    hellointerval = 400
    deadinterval = 30
}

resource "citrixadc_hanode" "remote_node" {
    provider = citrixadc.adc01
    hanode_id = 1
    ipaddress = data.terraform_remote_state.adc.outputs.adc02_nsip
    inc = "ENABLED"
}

resource "citrixadc_hanode" "test_local_node" {
    provider = citrixadc.adc02
    hanode_id     = 0       //the id of local_node is always 0
    hellointerval = 400
    deadinterval = 30
  
}
###########################################
resource "citrixadc_hanode" "test_remote_node" {
    provider = citrixadc.adc02
    hanode_id = 1
    ipaddress = data.terraform_remote_state.adc.outputs.adc01_nsip
    inc = "ENABLED"
}

# resource "citrixadc_service" "tf_service" {
#   provider = citrixadc.adc02
#   name = "tf_service"
#   ip = data.terraform_remote_state.adc.outputs.backend_ip
#   servicetype  = "HTTP"
#   port = 80
# }


resource "citrixadc_servicegroup" "tf_servicegroup" {
  provider = citrixadc.adc02
  servicegroupname = "tf_servicegroup"
  servicetype = "HTTP"
  #for_each = data.terraform_remote_state.adc.outputs.backend_ip
  servicegroupmembers = ["${data.terraform_remote_state.adc.outputs.backend_ip.backend01}:80","${data.terraform_remote_state.adc.outputs.backend_ip.backend02}:80"]
  #lbvservers = [ citrixadc_lbvserver.tf_lbvserver1.name, citrixadc_lbvserver.tf_lbvserver2.name ]
}

resource "citrixadc_lbvserver" "tf_lbvserver" {
  provider = citrixadc.adc02
  ipv46       = data.terraform_remote_state.adc.outputs.vip_ip
  name        = "tf_lbvserver"
  port        = 80
  servicetype = "HTTP"
#   servicename = citrixadc_service.tf_service.name
#   weight = 1
  persistencetype = "SOURCEIP"
  timeout = 2
  lbmethod = "ROUNDROBIN"
}


resource "citrixadc_lbvserver_servicegroup_binding" "tf_binding" {
  provider = citrixadc.adc02
  name = citrixadc_lbvserver.tf_lbvserver.name
  servicegroupname = citrixadc_servicegroup.tf_servicegroup.servicegroupname
}

# resource "citrixadc_lbvserver_service_binding" "tf_binding" {
#   provider = citrixadc.adc02
#   name = citrixadc_lbvserver.tf_lbvserver.name
#   servicename = citrixadc_service.tf_service.name
#   weight = 1
# }