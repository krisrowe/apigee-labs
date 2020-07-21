
# Set the environment variables
echo "Working directory: $PWD"
export ENVOY_HOME=$PWD
export CLI_HOME=$PWD/apigee-remote-service-cli
export ORG=amer-demo22
export ENV=prod
export USER=$1


# Stop after setting environment variables if a command-line parameter 'p' (passive) is included.
if [[ "$*" == "p" ]]
then
	    echo "Environment variables set."
else
  echo "Running stuff..."
  cd $CLI_HOME
  
  echo "Generating the config yaml for the remote service..."
  ./apigee-remote-service-cli provision --legacy --username $1 --password $2 --organization $ORG --environment $ENV > config.yaml

  docker network create mynet

  echo "Starting the remote service as a container..."
  docker run -d -p 5000:5000 -p 5001:5001 -v $ENVOY_HOME/apigee-remote-service-cli/config.yaml:/config.yaml --name apigeers --net mynet  gcr.io/apigee-api-management-istio/apigee-remote-service-envoy:latest

  echo "Making sure we have envoy container image..."
  docker pull envoyproxy/envoy:v1.14.1

  echo "Run envoy container image..."
  docker  run -v $ENVOY_HOME/envoy-httpbin.yaml:/etc/envoy/envoy.yaml --name envoya --net mynet --rm -d -p 8080:8080 envoyproxy/envoy:v1.14.1

  # Pause a bit for the container to come fully online.
  sleep 3

  # Test end-to-end
  curl -i http://localhost:8080/httpbin/headers -H "x-api-key: $3"
fi
