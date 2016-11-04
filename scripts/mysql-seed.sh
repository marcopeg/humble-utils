#
# mysql-seed
#

source "$PWD/inc/_includes.sh"

PRINT_FEEDBACK="yes"
P1=$1
P2=$2

for last; do true; done
if [ "--now" == "$last" ]; then
    PRINT_FEEDBACK="no"
    [ "$P1" == "$last" ] && P1=""
    [ "$P2" == "$last" ] && P2=""
fi

BACKUP_ROOT=${BACKUP_ROOT:-"backup"}
MYSQL_USER=${MYSQL_USER:-"root"}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-"root"}

# Compose target database
MYSQL_DB=${P2:-$MYSQL_DB}

# Compose source backup
MYSQL_SEED_FILE_PATH="/$BACKUP_ROOT/$P1"
MYSQL_SEED_FORMAT="${MYSQL_SEED_FILE_PATH##*.}"

# Get target database name from file dump (___ as separatpr)
if [[ "" == "$MYSQL_DB" ]]; then
    MYSQL_DB=$(basename "$MYSQL_SEED_FILE_PATH")
    MYSQL_DB="`echo $MYSQL_DB | grep '___' | sed -e's,^\(.*___\).*,\1,g'`"
    MYSQL_DB="${MYSQL_DB%???}"
    MYSQL_DB=$(echo $MYSQL_DB | tr . /)
    MYSQL_DB="${MYSQL_DB/___/://}"
fi


# Get explicit custom host from the command line
CUSTOM_HOST="`echo $MYSQL_DB | grep '://' | sed -e's,^\(.*://\).*,\1,g'`"
if [[ ! -z $CUSTOM_HOST ]]; then
    MYSQL_HOST="${CUSTOM_HOST%???}"
    MYSQL_DB=`echo $MYSQL_DB | sed -e s,$CUSTOM_HOST,,g`
fi

# Default database name
MYSQL_HOST=${MYSQL_HOST:-"mysql"}
MYSQL_DB=${MYSQL_DB:-"wordpress"}


if [ "$PRINT_FEEDBACK" == "yes" ]; then
    echo ""
    echo "======== MYSQL SEED ========"
    if [ ! -f $MYSQL_SEED_FILE_PATH ]; then
        echo "source file not found!"
        echo "($MYSQL_SEED_FILE_PATH)"
        echo ""
        exit
    fi
    echo "host:      $MYSQL_HOST"
    echo "user:      $MYSQL_USER"
    echo "password:  $MYSQL_PASSWORD"
    echo "source:    $MYSQL_SEED_FILE_PATH"
    echo "target:    $MYSQL_DB"
    echo "format:    $MYSQL_SEED_FORMAT"
    echo ""
    enterToContinue
    echo ""
    echo ""
fi

[ "$PRINT_FEEDBACK" == "yes" ] && echo "---> seeding data..."
if [[ $MYSQL_SEED_FORMAT == "gz" ]]; then
    zcat "$MYSQL_SEED_FILE_PATH" | mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB;
else
    mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB < $MYSQL_SEED_FILE_PATH;
fi

if [ "$PRINT_FEEDBACK" == "yes" ]; then
    mysql -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB -e "show tables;"
    echo "---> mysql-seed complete!"
    echo ""
    echo ""
fi
exit
