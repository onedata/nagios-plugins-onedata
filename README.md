# nagios-plugins-onedata

This repository contains Nagios plugins for testing Onedata services availability,
namely `Oneprovider` and `Onezone` services.

## Requirements

These Nagios probes have the following requirements in order to work properly:

- Bash
- cURL
- xmllint (from libxml2-utils)
- access to port `443` on machine hosting Onedata service

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

### How the probes work

Each of Onedata services (Onezone, Oneprovider) expose an endpoint with health data in
XML for all worker processes running on a given site (each Onedata service can have
mutliple worker processes running in parallel for higher performance and reliability).

By default all Onedata service provide this information on port `6666` so it must be ensured that this port is opened on the Onedata sites to the nodes where Nagios monitoring probes are executed.

An example XML output for a Onezone service is below:

```xml
<?xml version="1.0"?>
<healthdata date="2016/11/24 13:10:02" status="error">
  <oz_worker name="oz_worker@node1.onezone.localhost" status="ok">
    <node_manager status="ok"/>
    <request_dispatcher status="ok"/>
    <changes_worker status="ok"/>
    <datastore_worker status="ok"/>
    <dns_worker status="ok"/>
    <groups_graph_caches_worker status="ok"/>
    <ozpca_worker status="ok"/>
    <subscriptions_worker status="ok"/>
    <dns_listener status="ok"/>
    <gui_listener status="ok"/>
    <nagios_listener status="ok"/>
    <oz_redirector_listener status="ok"/>
    <rest_listener status="ok"/>
    <subscriptions_wss_listener status="ok"/>
  </oz_worker>
  <oz_worker name="oz_worker@node2.onezone.localhost" status="error">
    <node_manager status="ok"/>
    <request_dispatcher status="ok"/>
    <changes_worker status="ok"/>
    <datastore_worker status="ok"/>
    <dns_worker status="ok"/>
    <groups_graph_caches_worker status="error"/>
    <ozpca_worker status="ok"/>
    <subscriptions_worker status="ok"/>
    <dns_listener status="ok"/>
    <gui_listener status="ok"/>
    <nagios_listener status="ok"/>
    <oz_redirector_listener status="error"/>
    <rest_listener status="ok"/>
    <subscriptions_wss_listener status="ok"/>
  </oz_worker>
</healthdata>
```

In case all workers are working and the health data status is ok, the probe will return `OK` status.

If all of the workers are down and return `error` status the probe will return a `CRITICAL` status code and in case at least one worker is still running the status will be `WARNING`.

## Building CentOS RPM

Building can be done on a Centos 6 Docker container:

```bash
#
# Build the RPM from scratch
#
docker run -ti centos:6 /bin/bash
yum install -y git rpm-build
cd /root
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
git clone https://github.com/onedata/nagios-plugins-onedata
cd nagios-plugins-onedata
make
cp nagios-plugins-onedata*tar.gz ../rpmbuild/SOURCES
rpmbuild -bb nagios-plugins-onedata.spec

#
# Install and test the RPM
#
cd ../rpmbuild/RPMS/noarch
rpm -Uvh nagios-plugins-onedata-3.0.0-1.el6.noarch.rpm
/usr/lib64/argo-monitoring/probes/org.onedata/check_onezone -h
```

## Running probe unit tests

First create and start the Docker, which serves the mockup health data XML files:

```bash
cd nagios-plugins-onedata
docker build --file docker/Dockerfile.nginx -t onedata-nagios-test .
docker run -t -d -p 80:80 onedata-nagios-test
```

Then run the `tests/test.sh` script:

```bash
tests/test.sh
```

Finally stop the Nginx container and optionally destroy it:

```bash
docker stop $(docker ps -f ancestor=onedata-nagios-test -q)
docker rmi onedata-nagios-test
```
