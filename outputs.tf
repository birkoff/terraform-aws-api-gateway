output "id" {
  value = "${aws_api_gateway_rest_api.api.id}"
}

output "resource_id" {
  value = "${aws_api_gateway_resource.api-resource.id}"
}

output "resource_path" {
  value = "${aws_api_gateway_resource.api-resource.path}"
}

output "root_resource_id" {
  value = "${aws_api_gateway_rest_api.api.root_resource_id}"
}
