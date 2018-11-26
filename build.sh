#!/bin/bash

echo "This quick and dirty script will build an ossec-hids-server package using a Wazuh tarball."
echo
echo "What version would you like to build?  (Example: 3.7.0)"
read VERSION
echo "What revision is this?  (Example: 2)"
read REVISION
echo "If there is an existing ${VERSION} directory, it will be removed."
echo "Press Enter to continue or Ctrl-c to cancel."
read INPUT

# Create a directory for this new version
rm -rf ${VERSION}
mkdir ${VERSION}
cd ${VERSION}

# Download and decompress
wget https://github.com/wazuh/wazuh/archive/v${VERSION}.tar.gz
tar zxvf v${VERSION}.tar.gz

# Rename wazuh to ossec and include REVISION
mv wazuh-${VERSION} ossec-hids-server-${VERSION}.${REVISION}

# Download dependencies
cd ossec-hids-server-${VERSION}.${REVISION}/src
make deps
cd ../..

# Make new tarball
tar zcvf ossec-hids-server-${VERSION}.${REVISION}.tar.gz ossec-hids-server-${VERSION}.${REVISION}
cp ossec-hids-server-${VERSION}.${REVISION}.tar.gz ossec-hids-server_${VERSION}.${REVISION}.orig.tar.gz

# Copy files
cp -av ../files/* ossec-hids-server-${VERSION}.${REVISION}/

# Update version in Makefile
sed -i "s|v3.6.1|v${VERSION}|g" ossec-hids-server-${VERSION}.${REVISION}/Makefile

# update changelog
cd ossec-hids-server-${VERSION}.${REVISION}
dch --newversion ${VERSION}.${REVISION}

# Build source package
debuild -S -sa

# Upload source package
cd ..
dput ppa:doug-burks/xenial ossec-hids-server_${VERSION}.${REVISION}*source.changes
