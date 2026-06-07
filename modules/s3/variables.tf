variable "bucket_name" {
  type = string
  description = "The name of the S3 bucket"
  default = ""
  sensitive = false
  nullable = false

  validation {
    condition = length(var.bucket_name) > 3
    error_message = "The bucket name must be at least 4 characters long"
  }
  
}

variable "tags" {
  type = map(string)
  description = "Label mappings assigned to resources are used for cost allocation and resource management"
  default = {}
  nullable = false
  sensitive = false

  validation {
    condition = alltrue([for key, value in var.tags : can(tostring(value))])
    error_message = "all the tags value must be string"
  }
}

# if you want to make a s3 static website 
variable "enable_website" {
  description = "Set to true to enable static website hosting"
  type        = bool
  default = false
}

variable "enable_force_destroy" {
  description = "Allow forced deletion of the S3 bucket (empty the data in the bucket)"
  type        = bool
  default     = false 
}

