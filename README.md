# terraform-aws-eks-windows
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| kubernetes | n/a |
| null | n/a |
| template | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_autoscaling_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) |
| [aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) |
| [aws_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) |
| [aws_eks_cluster_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) |
| [aws_eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) |
| [aws_iam_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) |
| [aws_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |
| [aws_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) |
| [aws_ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) |
| [kubernetes_config_map](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [template_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami\_type | Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to AL2\_x86\_64 | `string` | `null` | no |
| asg\_name | The name of the ASG | `string` | `"DEMO"` | no |
| capacity\_type | Type of capacity associated with the EKS Node Group | `string` | `null` | no |
| cluster\_create\_timeout | Timeout value when creating the EKS cluster. | `string` | `"30m"` | no |
| cluster\_delete\_timeout | Timeout value when deleting the EKS cluster. | `string` | `"15m"` | no |
| cluster\_name | Name of the EKS cluster. | `string` | `"demo"` | no |
| cluster\_service\_ipv4\_cidr | service ipv4 cidr for the kubernetes cluster | `string` | `null` | no |
| desired\_size | desired linux instance count | `number` | `1` | no |
| disk\_size | Disk size in GiB for worker nodes. Defaults to 20 | `number` | `30` | no |
| ec2\_ssh\_key | ssh key for ec2 | `any` | `null` | no |
| enabled\_cluster\_log\_types | A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`] | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| endpoint\_private\_access | Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default to AWS EKS resource and it is false | `bool` | `true` | no |
| endpoint\_public\_access | Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default to AWS EKS resource and it is true | `bool` | `true` | no |
| force\_update\_version | Force version update if existing pods are unable to be drained | `bool` | `false` | no |
| instance\_types | List of instance types associated with the EKS Node Group | `list(any)` | <pre>[<br>  "t3.medium"<br>]</pre> | no |
| key\_name | The key name to use for the instance | `string` | `"demo"` | no |
| kubelet\_extra\_args | This will make sure to taint your nodes at the boot time to avoid scheduling any existing resources in the new Windows worker nodes | `string` | `"--register-with-taints='os=windows:NoSchedule'"` | no |
| kubernetes\_version | Desired Kubernetes master version. If you do not specify a value, the latest available version is used | `string` | `"1.19"` | no |
| linux\_node\_group\_name | Name of the linux node group | `string` | `"DEMO"` | no |
| lt\_config | Lauch template configuration . Eg: [{ id = `value` , name = `value` , version = `value` }] | `list(map(string))` | `[]` | no |
| lt\_id | lt\_id of the eks linux node group | `string` | `null` | no |
| lt\_name | Name of the LT | `string` | `"DEMO"` | no |
| lt\_version | lt\_version of the eks linux node group | `string` | `null` | no |
| map\_users | Additional IAM users to add to the aws-auth configmap. | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "groups": [<br>      "system:masters"<br>    ],<br>    "userarn": "arn:aws:iam::66666666666:user/user1",<br>    "username": "user1"<br>  }<br>]</pre> | no |
| max\_size | minimum linux instance count | `number` | `2` | no |
| min\_size | maximum linux instance count | `number` | `1` | no |
| region | AWS Region | `string` | `"ap-south-1"` | no |
| release\_version | AMI version of the EKS Node Group | `string` | `null` | no |
| retention\_in\_days | Number of days you want to retain log events in the log group.(Optional) | `string` | `"30"` | no |
| source\_security\_group\_ids | source\_security\_group\_ids for remote access | `list` | `[]` | no |
| volume\_size | Volume size for EBS root disk | `string` | `"60"` | no |
| win\_desired\_capacity | he number of Amazon EC2 instances that should be running in the group | `number` | `1` | no |
| win\_instance\_type | Instance type for windows worker nodes | `string` | `"t3.medium"` | no |
| win\_max\_size | The maximum size of the windows node Auto Scaling Group | `number` | `2` | no |
| win\_min\_size | The minimum size of the windows node Auto Scaling Group | `number` | `1` | no |
