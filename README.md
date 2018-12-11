# Terraform AWS API Gateway
Terraform module which created AWS API Gateway Resource

These types of resources are created:
- aws_api_gateway_rest_api
- aws_api_gateway_resource

Usage
-------
Use in combination with:
- https://github.com/birkoff/terraform-aws-api-method
- https://github.com/birkoff/terraform-aws-api-method-mock
- https://github.com/birkoff/terraform-aws-lambda-function


Example:
---

Lambda Function:
```
module "my_lambda_function" {
  source           = "birkoff/lambda-function/aws"
  runtime          = "${var.runtime}"
  region           = "${var.region}"
  function_name    = "${var.function_name}"
  timeout          = "${var.timeout}"
  s3_lambda_bucket = "${var.s3_lambda_bucket}"
  s3_function_key  = "${var.source_s3_key_change_instance}"
  description      = "${var.description_change_instance}"
  handler          = "${var.handler_change_instance}"
  lambda_role_arn  = "${aws_iam_role.ec2manager-change-instance-state-role.arn}"
  source_arn       = "arn:aws:execute-api:${var.region}:${var.account_id}:*"
  principal        = "apigateway.amazonaws.com"

  env_vars = {
    ENV = "${var.environment}"
  }

  tags = {
    Terraform = "true"
    Environment = "${var.environment}"
  }
}

```

API:

```
module "my_api" {
  source        = "birkoff/api-gateway/aws"
  region        = "${var.region}"
  resource_path = "${var.resource_path}"
  api_name      = "${var.api_name}"
  api_description = "${var.api_description}"
}
```

Method GET:

````
module "method_get" {
  source             = "birkoff/api-method/aws"
  region             = "${var.region}"
  api_id             = "${module.my_api.id}"
  integration_type   = "AWS_PROXY"
  http_method        = "GET"
  lambda_fuction_arn = "${module.my_lambda_function.lamda_fuction_arn}"
  api_resource_id    = "${module.my_api.resource_id}"
  authorization      = "NONE"
  api_resource_path  = "${module.my_api.resource_path}"
}
````

Method POST:

```
module "method_post" {
  source             = "birkoff/api-method/aws"
  region             = "${var.region}"
  api_id             = "${module.my_api.id}"
  integration_type   = "AWS"
  http_method        = "POST"
  lambda_fuction_arn = "${module.my_lambda_function.lamda_fuction_arn}"
  api_resource_id    = "${module.my_api.resource_id}"
  authorization      = "NONE"
  api_resource_path  = "${module.my_api.resource_path}"
}
```


Method OPTIONS (for Jquery request)

````
module "method_options" {
  source             = "birkoff/api-method-mock/aws"
  region             = "${var.region}"
  api_id             = "${module.my_api.id}"
  http_method        = "OPTIONS"
  api_resource_id    = "${module.my_api.resource_id}"
  authorization      = "NONE"
  api_resource_path  = "${module.my_api.resource_path}"
  allow_methods      = "'POST,GET,OPTIONS'"
}
````

Deploy the API

```
resource "aws_api_gateway_deployment" "test" {
  depends_on = ["module.method_get", "module.method_post", "module.method_options"]
  rest_api_id = "${module.my_api.id}"
  stage_name  = "test"
  description = "test"
}
```


Note
---
When creating Infrastructure there is an issue with API Gateway and Lambda permissions
To fix it:

1. Go to AWS Dashboard Amazon API Gateway
2. Select the API and go to Resources
3. Select the Resource Methods and click on "Integration Request"
4. Uncheck "Use Lambda Proxy integration" and check it Again after
5. Deploy the API to a stage

This will re-set a permission for api-gateway to execute lambda
Even adding a permission on Terraform this doesn't work so it has to be done once at the moment of the creation of the Resources


License
-------
MIT
