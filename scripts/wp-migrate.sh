source "$PWD/inc/_includes.sh"

PRINT_FEEDBACK="yes"
P1=$1
P2=$2
P3=$3

for last; do true; done
if [ "--now" == "$last" ]; then
    PRINT_FEEDBACK="no"
    [ "$P1" == "$last" ] && P1=""
    [ "$P2" == "$last" ] && P2=""
    [ "$P3" == "$last" ] && P3=""
fi

BACKUP_DELAY=${BACKUP_DELAY:-3}
MYSQL_HOST=${MYSQL_HOST:-mysql}
MYSQL_USER=${MYSQL_USER:-root}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-root}

MYSQL_DB=${P3:-$MYSQL_DB}
MYSQL_DB=${MYSQL_DB:-wordpress}

WP_MIGRATE_FROM=${P1:-WP_MIGRATE_FROM}
WP_MIGRATE_TO=${P2:-WP_MIGRATE_TO}


# Handle custom host
CUSTOM_HOST="`echo $MYSQL_DB | grep '://' | sed -e's,^\(.*://\).*,\1,g'`"
if [[ ! -z $CUSTOM_HOST ]]; then
    MYSQL_HOST="${CUSTOM_HOST%???}"
    MYSQL_DB=`echo $MYSQL_DB | sed -e s,$CUSTOM_HOST,,g`
fi

if [ "$PRINT_FEEDBACK" == "yes" ]; then
    echo "======== WP-MIGRATE ========"
    echo "host:      $MYSQL_HOST"
    echo "user:      $MYSQL_USER"
    echo "password:  $MYSQL_PASSWORD"
    echo "database:  $MYSQL_DB"
    echo "wp-from:   $WP_MIGRATE_FROM"
    echo "wp-to:     $WP_MIGRATE_TO"
    echo ""
    enterToContinue
    echo ""
    echo ""
fi

[ "$PRINT_FEEDBACK" == "yes" ] && echo "---> migrating database..."
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB -e  "UPDATE wp_options SET option_value = replace(option_value, '${WP_MIGRATE_FROM}', '${WP_MIGRATE_TO}') WHERE option_name = 'home' OR option_name = 'siteurl';"
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB -e  "UPDATE wp_posts SET guid = replace(guid, '${WP_MIGRATE_FROM}','${WP_MIGRATE_TO}');"
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB -e  "UPDATE wp_posts SET post_content = replace(post_content, '${WP_MIGRATE_FROM}', '${WP_MIGRATE_TO}');"
mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB -e  "UPDATE wp_postmeta SET meta_value = replace(meta_value,'${WP_MIGRATE_FROM}','${WP_MIGRATE_TO}');"

if [ "$PRINT_FEEDBACK" == "yes" ]; then
    echo "migration completed."
    echo ""
    echo ""
    echo ""
fi
exit
