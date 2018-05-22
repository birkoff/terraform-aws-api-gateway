provider "aws" {
  region = "${var.region}"
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "ec2manager-api"
  description = "EIQ EC2 Instances Manager API"
}

resource "aws_api_gateway_resource" "api-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "${var.resource_path}"
}
