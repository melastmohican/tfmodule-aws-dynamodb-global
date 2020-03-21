# tfmodule-aws-dynamodb-global
Reusable and configurable Terraform AWS DynamoDB module

# Prerequisites

### Install Terraform CLI

Terraform must first be installed on your machine. Terraform is distributed as a [binary package](https://www.terraform.io/downloads.html) for all supported platforms and architectures. 

https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_darwin_amd64.zip \
https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip \
https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_windows_amd64.zip

Install Terraform by unzipping it and moving it to a directory included in your system's PATH.

### How to use

**main.tf**

Module source can be instantiated multiple times, add as many times as many tables you need. 

```
module "dynamodb" {
  source      = "git::ssh://git@bitbucket.corporate.t-mobile.com/soc/pfm-tfmodule-dynamodb.git"
  environment = var.environment
  table_name  = "${upper(var.environment)}_ABC_TABLE"
  attribute_list = [
    {
      name = "ID"
      type = "S"
    },
    {
      name = "TYPE"
      type = "S"
    }
  ]

  hash_key  = "ID"
  range_key = "TYPE"
  
  tags = {
    Application = "Example"
    Environment = "Non-production"
    Owner       = "devops@example.org"
    Role        = "DataSource"

  }
  global_secondary_index_list = [
    {
      hash_key           = "TYPE"
      range_key          = "ID"
      name               = "TYPE-ID-index"
      non_key_attributes = []
      projection_type    = "ALL"
      read_capacity      = 0
      write_capacity     = 0
    }
  ]

  local_secondary_index_list = []

  ttl_list = []#

  providers = {
    aws.us-west-2 = aws.us-west-2
    aws.us-east-1 = aws.us-east-1
  }
}

```
**provider.tf**

You can use an AWS credentials file to specify your credentials. The default location is $HOME/.aws/credentials on Linux and OS X, or "%USERPROFILE%\.aws\credentials" for Windows users. 


```
provider "aws" {
  region                  = "us-west-2"
  alias                   = "us-west-2"
  shared_credentials_file = "$HOME/.aws/creds"
  profile                 = "default"
}

provider "aws" {
  region                  = "us-east-1"
  alias                   = "us-east-1"
  shared_credentials_file = "$HOME/.aws/creds"
  profile                 = "default"
}

```

**variables.tf**

```
variable "environment" {
    default = "dev"
}

```

### Terraform workflow
* terraform init
* terraform plan
```
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.dynamodb.aws_dynamodb_global_table.global_table will be created
  + resource "aws_dynamodb_global_table" "global_table" {
      + arn  = (known after apply)
      + id   = (known after apply)
      + name = "DEV_ABC_TABLE"

      + replica {
          + region_name = "us-east-1"
        }
      + replica {
          + region_name = "us-west-2"
        }
    }

  # module.dynamodb.aws_dynamodb_table.table_east will be created
  + resource "aws_dynamodb_table" "table_east" {
      + arn              = (known after apply)
      + billing_mode     = "PAY_PER_REQUEST"
      + hash_key         = "ID"
      + id               = (known after apply)
      + name             = "DEV_ABC_TABLE"
      + range_key        = "TYPE"
      + read_capacity    = 0
      + stream_arn       = (known after apply)
      + stream_enabled   = true
      + stream_label     = (known after apply)
      + stream_view_type = "NEW_AND_OLD_IMAGES"
      + tags             = {
          + "Application" = "Social"
          + "Environment" = "Non-production"
          + "Owner"       = "smpd_devops@t-mobile.com"
          + "Role"        = "DataSource"
          + "Stack"       = "Messaging"
        }
      + write_capacity   = 0

      + attribute {
          + name = "ID"
          + type = "S"
        }
      + attribute {
          + name = "TYPE"
          + type = "S"
        }

      + global_secondary_index {
          + hash_key           = "TYPE"
          + name               = "TYPE-ID-index"
          + non_key_attributes = []
          + projection_type    = "ALL"
          + range_key          = "ID"
          + read_capacity      = 0
          + write_capacity     = 0
        }

      + point_in_time_recovery {
          + enabled = false
        }

      + server_side_encryption {
          + enabled     = (known after apply)
          + kms_key_arn = (known after apply)
        }
    }

  # module.dynamodb.aws_dynamodb_table.table_west will be created
  + resource "aws_dynamodb_table" "table_west" {
      + arn              = (known after apply)
      + billing_mode     = "PAY_PER_REQUEST"
      + hash_key         = "ID"
      + id               = (known after apply)
      + name             = "DEV_ABC_TABLE"
      + range_key        = "TYPE"
      + read_capacity    = 0
      + stream_arn       = (known after apply)
      + stream_enabled   = true
      + stream_label     = (known after apply)
      + stream_view_type = "NEW_AND_OLD_IMAGES"
      + tags             = {
          + "Application" = "Social"
          + "Environment" = "Non-production"
          + "Owner"       = "smpd_devops@t-mobile.com"
          + "Role"        = "DataSource"
          + "Stack"       = "Messaging"
        }
      + write_capacity   = 0

      + attribute {
          + name = "ID"
          + type = "S"
        }
      + attribute {
          + name = "TYPE"
          + type = "S"
        }

      + global_secondary_index {
          + hash_key           = "TYPE"
          + name               = "TYPE-ID-index"
          + non_key_attributes = []
          + projection_type    = "ALL"
          + range_key          = "ID"
          + read_capacity      = 0
          + write_capacity     = 0
        }

      + point_in_time_recovery {
          + enabled = false
        }

      + server_side_encryption {
          + enabled     = (known after apply)
          + kms_key_arn = (known after apply)
        }
    }

Plan: 3 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.

```
* terraform apply
```
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.dynamodb.aws_dynamodb_global_table.global_table will be created
  + resource "aws_dynamodb_global_table" "global_table" {
      + arn  = (known after apply)
      + id   = (known after apply)
      + name = "DEV_ABC_TABLE"

      + replica {
          + region_name = "us-east-1"
        }
      + replica {
          + region_name = "us-west-2"
        }
    }

  # module.dynamodb.aws_dynamodb_table.table_east will be created
  + resource "aws_dynamodb_table" "table_east" {
      + arn              = (known after apply)
      + billing_mode     = "PAY_PER_REQUEST"
      + hash_key         = "ID"
      + id               = (known after apply)
      + name             = "DEV_ABC_TABLE"
      + range_key        = "TYPE"
      + read_capacity    = 0
      + stream_arn       = (known after apply)
      + stream_enabled   = true
      + stream_label     = (known after apply)
      + stream_view_type = "NEW_AND_OLD_IMAGES"
      + tags             = {
          + "Application" = "Social"
          + "Environment" = "Non-production"
          + "Owner"       = "smpd_devops@t-mobile.com"
          + "Role"        = "DataSource"
          + "Stack"       = "Messaging"
        }
      + write_capacity   = 0

      + attribute {
          + name = "ID"
          + type = "S"
        }
      + attribute {
          + name = "TYPE"
          + type = "S"
        }

      + global_secondary_index {
          + hash_key           = "TYPE"
          + name               = "TYPE-ID-index"
          + non_key_attributes = []
          + projection_type    = "ALL"
          + range_key          = "ID"
          + read_capacity      = 0
          + write_capacity     = 0
        }

      + point_in_time_recovery {
          + enabled = false
        }

      + server_side_encryption {
          + enabled     = (known after apply)
          + kms_key_arn = (known after apply)
        }
    }

  # module.dynamodb.aws_dynamodb_table.table_west will be created
  + resource "aws_dynamodb_table" "table_west" {
      + arn              = (known after apply)
      + billing_mode     = "PAY_PER_REQUEST"
      + hash_key         = "ID"
      + id               = (known after apply)
      + name             = "DEV_ABC_TABLE"
      + range_key        = "TYPE"
      + read_capacity    = 0
      + stream_arn       = (known after apply)
      + stream_enabled   = true
      + stream_label     = (known after apply)
      + stream_view_type = "NEW_AND_OLD_IMAGES"
      + tags             = {
          + "Application" = "Social"
          + "Environment" = "Non-production"
          + "Owner"       = "smpd_devops@t-mobile.com"
          + "Role"        = "DataSource"
          + "Stack"       = "Messaging"
        }
      + write_capacity   = 0

      + attribute {
          + name = "ID"
          + type = "S"
        }
      + attribute {
          + name = "TYPE"
          + type = "S"
        }

      + global_secondary_index {
          + hash_key           = "TYPE"
          + name               = "TYPE-ID-index"
          + non_key_attributes = []
          + projection_type    = "ALL"
          + range_key          = "ID"
          + read_capacity      = 0
          + write_capacity     = 0
        }

      + point_in_time_recovery {
          + enabled = false
        }

      + server_side_encryption {
          + enabled     = (known after apply)
          + kms_key_arn = (known after apply)
        }
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.dynamodb.aws_dynamodb_table.table_west: Creating...
module.dynamodb.aws_dynamodb_table.table_east: Creating...
module.dynamodb.aws_dynamodb_table.table_west: Still creating... [10s elapsed]
module.dynamodb.aws_dynamodb_table.table_east: Still creating... [10s elapsed]
module.dynamodb.aws_dynamodb_table.table_west: Creation complete after 17s [id=DEV_ABC_TABLE]
module.dynamodb.aws_dynamodb_table.table_east: Creation complete after 19s [id=DEV_ABC_TABLE]
module.dynamodb.aws_dynamodb_global_table.global_table: Creating...
module.dynamodb.aws_dynamodb_global_table.global_table: Still creating... [10s elapsed]
module.dynamodb.aws_dynamodb_global_table.global_table: Creation complete after 13s [id=DEV_ABC_TABLE]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

```
* terraform destroy
```
module.dynamodb.aws_dynamodb_table.table_west: Refreshing state... [id=DEV_ABC_TABLE]
module.dynamodb.aws_dynamodb_table.table_east: Refreshing state... [id=DEV_ABC_TABLE]
module.dynamodb.aws_dynamodb_global_table.global_table: Refreshing state... [id=DEV_ABC_TABLE]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # module.dynamodb.aws_dynamodb_global_table.global_table will be destroyed
  - resource "aws_dynamodb_global_table" "global_table" {
      - arn  = "arn:aws:dynamodb::***************:global-table/DEV_ABC_TABLE" -> null
      - id   = "DEV_ABC_TABLE" -> null
      - name = "DEV_ABC_TABLE" -> null

      - replica {
          - region_name = "us-east-1" -> null
        }
      - replica {
          - region_name = "us-west-2" -> null
        }
    }

  # module.dynamodb.aws_dynamodb_table.table_east will be destroyed
  - resource "aws_dynamodb_table" "table_east" {
      - arn              = "arn:aws:dynamodb:us-east-1:***************:table/DEV_ABC_TABLE" -> null
      - billing_mode     = "PAY_PER_REQUEST" -> null
      - hash_key         = "ID" -> null
      - id               = "DEV_ABC_TABLE" -> null
      - name             = "DEV_ABC_TABLE" -> null
      - range_key        = "TYPE" -> null
      - read_capacity    = 0 -> null
      - stream_arn       = "arn:aws:dynamodb:us-east-1:***************:table/DEV_ABC_TABLE/stream/2020-03-12T05:36:47.046" -> null
      - stream_enabled   = true -> null
      - stream_label     = "2020-03-12T05:36:47.046" -> null
      - stream_view_type = "NEW_AND_OLD_IMAGES" -> null
      - tags             = {
          - "Application" = "Social"
          - "Environment" = "Non-production"
          - "Owner"       = "smpd_devops@t-mobile.com"
          - "Role"        = "DataSource"
          - "Stack"       = "Messaging"
        } -> null
      - write_capacity   = 0 -> null

      - attribute {
          - name = "ID" -> null
          - type = "S" -> null
        }
      - attribute {
          - name = "TYPE" -> null
          - type = "S" -> null
        }

      - global_secondary_index {
          - hash_key           = "TYPE" -> null
          - name               = "TYPE-ID-index" -> null
          - non_key_attributes = [] -> null
          - projection_type    = "ALL" -> null
          - range_key          = "ID" -> null
          - read_capacity      = 0 -> null
          - write_capacity     = 0 -> null
        }

      - point_in_time_recovery {
          - enabled = false -> null
        }

      - ttl {
          - enabled = false -> null
        }
    }

  # module.dynamodb.aws_dynamodb_table.table_west will be destroyed
  - resource "aws_dynamodb_table" "table_west" {
      - arn              = "arn:aws:dynamodb:us-west-2:***************:table/DEV_ABC_TABLE" -> null
      - billing_mode     = "PAY_PER_REQUEST" -> null
      - hash_key         = "ID" -> null
      - id               = "DEV_ABC_TABLE" -> null
      - name             = "DEV_ABC_TABLE" -> null
      - range_key        = "TYPE" -> null
      - read_capacity    = 0 -> null
      - stream_arn       = "arn:aws:dynamodb:us-west-2:***************:table/DEV_ABC_TABLE/stream/2020-03-12T05:36:46.848" -> null
      - stream_enabled   = true -> null
      - stream_label     = "2020-03-12T05:36:46.848" -> null
      - stream_view_type = "NEW_AND_OLD_IMAGES" -> null
      - tags             = {
          - "Application" = "Social"
          - "Environment" = "Non-production"
          - "Owner"       = "smpd_devops@t-mobile.com"
          - "Role"        = "DataSource"
          - "Stack"       = "Messaging"
        } -> null
      - write_capacity   = 0 -> null

      - attribute {
          - name = "ID" -> null
          - type = "S" -> null
        }
      - attribute {
          - name = "TYPE" -> null
          - type = "S" -> null
        }

      - global_secondary_index {
          - hash_key           = "TYPE" -> null
          - name               = "TYPE-ID-index" -> null
          - non_key_attributes = [] -> null
          - projection_type    = "ALL" -> null
          - range_key          = "ID" -> null
          - read_capacity      = 0 -> null
          - write_capacity     = 0 -> null
        }

      - point_in_time_recovery {
          - enabled = false -> null
        }

      - ttl {
          - enabled = false -> null
        }
    }

Plan: 0 to add, 0 to change, 3 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

module.dynamodb.aws_dynamodb_global_table.global_table: Destroying... [id=DEV_ABC_TABLE]
module.dynamodb.aws_dynamodb_global_table.global_table: Still destroying... [id=DEV_ABC_TABLE, 10s elapsed]
module.dynamodb.aws_dynamodb_global_table.global_table: Destruction complete after 12s
module.dynamodb.aws_dynamodb_table.table_east: Destroying... [id=DEV_ABC_TABLE]
module.dynamodb.aws_dynamodb_table.table_west: Destroying... [id=DEV_ABC_TABLE]
module.dynamodb.aws_dynamodb_table.table_west: Still destroying... [id=DEV_ABC_TABLE, 10s elapsed]
module.dynamodb.aws_dynamodb_table.table_east: Still destroying... [id=DEV_ABC_TABLE, 10s elapsed]
module.dynamodb.aws_dynamodb_table.table_east: Still destroying... [id=DEV_ABC_TABLE, 20s elapsed]
module.dynamodb.aws_dynamodb_table.table_west: Still destroying... [id=DEV_ABC_TABLE, 20s elapsed]
module.dynamodb.aws_dynamodb_table.table_west: Destruction complete after 26s
module.dynamodb.aws_dynamodb_table.table_east: Destruction complete after 28s

Destroy complete! Resources: 3 destroyed.
```
