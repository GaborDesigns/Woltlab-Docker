<div style="background-color: #3a6d9c; margin: 0; padding: 20px">
  <img src="https://www.woltlab.com/images/default-logo-small.png" style="display: block;margin: 0 auto;">
</div>

# Woltlab Docker 
Development environment with Docker

## Features
- PHP 7.4 & Apache
- MySQL (latest)
- phpMyAdmin

## Preparation before installing
First clone this repository.
Before you start the docker container, please copy the `.env.example` to `.env`.
Change the settings for the new docker container.

`WOLTLAB_VERSION`       (default: 5.3.1)  - Which WSC Core version should be installed 
`MYSQL_ROOT_PASSWORD`   (default: mysql)  - Please change it to an more secure password
`CONTAINER_NAME`        (default: wsc)    - ID of the installing docker container. It **must** be unique!
`APACHE_PORT`           (default: 80)     - Port to open the webserver in the browser
`PHPMYADMIN_PORT`       (default: 8080)   - Port to open the phpmyadmin panel in the browser

Before you boot your container, run the `./woltlabSetup.sh` to create the Docker file & get the WSC files.

## Installation
If you setup the first step then run `docker-compose up -d` to boot your containers in daemon mode.  
Depending on your permission level and docker configuration, maybe you need to run that as root (not recommendet but ok for developmet purposes).

For stopping the container run `docker-compose stop` command.

<span style="background-color: #e67e22; color: white; padding: 4px; border-radius: 4px">Optional</span> configure the docker container name in your hosts file.  
`/etc/hosts` on Linux & Mac,  
`C:\Windows\System32\drivers\etc\hosts` on Windows.
```
# Default config
127.0.0.1   name.local

# If you like to add a subdomain, for example
127.0.0.1   myproject.name.local
```

When your containers finished initializing and booting, visit [name.local](http://name.local).  
Or if you skipped hosts configuration, you can visit [your localhost](http://localhost) as well.

## Configuration
Configuration is located in `config`.  
Currently there's only a apache2 config. Add volumes for other containers as you need it here.

If you run multiple containers with the Woltlab installation, please change for every new container the containername.

## Projects & Containers
The used defaults refer to directories and volumes within this directory structure.  
Depending on your preferences it may make more sense to re-bind some volumes to existing projects, or add new volumes for projects that live elsewhere in your file system.  
For example, adding a existing PHP project from `/home/dude/code/project` to wsc-apache may result in

``` yaml
volumes:
  - /home/dude/code/myAwesomeProject:/var/www/myAwesomeProject
```

## PHP-Apache
Image `php:7.4-apache`

Configuration volume is at `config/apache2` and is mounted to `/etc/apache2`.  
Note that the contained configuration files are the slightly modified default ones.  

The default ServerName directive listens to `name.local` (without TLS).  

**Volumes**
- `config/apache2` : `etc/apache2`
- `www/html` : `/var/www/html`

**Exposed Ports**
- 80 ( default )

## MySQL
Image `mysql`

Take a look at `.env` and **please** change the default `MYSQL_ROOT_PASSWORD` env variable to a more secure one.  
Used authentication plugin is `mysql_native_password`.

**Environment Variables**
- MYSQL_ROOT_PASSWORD (default "mysql")

## phpMyAdmin
Image `phpmyadmin`

For testing and sake of easy maintainability of your data.  
By default phpMyAdmin is accessible at [localhost:8080](http://localhost:8080).  
Feel free to change that to match your desires.

_Quick note: the linked mysql container is accessible via it's container name (**wsc-mysql** by default)._

**Exposed Ports**
- 8080 ( default )
