DESTDIR=/
DIR=debian/ossec-hids-server/var/ossec/
OSSEC_INIT=debian/ossec-hids-server/etc/ossec-init.conf

all:
#	(cd src; make setgeoip)
#	sh src/external/unpack.sh
	(cd src; make TARGET=server)	

clean:
	rm bin/* || /bin/true
	mkdir -p ${DIR}/rules/translated/
	chmod 750 ${DIR}
	chmod 750 ${DIR}/*
	chmod 750 ${DIR}/rules/translated/
	chmod 750 ${DIR}/rules/translated/* || /bin/true
	(cd src; make clean)
	rm -f src/Config.OS
	rm -f src/analysisd/compiled_rules/compiled_rules.h
	rm -f src/isbigendian.c
	rm -f src/analysisd/ossec-makelists
	rm -f src/analysisd/ossec-logtest
	rm -f src/isbigendian

install:
	mkdir -p ${DIR}
	mkdir -p debian/ossec-hids-server/etc

	# Create directories
	(cd ${DIR}; mkdir -p .ssh active-response active-response/bin agentless bin etc etc/shared/default etc/lists etc/rootcheck framework/wazuh integrations lib logs logs/alerts logs/archives logs/cluster logs/firewall logs/ossec queue queue/agent-info queue/agent-groups queue/agentless queue/agents queue/alerts queue/cluster queue/db queue/diff queue/fts queue/ossec queue/rids queue/rootcheck queue/syscheck queue/vulnerabilities rules ruleset stats tmp var var/db var/db/agents var/download var/run var/selinux var/upgrade var/wodles wodles)

	# Populate the active-response/ directory
	cp -p active-response/*.sh ${DIR}/active-response/bin/
	cp -p active-response/*.py ${DIR}/active-response/bin/
	cp -p active-response/firewalls/*.sh ${DIR}/active-response/bin/

	# Populate the agentless/ directory
	cp -pr src/agentlessd/scripts/* ${DIR}/agentless/

	# Populate the etc/ directory
	cp -pL /etc/localtime ${DIR}/etc/ 2>/dev/null || /bin/true
	cp -p /etc/TIMEZONE ${DIR}/etc/   2>/dev/null || /bin/true
	cp -pr etc/decoders ${DIR}/etc/
	cp -pr etc/local_decoder.xml ${DIR}/etc/ > /dev/null 2>&1 || /bin/true
	cp -pr etc/local_internal_options.conf ${DIR}/etc/ > /dev/null 2>&1 || /bin/true
	cp -pr etc/client.keys ${DIR}/etc/ > /dev/null 2>&1 ||/bin/true
	cp -pr etc/internal_options.conf ${DIR}/etc/
	cp -pr etc/lists/* ${DIR}/etc/lists/
	cp -pr etc/ossec-securityonion.conf ${DIR}/etc/ossec.conf
	cp -pr src/rootcheck/db/*.txt ${DIR}/etc/rootcheck/
	cp -pr src/rootcheck/db/*.txt ${DIR}/etc/shared/default/
	cp -pr etc/agent.conf ${DIR}/etc/shared/default/

	# Populate the bin/ directory
	cp -pr src/ossec* ${DIR}/bin/
	cp -pr src/manage_agents ${DIR}/bin/
	cp -pr src/syscheck_update ${DIR}/bin/
	cp -pr src/verify-agent-conf ${DIR}/bin/
	cp -pr src/clear_stats ${DIR}/bin/
	cp -pr src/agent_control ${DIR}/bin/
	cp -pr src/syscheck_control ${DIR}/bin/
	cp -pr src/rootcheck_control ${DIR}/bin/
	cp -pr src/wazuh-db ${DIR}/bin/
	cp -pr src/wazuh-modulesd ${DIR}/bin/
	cp -pr contrib/util.sh ${DIR}/bin/
	cp -pr src/init/ossec-server.sh ${DIR}/bin/ossec-control
	cp -pr framework/scripts/agent_groups.py ${DIR}/bin/agent_groups
	cp -pr framework/scripts/agent_upgrade.py ${DIR}/bin/agent_upgrade
	cp -pr framework/scripts/cluster_control.py ${DIR}/bin/cluster_control
	cp -pr framework/scripts/wazuh-clusterd.py ${DIR}/bin/wazuh-clusterd
	cp -pr src/update/ruleset/update_ruleset ${DIR}/bin/update_ruleset
	#cp -pr src/util/list_agents ${DIR}/bin/

	# Populate the framework/wazuh directory
	cp -pr framework/wazuh/* ${DIR}/framework/wazuh/

	# Populate the integrations directory
	cp -pr integrations/* ${DIR}/integrations/

	# Populate the lib/ directory
	cp -pr src/libwazuhext.so ${DIR}/lib/

	# Populate the rules/ directory
	cp -pr etc/rules/* ${DIR}/rules/
	cp -pr etc/local_rules.xml ${DIR}/rules/

	# Populate the ruleset/ directory
	cp -pr src/update/ruleset/RULESET_VERSION ${DIR}/ruleset/VERSION

	# Populate the wodles/ directory
	cp -pr wodles/* ${DIR}/wodles/

	# Populate the init file
	echo "DIRECTORY=\"/var/ossec\"" > ${OSSEC_INIT}
	echo "VERSION=\"v3.6.1\"" >> ${OSSEC_INIT}
	echo "DATE=\"`date`\"" >> ${OSSEC_INIT}
	echo "TYPE=\"server\"" >> ${OSSEC_INIT}
	echo "NAME=\"Wazuh\"" >> ${OSSEC_INIT}
#	(cd etc; wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz; gunzip GeoLiteCity.dat.gz)
#	(cd etc; wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz; gunzip GeoLiteCityv6.dat.gz)





deb:
#	dpkg-buildpackage -us -uc -b
	dpkg-buildpackage -rfakeroot -us -uc -b

debiandir:
	sudo apt-get install build-essential autoconf automake autotools-dev dh-make debhelper devscripts fakeroot xutils lintian pbuilder
	rmdir debian/
	dh_make -e nicolas.zin@savoirfairelinux.com --createorig
