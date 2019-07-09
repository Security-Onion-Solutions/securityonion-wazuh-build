#!/bin/bash

echo "This quick and dirty script will build an ossec-hids-server package using a Wazuh tarball."
echo
echo "What version would you like to build?  (Example: 3.9.3)"
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

# Update SRCMAKEFILE
SRCMAKEFILE="ossec-hids-server-${VERSION}.${REVISION}/src/Makefile"
# redirect the python build to /tmp
sed -i 's|WPYTHON_DIR := ${PREFIX}/framework/python|WPYTHON_DIR := /tmp/wpython|g' $SRCMAKEFILE
# Change find/link to copy
sed -i 's|find ${WPYTHON_DIR}.*$|cp libwazuhext.so /tmp/wpython/lib|g' $SRCMAKEFILE
# tell binaries where to find the libraries
sed -i 's|cd ../framework &&|cd ../framework && LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tmp/wpython/lib|g' $SRCMAKEFILE

# Make new tarball
tar zcvf ossec-hids-server-${VERSION}.${REVISION}.tar.gz ossec-hids-server-${VERSION}.${REVISION}
cp ossec-hids-server-${VERSION}.${REVISION}.tar.gz ossec-hids-server_${VERSION}.${REVISION}.orig.tar.gz

# Copy files
cp -av ../files/* ossec-hids-server-${VERSION}.${REVISION}/

# Update version in Makefile, preinst, and postinst
sed -i "s|vX.Y.Z|v${VERSION}|g" ossec-hids-server-${VERSION}.${REVISION}/Makefile
sed -i "s|X.Y.Z|${VERSION}|g" ossec-hids-server-${VERSION}.${REVISION}/debian/ossec-hids-server.p*inst

# update changelog
cd ossec-hids-server-${VERSION}.${REVISION}
dch --newversion ${VERSION}.${REVISION}

# Build source package
debuild -S -sa

# Upload source package
cd ..
dput ppa:doug-burks/wazuh ossec-hids-server_${VERSION}.${REVISION}*source.changes
