FROM node:10
# Create app directory
WORKDIR /opt
 
# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
COPY helloworld.proto ./protos/
 
RUN npm install
# If you are building your code for production
# RUN npm ci --only=production
 
 
# Bundle app source
COPY greeter_server.js ./
COPY helloworld.proto ./
 
EXPOSE 50051
 
CMD [ "node", "greeter_server.js"]
 
