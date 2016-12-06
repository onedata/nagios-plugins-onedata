#!/bin/bash

RES=$(src/check_oneprovider -u http://localhost/nagios/oneprovider_ok_1.xml)
TEST_COUNT=1

if [ "x$RES" != "xOK - all Oneprovider workers are ok." ]; then
    echo "TEST $TEST_COUNT FAILED"
    exit 1
else
    echo "TEST $TEST_COUNT PASSED"
fi

TEST_COUNT=$((TEST_COUNT+1))

RES=$(src/check_oneprovider -u http://localhost/nagios/oneprovider_error_1.xml)

if [ "x$RES" != "xWarning - the following Oneprovider workers are down: op_worker@node2.oneprovider.localhost" ]; then
    echo "TEST $TEST_COUNT FAILED"
    exit 1
else
    echo "TEST $TEST_COUNT PASSED"
fi

TEST_COUNT=$((TEST_COUNT+1))

RES=$(src/check_oneprovider -u http://localhost/nagios/oneprovider_error_2.xml)

if [ "x$RES" != "xError - all Oneprovider workers are down: op_worker@node1.oneprovider.localhost, op_worker@node2.oneprovider.localhost, op_worker@node3.oneprovider.localhost" ]; then
    echo "TEST $TEST_COUNT FAILED"
    exit 1
else
    echo "TEST $TEST_COUNT PASSED"
fi


RES=$(src/check_onezone -u http://localhost/nagios/onezone_ok_1.xml)
TEST_COUNT=$((TEST_COUNT+1))

if [ "x$RES" != "xOK - all Onezone workers are ok." ]; then
    echo "TEST $TEST_COUNT FAILED"
    exit 1
else
    echo "TEST $TEST_COUNT PASSED"
fi

TEST_COUNT=$((TEST_COUNT+1))

RES=$(src/check_onezone -u http://localhost/nagios/onezone_error_1.xml)

if [ "x$RES" != "xWarning - the following Onezone workers are down: oz_worker@node2.onezone.localhost" ]; then
    echo "TEST $TEST_COUNT FAILED"
    exit 1
else
    echo "TEST $TEST_COUNT PASSED"
fi