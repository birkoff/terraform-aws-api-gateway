# aws-lambda-scheduled-function
Terraform module which created AWS API Gateway Resource

These types of resources are created:
- aws_api_gateway_rest_api
- aws_api_gateway_resource

Usage
-------
````
module "ec2manager_api" {
  source        = "birkoff/api-gateway"
  region        = "eu-central-1"
  resource_path = "endpoint"
}
````

License
-------
MIT
