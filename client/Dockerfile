FROM node:10
LABEL Dylan Meskis <dmeskis@gmail.com>

ENV APP_HOME /app
#
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
#
# Install app dependencies
COPY package.json $APP_HOME/
COPY yarn.lock $APP_HOME/
RUN yarn install

COPY . $APP_HOME

EXPOSE 8080
CMD ["yarn", "dev"]
