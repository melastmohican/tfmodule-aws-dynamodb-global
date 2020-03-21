/*
Reusable and configurable dynamodb module
*/

resource "aws_dynamodb_table" "table_east" {
  provider = aws.us-east-1

  dynamic attribute {
    for_each = var.attribute_list
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  hash_key       = var.hash_key
  range_key      = var.range_key
  
  name           = var.table_name
  read_capacity  = 0
  write_capacity = 0

  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  point_in_time_recovery {
    enabled = false
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_index_list
    content {
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      name               = global_secondary_index.value.name
      non_key_attributes = global_secondary_index.value.non_key_attributes
      projection_type    = global_secondary_index.value.projection_type
      read_capacity      = global_secondary_index.value.read_capacity
      write_capacity     = global_secondary_index.value.write_capacity
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_index_list
    content {
      name            = local_secondary_index.value.name
      projection_type = local_secondary_index.value.projection_type
      range_key       = local_secondary_index.value.range_key

    }
  }

  dynamic "ttl" {
    for_each = var.ttl_list
    content {
      attribute_name = ttl.value.attribute_name
      enabled        = ttl.value.enabled
    }
  }

  tags = {
    for name, value in var.tags :
    name => value
  }
}

resource "aws_dynamodb_table" "table_west" {
  provider = aws.us-west-2

  dynamic attribute {
    for_each = var.attribute_list
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  hash_key       = var.hash_key
  range_key      = var.range_key
  name           = var.table_name
  read_capacity  = 0
  write_capacity = 0

  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  point_in_time_recovery {
    enabled = false
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_index_list
    content {
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      name               = global_secondary_index.value.name
      non_key_attributes = global_secondary_index.value.non_key_attributes
      projection_type    = global_secondary_index.value.projection_type
      read_capacity      = global_secondary_index.value.read_capacity
      write_capacity     = global_secondary_index.value.write_capacity
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_index_list
    content {
      name            = local_secondary_index.value.name
      projection_type = local_secondary_index.value.projection_type
      range_key       = local_secondary_index.value.range_key

    }
  }

  dynamic "ttl" {
    for_each = var.ttl_list
    content {
      attribute_name = ttl.value.attribute_name
      enabled        = ttl.value.enabled
    }
  }

  tags = {
    for name, value in var.tags :
    name => value
  }
}

resource "aws_dynamodb_global_table" "global_table" {
  depends_on = [
    aws_dynamodb_table.table_east,
    aws_dynamodb_table.table_west,
  ]
  provider = aws.us-west-2

  name = var.table_name

  replica {
    region_name = "us-east-1"
  }

  replica {
    region_name = "us-west-2"
  }
}

provider "aws" {
  alias = "us-west-2"
}

provider "aws" {
  alias = "us-east-1"
}

