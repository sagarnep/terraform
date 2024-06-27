
provider "aws"{
    region = "us-east-1"
}

resource "aws_amplify_app" "amplify" {
    name = "amplify-sagar"
    repository = "https://github.com/sagarnep/amplify.git"
    access_token = "$API_TOKEN"
}

resource "aws_amplify_branch" "main" {
    app_id = aws_amplify_app.amplify.id
    branch_name = "main"

    # framework = "React"
    # stage = "PRODUCTION"
}

# resource "aws_cognito_user_pool" "cognito" {
#     name = "mypool"


#     schema {
#         name = "terraform"
#         attribute_data_type = "String"
#         mutable = false
#         required = false
#         developer_only_attribute = false
#         string_attribute_constraints {}  
#     }

# }

# resource "aws_congitor_user" "amplify" {
#     user_pool_id = aws_congito_user_pool.cognito.id 
#     username = "cognito"

#     attributes = {
#         terraform = true
#         foo = "bar"
#         email ="no-reply@hasicorp.com"
#         email_verified = true
#     }
# }

# #configure amplify environment variables for congito settings

# resource "aws_amplify_app_environment" "cognito_environment" {
# app_id = aws_amplify_app.amplify.id
# env_name = "cognito"
# variables = {
#     COGNITO_REGION = "us-east-1"
#     COGNITO_USER_POOL_ID = aws_cognito_user_pool.cognito.id
#     COGNITO_IDENTITY_POOL_ID = aws_congito_identity_pool.main.id

# }