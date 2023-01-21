FROM node:13-alpine

ENV MONGO_DB_USERNAME=admin \
    MONGO_DB_PWD=password

RUN mkdir -p /Desktop/techworld-js-docker-demo-app-with-nana-master/app

COPY ./app /Desktop/techworld-js-docker-demo-app-with-nana-master/app

# set default dir so that next commands executes in /home/app dir
WORKDIR /Desktop/techworld-js-docker-demo-app-with-nana-master/app

# will execute npm install in /home/app because of WORKDIR
RUN npm install

# no need for /home/app/server.js because of WORKDIR
CMD ["node", "/Desktop/techworld-js-docker-demo-app-with-nana-master/app/server.js"]

