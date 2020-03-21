variable "environment" {
  type        = string
  description = "The development environment"
}

variable "table_name" {
  type        = string
  description = "The DynamoDB table name"
}

variable "attribute_list" {
  type = list(object({
    name = string
    type = string
  }))
  description = "The list of table attributes"
}

variable "hash_key" {
  type        = string
  description = "The table hash keyt"
}

variable "range_key" {
  type        = string
  description = "The table range key"
}

variable "tags" {
  type        = map(string)
  description = "The map of tags"
}

variable "ttl_list" {
  type = list(object({
    attribute_name = string
    enabled        = bool
  }))
  description = "The list of ttl objects to support optional ttl"
}


variable "global_secondary_index_list" {
  type = list(object({
    hash_key           = string
    range_key          = string
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    read_capacity      = number
    write_capacity     = number
  }))
  description = "The list of global secondary index definitions"
}

variable "local_secondary_index_list" {
  type = list(object({
    name            = string
    projection_type = string
    range_key       = string
  }))
  description = "The list of local secondary index definitions"
}

