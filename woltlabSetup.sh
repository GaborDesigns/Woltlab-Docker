#!/bin/sh

# Variables for WSC installation
DIR='./tmp';
ROOT_PATH='./www/html';
APACHE_CONTAINER=$(docker ps | grep "php:7.4-apache" | awk '{ print $11 }');
export $(cat .env | grep WOLTLAB_VERSION | xargs);

# Variable for Docker Compose 
export $(cat .env | grep CONTAINER_NAME | xargs);
export $(cat .env | grep APACHE_PORT | xargs);
export $(cat .env | grep PHPMYADMIN_PORT | xargs);
export $(cat .env | grep MYSQL_ROOT_PASSWORD | xargs);

# Setup Docker Compose
echo "Setup docker-compose";

echo "version: '3'

services:
  ${CONTAINER_NAME}-apache:
    build:
        context: .
        dockerfile: Dockerfile
    container_name: ${CONTAINER_NAME}-apache
    volumes:
      - './config/apache2:/etc/apache2'
      - './www/html:/var/www/html'
    ports:
      - '${APACHE_PORT}:80'
    links:
      - mysql

  ${CONTAINER_NAME}-mysql:
    image: mysql
    container_name: ${CONTAINER_NAME}-mysql
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
    command: '--default-authentication-plugin=mysql_native_password'

  ${CONTAINER_NAME}-phpmyadmin:
    image: phpmyadmin
    container_name: ${CONTAINER_NAME}-phpmyadmin
    ports:
      - '${PHPMYADMIN_PORT}:80'
    environment:
      - PMA_ARBITRARY=1
    links:
      - ${CONTAINER_NAME}-mysql" > docker-compose.yml;

# Remove temp dir if already exists
if [ -d "$DIR" ]; then
    rm -f $DIR;
fi

# Create apache volume if not exists
if [ -d "$ROOT_PATH" ]; then
    mkdir $ROOT_PATH;
fi

# Create temporary directory
echo "Creating temp directory ...";
mkdir $DIR;

# Download Woltlab Suite Core
echo "Downloading Woltlab Suite Core ...";
wget -O $DIR/woltlab.zip https://assets.woltlab.com/release/woltlab-suite-$WSC_VERSION.zip;
unzip $DIR/woltlab.zip -d $DIR

# Move to NGINX public directory
echo "Move unzipped Woltlab Suite Core into NGINX directory ...";
mv $DIR/upload/* $ROOT_PATH

# Remove temp directory
echo "Removing temp directory ...";
rm -r $DIR;

# clear;