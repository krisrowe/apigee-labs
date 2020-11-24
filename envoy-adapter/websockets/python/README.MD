# Purpose 

Demo the Apigee Adapter for Envoy using Websockets

# Prerequisites

Make sure you've set up your API Product properly and obtained an API key as outlined on [this page in the Apigee docs](https://docs.apigee.com/api-platform/envoy-adapter/v1.0-beta.4/operation#how-to-obtain-an-api-key).


# Sample Expected Output
```
> What’s your name? 
Enter a name and you will receive a pingback from the websocket server deployed previously:

< Hello [name]!
```
# Commands to run

1. Set environment variables for your credentials

```console
# Set the environment variables for Apigee credentials
export USEREMAIL=ijustloveapis2020@gmail.com
export USERPWD=iReallyLoveThem
export ORG=apinut-eval
export ENV=test
```

2. Set path-related environment variables 

```console
cd ..
export DEMO_HOME=$PWD
cd ..
export CLI_HOME=$PWD/apigee-remote-service-cli
```

3. Provision the Apigee Remote Service in the cloud and gen local config 
```console
$CLI_HOME/apigee-remote-service-cli provision --legacy --username $USEREMAIL --password $USERPWD --organization $ORG --environment $ENV > $CLI_HOME/config.yaml
```

4. Setup a Docker network so that containers can communicate

```console
docker network create mynet
```

5. Build a new container for the Websockets server app
```console
docker build -t apigee/websocket-server:1.0 server/.
```

6. Start the Websockets server
```console
docker run -d -p 8081:8080 --name=wsserver --network=mynet apigee/websocket-server:1.0
```

7. Start the Apigee Remote Service
```console
docker run -d -p 5000:5000 -p 5001:5001 -v $CLI_HOME/config.yaml:/config.yaml --name=apigeers --network=mynet google/apigee-envoy-adapter:v1.0.0
```

8. Make sure we have Envoy container image
```console
docker pull envoyproxy/envoy:v1.14.1
```

9. Run the Envoy container image
```console
docker run -v $DEMO_HOME/envoy-config.yaml:/etc/envoy/envoy.yaml --name envoya --net mynet -d -p 8080:8080 -p 9000:9000 envoyproxy/envoy:v1.14.1
```

10. Edit the client configuration (client/client.py) to use your own API key 

11. Test end-to-end
```console
cd $DEMO_HOME/client
python3 -m pip install -r requirements.txt
python3 client.py
```
