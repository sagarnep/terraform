variable "myregion" {}

variable "accountid" {}

resource "aws_api_gateway_rest_api" "api"{
    name = "myapi"
}

resource "aws_api_gateway_resource" "resource"{
    path_part = "resource"
    parent_id = aws_api_gateway_rest_api.root_resource_id
    rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "method"{
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.resource.root_resource_id
    http_method = "GET"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration"{
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_rest_api.resource.id
    http_method = aws_api_gateway_method.method.http_method
    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = aws_lambda_function.lambda.invoke.arn
}

resource "aws_lambda_permission" "apigw_lambda" {
   statement_id = "AllowExecutionFromApiGateway"
   action = "lambda:InvokeFunction"
   function_name = aws_lambda_function.lambda.function_name
   principla = "apigateway.amazonaws.com"

   source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_methid.method.http_method}${aws_api_gateway_resource.resource.path}"

}

resource "aws_lambda_function" "lambda" {
    filename = "lambda.zip"
    function_name = "mylambda"
    role = "aws_iam_role.role.arn"
    handler = "lambda.lambda_handler"
    runtime = "python3.7"

    source_code_hash = filebase64sha256("lambda.zip")
}

data "aws_iam_policy_document" "assume_role" {
    statement {
        effect = "Allow"

        principals {
            type = "service"
            identifiers = ["lambda.amazonaws.com"]
        }

        actions = ["sts:assumerole"]

    }
}

resource "aws_iam_role" "role" {
    name = "myrole"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
