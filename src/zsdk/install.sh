#!/bin/bash
set -e

echo "Installing Zephyr SDK feature."
echo "Zephyr SDK version: ${SDK_VERSION}"

# Set environment variables
ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk-${SDK_VERSION}
ZEPHYR_SDK_DOWNLOAD_URL_BASE=https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${SDK_VERSION}
ZEPHYR_SDK_HOST_TOOLS_FILENAME=hosttools_linux-x86_64.tar.xz
ZEPHYR_SDK_MINIMAL_FILENAME=zephyr-sdk-${SDK_VERSION}_linux-x86_64_minimal.tar.xz

# Download and extract the SDK (This works for SDK releases 0.14.1 and up)
mkdir -p ${ZEPHYR_SDK_INSTALL_DIR}
wget --show-progress ${ZEPHYR_SDK_DOWNLOAD_URL_BASE}/${ZEPHYR_SDK_MINIMAL_FILENAME} -O ${ZEPHYR_SDK_INSTALL_DIR}/${ZEPHYR_SDK_MINIMAL_FILENAME}
tar --strip-components=1 -C ${ZEPHYR_SDK_INSTALL_DIR} -xzf ${ZEPHYR_SDK_INSTALL_DIR}/${ZEPHYR_SDK_MINIMAL_FILENAME}
# Remove the downloaded tarball
rm ${ZEPHYR_SDK_INSTALL_DIR}/${ZEPHYR_SDK_MINIMAL_FILENAME}

cd ${ZEPHYR_SDK_INSTALL_DIR}


# Install the individual SDK toolchains
# Parse the TOOLCHAINS environment variable
IFS=',' read -ra TOOLCHAINS_ARRAY <<< "$TOOLCHAINS"

# Iterate over the toolchains and call the shell script to download & extract them
for toolchain in "${TOOLCHAINS_ARRAY[@]}"; do
    ./setup.sh -t ${toolchain}
done

# Check if HOST_TOOLS is set to true and then call the setup script again to install them
if [ "$HOST_TOOLS" = "true" ]; then
    wget --show-progress ${ZEPHYR_SDK_DOWNLOAD_URL_BASE}/${ZEPHYR_SDK_HOST_TOOLS_FILENAME} -O ${ZEPHYR_SDK_INSTALL_DIR}/${ZEPHYR_SDK_HOST_TOOLS_FILENAME}
    tar --strip-components=1 -C ${ZEPHYR_SDK_INSTALL_DIR} -xzf ${ZEPHYR_SDK_INSTALL_DIR}/${ZEPHYR_SDK_HOST_TOOLS_FILENAME}
    # Remove the downloaded tarball
    rm ${ZEPHYR_SDK_INSTALL_DIR}/${ZEPHYR_SDK_HOST_TOOLS_FILENAME}
    ./setup.sh -h
fi

# Register the Zephyr CMake package. This requires that a feature / base image that contains CMake
./setup.sh -c
