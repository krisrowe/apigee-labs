# Purpose 

Demo the Apigee Adapter for Envoy using gRPC

# Prerequisites

Make sure you've set up your API Product properly and obtained an API key as outlined on [this page in the Apigee docs](https://docs.apigee.com/api-platform/envoy-adapter/v1.0-beta.4/operation#how-to-obtain-an-api-key).


# Sample Expected Output
```
TBD
```
# Commands to run

1. Set environment variables for your credentials

```console
# Set the environment variables
export USEREMAIL=ijustloveapis2020@gmail.com
export USERPWD=iReallyLoveThem
export ORG=apinut-eval
export ENV=test
export APIKEY=asd1f
```

2. Set general environment variables 

```console
export GRPC_HOME=$PWD
export CLI_HOME=$PWD/apigee-remote-service-cli
cd $CLI_HOME
```

3. Provision the Apigee Remote Service in the cloud and gen local config 
```console
$CLI_HOME/apigee-remote-service-cli provision --legacy --username $USEREMAIL --password $USERPWD --organization $ORG --environment $ENV > $CLI_HOME/config.yaml
```

4. Setup a Docker network so that containers can communicate

```console
docker network create mynet
```

5. Build a new container for the gRPC app
```console
docker build -t grpc/node-grpc-app .
```

6. Start the Apigee Remote Service
```console
docker run -d -p 50051:50051 --name=apigeers --network=mynet grpc/node-grpc-app
```

7. Make sure we have Envoy container image
```console
docker pull envoyproxy/envoy:v1.14.1
```

8. Run the Envoy container image
```console
docker run -v $GRPC_HOME/envoy-config.yaml:/etc/envoy/envoy.yaml --name envoya --net mynet --rm -d -p 8080:8080 envoyproxy/envoy:v1.14.1
```

9. Edit the client configuration (client.js) to use your own API key 
```JavaScript
var metadata = new grpc.Metadata();
metadata.add('x-api-key', 'asdf'); // replace 'asdf' with your own key
```

10. Test end-to-end
```console
cd $GRPC_HOME
npm install
node client.js 
# Alternatively run the following
# node client.js Apigee
```