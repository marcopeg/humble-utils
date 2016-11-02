#
# mysql-create-db
#

MYSQL_HOST=${MYSQL_HOST:-mysql}
MYSQL_USER=${MYSQL_USER:-root}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-root}

MYSQL_DB=${1:-$MYSQL_DB}
MYSQL_DB=${MYSQL_DB:-wordpress}

MYSQL_DB_CREATE_CHARSET=${2:-"utf8"}
MYSQL_DB_CREATE_FORCE=${MYSQL_DB_CREATE_FORCE:-"no"}

# Accept "--force" as last option
for LAST_P; do true; done
[ "--force" == "$LAST_P" ] && MYSQL_DB_CREATE_FORCE="yes"
[ "--force" == "$MYSQL_DB_CREATE_CHARSET" ] && MYSQL_DB_CREATE_CHARSET="utf8"

# Get explicit custom host from the command line
CUSTOM_HOST="`echo $MYSQL_DB | grep '://' | sed -e's,^\(.*://\).*,\1,g'`"
if [[ ! -z $CUSTOM_HOST ]]; then
    MYSQL_HOST="${CUSTOM_HOST%???}"
    MYSQL_DB=`echo $MYSQL_DB | sed -e s,$CUSTOM_HOST,,g`
fi

echo ""
echo "======== MYSQL CREATE DB ========"
echo "host:      $MYSQL_HOST"
echo "user:      $MYSQL_USER"
echo "password:  $MYSQL_PASSWORD"
echo "database:  $MYSQL_DB"
echo "charset:   $MYSQL_DB_CREATE_CHARSET"
echo "force:     $MYSQL_DB_CREATE_FORCE"
echo ""
echo "(sleeping 3 secs, you can abort with Ctrl+c)"
sleep 3
echo ""
echo ""

# Drop existing database
if [ "yes" == "$MYSQL_DB_CREATE_FORCE" ]; then
    mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD -e "DROP DATABASE IF EXISTS ${MYSQL_DB};"
fi

# Create new database
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE DATABASE ${MYSQL_DB} /*\!40100 DEFAULT CHARACTER SET $MYSQL_DB_CREATE_CHARSET */;"
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB -e "show databases;"

echo "---> mysql-seed complete!"
echo ""
echo ""
exit
