
create or replace api integration github
    api_provider = git_https_api
    api_allowed_prefixes = ('https://github.com')
    enabled = true
    allowed_authentication_secrets = all;

SHOW API INTEGRATIONS;
