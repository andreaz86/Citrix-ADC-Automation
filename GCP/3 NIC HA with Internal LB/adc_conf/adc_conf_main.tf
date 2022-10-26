resource "citrixadc_password_resetter" "primaryadc_resetpwd" {
    provider = citrixadc.adc01
    username = "nsroot"
    password = data.terraform_remote_state.adc.outputs.adc01_instance_id
    new_password = var.password
}

resource "citrixadc_password_resetter" "secondaryadc_resetpwd" {
    provider = citrixadc.adc02
    username = "nsroot"
    password = data.terraform_remote_state.adc.outputs.adc02_instance_id
    new_password = var.password
}

resource "citrixadc_nshostname" "hostname_primary" {
    provider = citrixadc.adc01
    hostname = "adc01"
}

resource "citrixadc_nshostname" "hostname_secondary" {
    provider = citrixadc.adc02
    hostname = "adc02"
}

## HA

# resource "citrixadc_hanode" "local_node" {
#     provider = citrixadc.adc01
#     hanode_id     = 0       //the id of local_node is always 0
#     hellointerval = 400
#     deadinterval = 30
# }

# resource "citrixadc_hanode" "remote_node" {
#     provider = citrixadc.adc01
#     hanode_id = 1
#     ipaddress = data.terraform_remote_state.adc.outputs.adc02_nsip
#     inc = "ENABLED"
# }

# resource "citrixadc_hanode" "test_local_node" {
#     provider = citrixadc.adc02
#     hanode_id     = 0       //the id of local_node is always 0
#     hellointerval = 400
#     deadinterval = 30
  
# }

# resource "citrixadc_hanode" "test_remote_node" {
#     provider = citrixadc.adc02
#     hanode_id = 1
#     ipaddress = data.terraform_remote_state.adc.outputs.adc01_nsip
#     inc = "ENABLED"
# }

# END HA

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

resource "citrixadc_appflowcollector" "tf_appflowcollector" {
  provider = citrixadc.adc02
  name      = "tf_collector"
  ipaddress = "192.168.1.6"
  transport = "ipfix"
  port      =  2055
}

resource "citrixadc_appflowaction" "tf_appflowaction" {
  provider = citrixadc.adc02
  name = "test_action"
  collectors = [citrixadc_appflowcollector.tf_appflowcollector.name]
  webinsight = "ENABLED"

}

resource "citrixadc_appflowpolicy" "tf_appflowpolicy" {
  provider = citrixadc.adc02
  name   = "test_policy"
  action = citrixadc_appflowaction.tf_appflowaction.name
  rule   = "true"
}

resource "citrixadc_appflowglobal_appflowpolicy_binding" "tf_appflowglobal_appflowpolicy_binding" {
  provider = citrixadc.adc02
  policyname     = citrixadc_appflowpolicy.tf_appflowpolicy.name
  globalbindtype = "SYSTEM_GLOBAL"
  type           = "REQ_OVERRIDE"
  priority       = 55
}

resource "citrixadc_appflowparam" "tf_appflowparam" {
  provider = citrixadc.adc02
  templaterefresh     = 60
  flowrecordinterval  = 60
  httpcookie          = "ENABLED"
  httplocation        = "ENABLED"
  httpcontenttype = "ENABLED"
  httpdomain = "ENABLED"
  httphost = "ENABLED"
  httpmethod = "ENABLED"
  httpquerywithurl = "ENABLED"
  httpreferer = "ENABLED"
  httpsetcookie = "ENABLED"
  httpsetcookie2 = "ENABLED"
  httpurl = "ENABLED"
  httpuseragent = "ENABLED"
  httpvia = "ENABLED"
  httpxforwardedfor = "ENABLED"
  identifiername = "ENABLED"
  identifiersessionname = "ENABLED"
  connectionchaining = "ENABLED"
}