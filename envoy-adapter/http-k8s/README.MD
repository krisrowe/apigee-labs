# Purpose 

Demo the Apigee Adapter for Envoy on Kubernetes

# Prerequisites

1. Make sure you've set up your API Product properly and obtained an API key as outlined on [this page in the Apigee docs](https://docs.apigee.com/api-platform/envoy-adapter/v1.0-beta.4/operation#how-to-obtain-an-api-key).

2. Also add the path `/` to the additional API Product that you manually create for httpbin.org. Otherwise you will get 403 errors.

3. Make sure you are pointed locally to a running Kubernetes cluster

Google Kubernetes Engine (GKE)
```
gcloud container clusters get-credentials [cluster-name] --zone [zone-name]
```

# Deploy services on Kubernetes

1. Set Apigee credentials to env variables (*** USE YOUR OWN ***)

```console
export USER=ijustloveapis2020@gmail.com
export PASSWORD=iReallyLoveThem
export ORG=apinut-eval
export ENV=test
```

2. Set path-related environment variables 

```console
export LAB_HOME=$PWD
cd ..
export CLI_HOME=$PWD\apigee-remote-service-cli
cd $LAB_HOME
```

3. Provision the Apigee Remote Service in the cloud and gen local config 
```console
$CLI_HOME/apigee-remote-service-cli provision --legacy --username $USER --password $PASSWORD --organization $ORG --environment $ENV > config.yaml
```

4. Make sure you have a namespace set up on Kubernetes
```console
kubectl create namespace apigee
```

5. Create a K8s ConfigMap for the Apigee Remote Service using the config.yaml file that we generated with the CLI provisioning command.
```console
kubectl create configmap -n apigee apigee-remote-service-envoy --from-file=./config.yaml
```

6. Create the deployment and K8s service for the Apigee Remote Service 
```console
kubectl apply -f saas-apigee-remote-service-envoy.yaml
```

7. Transfer our local config file for the Envoy proxy to a K8s ConfigMap
```console
kubectl create configmap -n apigee standalone-envoy-config --from-file=./standalone-envoy-config.yaml
``` 

8. Create a standalone deployment and K8s service for the Envoy proxy
```console
kubectl apply -f standalone-envoy-manifest.yaml
```

9. Create the API Product in Apigee

   1. Click on API Products in the Apigee Management UI menu
   
   2. Click the button to add a new product

   3. Enter an intuitive name for the product (e.g. "HTTP Bin")

   4. Select access as Private

   5. Click to add a proxy and select the remote-service proxy

   6. Click to add a remote service and enter as follows:

      1. Target name: "httpbin.org"
      2. API proxy: "remote-service"
      3. Path: "/"

   7. Save the new API Product

10. Click on "Apps" in the Apigee Management UI menu and register a new app
   1. Add the newly created API Product to the app
   2. Save
   3. Grab the new API Key

# Test

1. Deploy curl as an another service and connect to the container: `kubectl run -it curl --image=curlimages/curl --restart=Never -- sh`

2. Using your own API Key, run `export APIKEY=asdf1234`

3. Invoke the service via the Envoy proxy
```console
curl -i standalone-envoy.apigee.svc.cluster.local/httpbin/headers -H "x-api-key: $APIKEY"
```

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