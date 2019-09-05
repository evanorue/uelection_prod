#!/bin/sh
# UElection Control Script
#
# Author:  Esteban Orue
# Date:    July 20, 2019
#

# ---------------------------------------------------------------------
# Application settings
# ---------------------------------------------------------------------
APP_NAME="uelection"
APP_ROOT=/app/uelection/
APP_CONF_PATH=${APP_ROOT}conf/
USER="root"

# ---------------------------------------------------------------------
# Java settings
# ---------------------------------------------------------------------
JAVA="/usr/lib/jvm/java-8-openjdk-amd64/bin/java"
JVM_MIN_HEAP=256m
JVM_MAX_HEAP=1024m
#JVM_MAX_PERM_GEN=256m
#JVM_OPTIONS=""

# ---------------------------------------------------------------------
# Tools
# ---------------------------------------------------------------------
GREP=grep
ID=id
PS=ps
AWK=awk
KILL=kill

# ---------------------------------------------------------------------
# Defined methods
# ---------------------------------------------------------------------
#
# Starts Job platform
startApplication() {
	# Getting COS Jobs PID
	loadPid

	# Starting process

	if [ "x${PID}" != "x" ]
	then
		echo "Uelection platform is already running with PID ${PID}"
	else
		echo "-->"
		echo "--> Starting UElection platform... "
		$JAVA -cp $APP_ROOT$APP_NAME.jar -Dloader.main=com.abadonapps.uelection.UelectionApplication org.springframework.boot.loader.PropertiesLauncher -Xms${JVM_MIN_HEAP} -Xmx${JVM_MAX_HEAP} >/dev/null 2>&1 &
		echo "OK"
		healthCheck
	fi
}

# ---------------------------------------------------------------------
#
# Stops Job platform
stopApplication() {

	# Getting COS Jobs PID
	loadPid

	# Killing process
	if [ "x${PID}" != "x" ]
	then
		echo "-->"
		echo "--> Stopping Uelection platform with PID ${PID}... "

		$KILL -9 $PID
		echo "OK"
	else
		echo "Uelection platform is not running"
	fi
}

# ---------------------------------------------------------------------
#
# Validates that the correct user id is executing this script.
checkUser() {
	echo "-->"
	echo "--> Validating user permission... "
	$ID | $GREP "($USER)" > /dev/null
	if [ $? -ne 0 ]
	then
			echo "[FAIL]"
			echo "--> This script function can only be executed as $USER."
			exit 1
	else
			echo "OK"
	fi
}

# ---------------------------------------------------------------------
#
# Validates if the app is alive
healthCheck() {
	echo "-->"
	echo "--> Validating if the app is alive... "
	# Getting COS Jobs PID
	loadPid

	if [ "x${PID}" != "x" ]
	then
		echo "OK"
	else
		echo "Uelection platform is not running"
	fi
}

# ---------------------------------------------------------------------
#
# Loads PID in a global variable
loadPid() {
	# Getting COS Jobs PID
	PID=`$PS -aef | $GREP -i $APP_NAME.jar | $GREP -v grep | $AWK '{print $2}'`
}

# ------------------------------------------------------------------------
# print script usage
#
printUsage() {
    echo "Usage: $0 <command>"
    echo "  Where <command> is one of the following:"
    echo ""
    echo "    start		Starts the platform only if this is not already running"
    echo ""
    echo "    stop		Stops the platform only if this is running"
    echo "    healthcheck		Validates if the platform is running and gives the assigned PID"
    echo ""
    echo "    help		Shows information about the command"
}

# ---------------------------------------------------------------------
# Manage arguments
# ---------------------------------------------------------------------
case "$1" in
	'start')
		# Validates that the correct user id is executing this script.
		checkUser

		# Starts Job platform
		startApplication
	;;

	'stop')
		# Validates that the correct user id is executing this script.
		checkUser

		# Stops Job platform
		stopApplication
	;;
	'healthcheck')
		# Validates if the app is alive
		healthCheck
	;;
	'help')
		# Shows help option
		printUsage
	;;
	'')
		# Shows help option
		printUsage
	;;
esac
