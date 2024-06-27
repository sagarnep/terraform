variable "region" {
 type = string
 default = "us-east-1"   
}

variable "s3-bucket" {
    type = "string"

}

variable "origin_id" {
    description = "Unique identifier to represent the cloudfront"
    type = string
}

variable "tags" {

    description = "Use global tag for the cloudfront"
    type = map{string}
    default = {}
}