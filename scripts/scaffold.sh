#
# Should list all the available scripts
#

SCAFFOLD_NAME=$1

if [[ -z $SCAFFOLD_NAME ]]; then
    echo "=============================="
    echo ">>> Docker Humble Scaffold <<<"
    echo "args: $@"
    echo "=============================="
    echo ""
    echo ""
    echo "Available Templates:"
    (cd /scaffold && ls -l)
    echo ""
    echo ""
    exit 0
fi

echo "Run: $SCAFFOLD_NAME"
source /scaffold/$SCAFFOLD_NAME.sh
