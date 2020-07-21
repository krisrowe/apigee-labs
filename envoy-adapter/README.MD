# Purpose 

Demo the Apigee Adapter for Envoy

# Instructions

1. Make sure you've set up your API Product properly and obtained an API key as outlined on [this page in the Apigee docs](https://docs.apigee.com/api-platform/envoy-adapter/v1.0-beta.4/operation#how-to-obtain-an-api-key).  

2. Update the environment variable values for APIKEY, APIGEE_EMAIL, and APIGEE_PWD in the following snippet.

```console
export APKEY=asd1f
export USEREMAIL=ijustloveapis2020@gmail.com
export USERPWD=iReallyLoveThem
export ORG=apinut-eval
export ENV=test

chmod +x envoy-demo.sh
./envoy-demo.sh $USEREMAIL $USERPWD $ORG $ENV $APIKEY
```
3. Run the commands above (using your own credentials).

# Sample Expected Output
```
HTTP/1.1 200 OK
date: Tue, 21 Jul 2020 06:14:12 GMT
content-type: application/json
content-length: 797
server: envoy
access-control-allow-origin: *
access-control-allow-credentials: true
x-envoy-upstream-service-time: 213

{
  "headers": {
    "Accept": "*/*", 
    "Content-Length": "0", 
    "Host": "httpbin.org", 
    "User-Agent": "curl/7.52.1", 
    "X-Amzn-Trace-Id": "Root=1-5f1687b5-2a97fdf121c56322af27e57d", 
    "X-Api-Key": "asd1f", 
    "X-Apigee-Accesstoken": "", 
    "X-Apigee-Api": "httpbin.org", 
    "X-Apigee-Apiproducts": "remote-service,Local Products API", 
    "X-Apigee-Application": "NNL Products App", 
    "X-Apigee-Authorized": "true", 
    "X-Apigee-Clientid": "asd1f", 
    "X-Apigee-Developeremail": "ijustloveapis2020@gmail.com", 
    "X-Apigee-Environment": "prod", 
    "X-Apigee-Organization": "api-guru22", 
    "X-Apigee-Scope": "", 
    "X-Envoy-Expected-Rq-Timeout-Ms": "15000", 
    "X-Envoy-Original-Path": "/httpbin/headers"
  }
}
```
