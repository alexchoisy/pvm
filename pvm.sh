#!/bin/bash

ROOT_UID=0

if [ $UID != $ROOT_UID ]; then
	echo "You need to use root privileges to start this command"
	exit 1
fi

echo "Modified"
echo "Welcome to Php Version Manager (PVM)"
echo "Installed Php versions : "

CPT=0

CURRENT_VERSION=$(php -r "echo floor(PHP_VERSION_ID/10000).'.'.intval(substr(''.PHP_VERSION_ID, -4, 2)).'.'.intval(substr(''.PHP_VERSION_ID, -2));")

for PHP_COMMAND in $(ls -1 /usr/bin/ | grep -E "^php[0-9\.]+$")
do
	PHP_VERSION=$(eval "$PHP_COMMAND -r \"echo floor(PHP_VERSION_ID/10000).'.'.intval(substr(''.PHP_VERSION_ID, -4, 2)).'.'.intval(substr(''.PHP_VERSION_ID, -2));\"")
	if [ $PHP_VERSION == $CURRENT_VERSION ]; then
		echo " [*] $PHP_VERSION"
		PHP_CURRENT=$CPT
	else
		echo " [ ] $PHP_VERSION"
		DEFAULT_VERSION=$PHP_VERSION
		DEFAULT_COMMAND=$CPT
	fi
	ARRAY_VERSIONS[$CPT]=$PHP_VERSION
	ARRAY_COMMANDS[$CPT]=$PHP_COMMAND
	CPT=$(($CPT+1))
done

if [ ${#ARRAY_VERSIONS[@]} -lt 2 ]; then
	echo " Vous n'avez qu'une version de Php installée sur votre système"
	exit 0
fi

PHP_TARGET_CHOSEN=false

while [ $PHP_TARGET_CHOSEN == false ]; do
	echo -n "Enter target PHP version [$DEFAULT_VERSION] :"
	read PHP_TARGET
	if [[ -z "$PHP_TARGET" ]]; then
		PHP_TARGET=$DEFAULT_COMMAND
		PHP_TARGET_CHOSEN=true
	else
		for i in "${!ARRAY_VERSIONS[@]}"; do
			if [ "${ARRAY_VERSIONS[$i]}" == $PHP_TARGET ]; then
				PHP_TARGET=$i
				PHP_TARGET_CHOSEN=true
				break
			fi
		done	
	fi	
done

# Now its time to swap out symbolic links
echo "Switching links for PHP CLI"
ln -sf /usr/bin/${ARRAY_COMMANDS[$PHP_TARGET]} /etc/alternatives/php
ln -sf /etc/alternatives/php /usr/bin/php
ln -sf /etc/alternatives/php /usr/local/bin/php
echo "Switching Apache's PHP modules"
a2dismod ${ARRAY_COMMANDS[$PHP_CURRENT]} > /dev/null 2>&1
a2enmod ${ARRAY_COMMANDS[$PHP_TARGET]} > /dev/null 2>&1
echo "Restarting Apache2"
service apache2 restart
echo "Success : You can use PHP in version ${ARRAY_VERSIONS[$PHP_TARGET]}"
