
variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
  default     = "demo"
}

variable "retention_in_days" {
  description = "Number of days you want to retain log events in the log group.(Optional) "
  default     = "30"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "ap-south-1"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.19"
  description = "Desired Kubernetes master version. If you do not specify a value, the latest available version is used"
}

variable "endpoint_private_access" {
  type        = bool
  default     = true
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default to AWS EKS resource and it is false"
}

variable "endpoint_public_access" {
  type        = bool
  default     = true
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default to AWS EKS resource and it is true"
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  description = "A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`]"
}

variable "cluster_service_ipv4_cidr" {
  description = "service ipv4 cidr for the kubernetes cluster"
  type        = string
  default     = null
}

variable "cluster_create_timeout" {
  description = "Timeout value when creating the EKS cluster."
  type        = string
  default     = "30m"
}

variable "cluster_delete_timeout" {
  description = "Timeout value when deleting the EKS cluster."
  type        = string
  default     = "15m"
}

###############linux node########

variable "linux_node_group_name" {
  description = "Name of the linux node group"
  type        = string
  default     = "DEMO"
}

variable "lt_id" {
  description = "lt_id of the eks linux node group"
  type        = string
  default     =  null
}

variable "lt_version" {
  description = "lt_version of the eks linux node group"
  type        = string
  default     =  null
} 

variable "ami_type" {
  type        = string
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to AL2_x86_64"
  default     = null
}

variable "capacity_type" {
  type        = string
  description = "Type of capacity associated with the EKS Node Group"
  default     = null
}

variable "disk_size" {
  type        = number
  description = "Disk size in GiB for worker nodes. Defaults to 20"
  default     = 30
}

variable "force_update_version" {
  type        = bool
  description = "Force version update if existing pods are unable to be drained"
  default     = false
}

variable "instance_types" {
  type        = list(any)
  description = "List of instance types associated with the EKS Node Group"
  default     = ["t3.medium"]
}

variable "release_version" {
  type        = string
  description = "AMI version of the EKS Node Group"
  default     = null
}

variable "desired_size" {
  description = "desired linux instance count"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "minimum linux instance count"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "maximum linux instance count"
  type        = number
  default     = 1
}

variable "lt_config" {
  type        = list(map(string))
  description = " Lauch template configuration . Eg: [{ id = `value` , name = `value` , version = `value` }]"
  default     = []
}

variable "ec2_ssh_key" {
  description = " ssh key for ec2"
  default     = null
}

variable "source_security_group_ids" {
  description = "source_security_group_ids for remote access"
  default     = []
}

#############Windows Nodes###########

variable "win_instance_type" {
  description = "Instance type for windows worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "win_desired_capacity" {
  description = "he number of Amazon EC2 instances that should be running in the group"
  type        = number
  default     = 1
}

variable "win_min_size" {
  description = "The minimum size of the windows node Auto Scaling Group"
  type        = number
  default     = 1
}

variable "win_max_size" {
  description = "The maximum size of the windows node Auto Scaling Group"
  type        = number
  default     = 2
}


variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
  default     = "eks_test-demo_shyam"
}

variable "lt_name" {
  description = "Name of the LT"
  type        = string
  default     = "DEMO"
}

variable "asg_name" {
  description = "The name of the ASG"
  type        = string
  default     = "DEMO"
}

variable "volume_size" {
  description = "Volume size for EBS root disk"
  type        = string
  default     = "60"
}

variable "kubelet_extra_args" {
  description = "This will make sure to taint your nodes at the boot time to avoid scheduling any existing resources in the new Windows worker nodes"
  type        = string
  default     = "--register-with-taints='os=windows:NoSchedule'"
}

locals {
    vpc_id     = "vpc-01d2fdd6864631258"
    subnet_ids = ["subnet-05ebf2aeaf885f631","subnet-0575e196b4465423f"]
    public_access_cidrs = ["0.0.0.0/0"]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
  ]
}