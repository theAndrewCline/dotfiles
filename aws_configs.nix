{
   "profile local" = {
      region = "us-east-2";
      output = "json";
      endpoint_url = "http://localhost:4566";
      aws_access_key_id = "accesskey";
      aws_secret_access_key = "secretkey";
    };
   "profile dev" = {
      region = "us-east-2";
      output = "json";
      sso_account_id = "776984801155";
      sso_role_name = "PowerUserAccess";
      sso_start_url = "https://ppcloud.awsapps.com/start/#";
      sso_region = "us-east-1";
    };
   "profile devadmin" = {
      region = "us-east-2";
      sso_account_id = "776984801155";
      sso_role_name = "AdminUserAccess";
      sso_start_url = "https://ppcloud.awsapps.com/start/#";
      sso_region = "us-east-1";
    };
   "profile prod" = {
      region = "us-east-2";
      sso_account_id = "003707708894";
      sso_role_name = "PowerUserAccess";
      sso_start_url = "https://ppcloud.awsapps.com/start/#";
      sso_region = "us-east-1";
    };
   "profile prodadmin" = {
      region = "us-east-2";
      sso_account_id = "003707708894";
      sso_role_name = "AdminUserAccess";
      sso_start_url = "https://ppcloud.awsapps.com/start/#";
      sso_region = "us-east-1";
    };
   "profile cline" = {
      region = "us-east-2";
      sso_account_id = "423956910718";
      sso_role_name = "PowerUserAccess";
      sso_start_url = "https://ppcloud.awsapps.com/start/#";
      sso_region = "us-east-1";
    };
   "profile clineadmin" = {
      region = "us-east-2";
      sso_account_id = "423956910718";
      sso_role_name = "AdminUserAccess";
      sso_start_url = "https://ppcloud.awsapps.com/start/#";
      sso_region = "us-east-1";
    };
}
