provider "aws" {
  region = "${var.region}"
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.api_name}"
  description = "${var.api_description}"
}

resource "aws_api_gateway_resource" "api-resource" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "${var.resource_path}"
}
