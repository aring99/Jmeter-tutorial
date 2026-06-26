#!/bin/bash

set -e

#####################################
# Configuration
#####################################

JAVA_PACKAGE="openjdk-21-jdk"
JMETER_VERSION="5.6.3"
JMETER_ARCHIVE="apache-jmeter-${JMETER_VERSION}.tgz"
JMETER_URL="https://archive.apache.org/dist/jmeter/binaries/${JMETER_ARCHIVE}"
INSTALL_DIR="/opt"
JMETER_HOME="${INSTALL_DIR}/apache-jmeter-${JMETER_VERSION}"
PROPERTIES_FILE="${JMETER_HOME}/bin/jmeter.properties"

#####################################
# Ensure script is run as root
#####################################

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root:"
    echo "sudo $0"
    exit 1
fi

#####################################
# Install Java
#####################################

echo "Updating package list..."
apt update

echo "Installing Java 21..."
apt install -y ${JAVA_PACKAGE} wget tar

echo "Java version:"
java -version

#####################################
# Download JMeter
#####################################

cd /tmp

echo "Removing any previous download..."
rm -f "${JMETER_ARCHIVE}"

echo "Downloading Apache JMeter ${JMETER_VERSION}..."

wget \
    --show-progress \
    --timeout=30 \
    --tries=3 \
    "${JMETER_URL}"

echo "Verifying archive..."
gzip -t "${JMETER_ARCHIVE}"

#####################################
# Install JMeter
#####################################

echo "Removing previous installation..."
rm -rf "${JMETER_HOME}"

echo "Extracting JMeter..."
tar -xzf "${JMETER_ARCHIVE}" -C "${INSTALL_DIR}"

#####################################
# Detect IP address
#####################################

SERVER_IP=$(ip route get 8.8.8.8 | awk '/src/ {print $7}')

echo "Detected server IP: ${SERVER_IP}"

#####################################
# Configure JMeter
#####################################

echo "Configuring jmeter.properties..."

# Disable SSL
sed -i \
's/^#server\.rmi\.ssl\.disable=false/server.rmi.ssl.disable=true/' \
"${PROPERTIES_FILE}"

# If already exists, replace it
if grep -q "^java.rmi.server.hostname=" "${PROPERTIES_FILE}"; then
    sed -i \
    "s/^java\.rmi\.server\.hostname=.*/java.rmi.server.hostname=${SERVER_IP}/" \
    "${PROPERTIES_FILE}"
else
    echo "" >> "${PROPERTIES_FILE}"
    echo "java.rmi.server.hostname=${SERVER_IP}" >> "${PROPERTIES_FILE}"
fi

#####################################
# Permissions
#####################################

echo "Giving ownership to the current user..."

REAL_USER=${SUDO_USER:-root}

chown -R "${REAL_USER}:${REAL_USER}" "${JMETER_HOME}"

#####################################
# Start JMeter Server
#####################################

echo ""
echo "=========================================="
echo "JMeter Slave Configuration Complete"
echo "=========================================="
echo "IP Address : ${SERVER_IP}"
echo "JMeter Home: ${JMETER_HOME}"
echo ""

cd "${JMETER_HOME}/bin"

echo "Starting JMeter Server..."

exec sudo -u "${REAL_USER}" ./jmeter-server \
    -Djava.rmi.server.hostname="${SERVER_IP}" \
    -Dserver.rmi.ssl.disable=true
