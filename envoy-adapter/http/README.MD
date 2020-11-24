# Purpose 

Demo the Apigee Adapter for Envoy

# Prerequisites

Make sure you've set up your API Product properly and obtained an API key as outlined on [this page in the Apigee docs](https://docs.apigee.com/api-platform/envoy-adapter/v1.0-beta.4/operation#how-to-obtain-an-api-key).


# Run as a Script  

1. Revise the environment variable values in the following snippet.

```console
export USEREMAIL=ijustloveapis2020@gmail.com
export USERPWD=iReallyLoveThem
export ORG=apinut-eval
export ENV=test
export APIKEY=asd1f

chmod +x envoy-demo.sh
./envoy-demo.sh $USEREMAIL $USERPWD $ORG $ENV $APIKEY
```
2. Run the commands above (using your own credentials).

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
# Run manually

1. Revise the environment variable values in the following snippet.

```console
# Set the environment variables
export USEREMAIL=ijustloveapis2020@gmail.com
export USERPWD=iReallyLoveThem
export ORG=apinut-eval
export ENV=test
export APIKEY=asd1f

export DEMO_HOME=$PWD
cd ..
export ENVOY_HOME=$PWD
export CLI_HOME=$PWD/apigee-remote-service-cli

cd $CLI_HOME

echo "Generating the config yaml for the remote service..."
./apigee-remote-service-cli provision --legacy --username $USEREMAIL --password $USERPWD --organization $ORG --environment $ENV > config.yaml

docker network create mynet

echo "Starting the remote service as a container..."
docker run -d -p 5000:5000 -p 5001:5001 -v $ENVOY_HOME/apigee-remote-service-cli/config.yaml:/config.yaml --name apigeers --net mynet google/apigee-envoy-adapter:v1.0.0

echo "Making sure we have envoy container image..."
docker pull envoyproxy/envoy:v1.14.1

echo "Run envoy container image..."
docker  run -v $DEMO_HOME/envoy-httpbin.yaml:/etc/envoy/envoy.yaml --name envoya --net mynet --rm -d -p 8080:8080 envoyproxy/envoy:v1.14.1

# Pause a bit for the container to come fully online.
sleep 3

# Test end-to-end
curl -i http://localhost:8080/httpbin/headers -H "x-api-key: $APIKEY"
```

2. Run the commands above (using your own credentials).
