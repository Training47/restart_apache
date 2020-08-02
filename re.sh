#!/bin/bash
CONFIG="$1"
COMMAND="$2"

#Is first parameter an actual host
FILEMATCH = false
#A concatenated string of virtual hosts
VALID_HOSTS = ''
#Grab a list of all virtual-host files
# List all of the configuration files in the _/etc/apache2/sites-available/_ directory
VHOSTS =/etc/apache2/sites-available/*.conf

if [ $# -ne 2 ]
then
echo -e "\[31mERROR:${0} requires \e [im\e[33mtwo\e[0m\e[31mparameters\e
[0m \n * a virtual-host {configuration \n *a service command"
exit 1
fi
#Loop through all the files in the sites-available directory
#Build list of filenames to display in error message
#If match found, set $FILEMATCH to true and stop build the list
for FILENAME in $VHOSTS
do
VHOST = "${FILENAME:29: -5}"
if [-z "$VALID_VHOSTS"]
then
VALID_HOSTS = "\n * $VHOST"
else
VALID_HOSTS = "${VALID_VHOSTS} \n * $VHOST"
fi

if ["$FILENAME"== "/etc/apache2/sites-available/${CONFIG}.conf"]
then
#Set #FILEMATCH to true if one of those files matches an actual
#virtual-host configuration and break the loop
$FILEMATCH = true
break
fi
done
#No match for first argument to virtual-host present user with error
if [$FILEMATCH == false]
then
echo -e "\e [31mERROR:\e[0m \e [im \e [33m${CONFIG} \e [0m \e [31mis
not a valid virtual-host \e [0m \nPlease choose from the following ${VALID_VHOSTS}"
exit 1
fi
  
#only allow reload or restart.
if [ "$COMMAND" == "reload" ] || [ "$COMMAND" == "restart" ]
then
    # Move the current execution state to the proper directory
    cd /etc/apache2/sites-available

    # Disable a vhost configuration
    sudo a2dissite "$CONFIG"
    sudo service apache2 "$COMMAND"

    # Enable a vhost configuration
    sudo a2ensite "$CONFIG"
    sudo service apache2 "$COMMAND"
else
    echo -e "\e [31mERROR: \e [0m \e [im \e [33m ${COMMAND} \e
    [0m \e [31mis NOT a valid service command \e [0m \nPlease choose
    from the following \n * restart \n *reload"
exit 1
fi
    











