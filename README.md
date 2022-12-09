# TinyOWS in a docker-compose setup

TinyOWS is a very compact way to get a WFS running.
The authors describe it as "WFS frontend for a postGIS database".
Being so tiny it has some requirements:

- It requires a postGIS db as backend,
- pg_config is required at build time
- And it needs a CGI capable web server to handle communications

To provide these requirements we build the container on top of the standard postGIS image (since pg_config is required at build time) and in a single container.
The web server is provided by lighthttpd, a tiny web server that provides the required CGI integration.

This setup is not intended to work out of the box, some assembly is required.

## Features

With this you get a WFS-T that is accessible on port http://<your_host>:8080/tinyows and unless you do some more configuration greets you with a friendly 
```
<?xml version='1.0' encoding='UTF-8'?>
<ows:ExceptionReport
 xmlns='http://www.opengis.net/ows'
 xmlns:ows='http://www.opengis.net/ows'
 xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
 xsi:schemaLocation='http://www.opengis.net/ows http://schemas.opengis.net/ows/1.0.0/owsExceptionReport.xsd'
 version='1.1.0' language='en'>
 <ows:Exception exceptionCode='ErrorConfigFile' locator='parse_config_file'>
  <ows:ExceptionText>Unable to open config file !</ows:ExceptionText>
 </ows:Exception>
</ows:ExceptionReport>
```

## Configuration

### tinyOWS

This takes place on several levels.
The most global settings reside in the `.env` file that defines environment variables for the container. 
Before the first start, you should go here and change the `POSTGRES_PASSWORD` to something valid.
You really should back up any changes you enter here to protect your settings from being nuked by git on pulling.

The configuration of tinyows itself is performed via the directory `tinyows_config`, which will be mounted to the container.
Configuration files in this directory are then accessible to tinyows.
It is __strongly__ recommended to create your own configurations that are not part of this repository to avoid overwriting them when pulling a new version.
Selection __which__ of the configuration files will be used has to be done by editing the respective variable in the `.env` file.
Note that `/var/tinyOWS/config/` is the mount point of `tinyows_config` inside the container and should not be changed.

Activating changes to the configuration requires a container restart, which can be triggered by `docker-compose restart` or `docker restart tinyows`.

### postGIS

To manage the database, we provide the `psql_at_container.sh` script in the `control` directory. 
It runs the command `docker exec -tiu postgres tinyows psql` that starts the psql utility in the container and allows you to do psql stuff.

### lighthttpd

Changes to the web server configuration are not dynamic and require a rebuild of the container. 

## Usage

1. clone
2. edit .env
3. docker-compose up --build
4. psql