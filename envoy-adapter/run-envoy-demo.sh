echo "User/email: $1"
echo "API Key: $2"

# Prompt for the password to be entered
echo -n Apigee password: 
read -s password

# Set the environment variables
echo "Working directory: $PWD"
export ENVOY_HOME=$PWD
export CLI_HOME=$PWD/apigee-remote-service-cli
export REMOTE_SERVICE_HOME=$PWD/apigee-remote-service-envoy
export ORG=amer-demo22
export ENV=prod
export USER=$1
export PASSWORD=$password


# Stop after setting environment variables if a command-line parameter 'p' (passive) is included.
if [[ "$*" == "p" ]]
then
	    echo "Environment variables set."
else
  echo "Running stuff..."
  cd $CLI_HOME
  
  echo "Generating the config yaml for the remote service..."
  ./apigee-remote-service-cli provision --legacy --username $USER --password $PASSWORD --organization $ORG --environment $ENV > config.yaml
  cd $ENVOY_HOME

  echo "Starting the remote service as a container..."
  docker run -d -p 5000:5000 -p 5001:5001 -v $PWD/apigee-remote-service-cli/config.yaml:/config.yaml gcr.io/apigee-api-management-istio/apigee-remote-service-envoy:latest

  echo "Making sure we have envoy container image..."
  docker pull envoyproxy/envoy:v1.14.1

  echo "Run envoy container image..."
  docker  run -v $REMOTE_SERVICE_HOME/samples/native/envoy-httpbin.yaml:/etc/envoy/envoy.yaml --rm -d -p 8080:8080 envoyproxy/envoy:v1.14.1

  export APIKEY=$2
fi
