
# nagios-plugins-onedata

This repository contains Nagios plugins for testing Onedata services availability, namely `Oneprovider` and `Onezone` services.

## Requirements
These Nagios probes have the following requirements in order to work properly:
- Bash
- cURL
- xmllint (from libxml2-utils)
- access to port `6666` on machine hosting Onedata service

## Running the probes

### Oneprovider
Oneprovider probe supports the following command line options:
```bash
Nagios plugin for Oneprovider service of Onedata

Usage:
src/check_oneprovider [-h|--help] [-t|--timeout <timeout>] [-p|--port <port>]
                    [-H|--hostname <hostname>] [-u|--url <endpoint>]

 -h|--help    - Prints this help
 -t|--timeout - Determines the entire connection timeout (Default: 10 seconds)
 -H|--host    - The Onedata hostname
 -p|--port    - The Onedata Nagios port (Default: 6666)
 -u|--url     - The complete Onedata Nagios endpoint
```

### Onezone
```bash
Nagios plugin for Onezone service of Onedata

Usage:
src/check_oneprovider [-h|--help] [-t|--timeout <timeout>] [-p|--port <port>]
                    [-H|--hostname <hostname>] [-u|--url <endpoint>]

 -h|--help    - Prints this help
 -t|--timeout - Determines the entire connection timeout (Default: 10 seconds)
 -H|--host    - The Onedata hostname
 -p|--port    - The Onedata Nagios port (Default: 6666)
 -u|--url     - The complete Onedata Nagios endpoint
```


## Building CentOS RPM
To build the RPM's simply run the default `Makefile`:

```bash
$ make
```

## Running plugin unit tests

First create and start the Docker, which serves the mockup healthdata XML files:

```bash
$ cd nagios-plugins-onedata
$ docker build --file docker/Dockerfile.nginx -t onedata-nagios-test .
$ docker run -t -d -p 80:80 onedata-nagios-test
```

Then run the `tests/test.sh` script:
```bash
$ tests/test.sh
```

Finally stop the Nginx container and optionally destroy it:
```bash
$ docker stop $(docker ps -f ancestor=onedata-nagios-test -q)
$ docker rmi onedata-nagios-test
```


