
urlGetPath() {
    SERVICE="`echo $1 | grep '://' | sed -e's,^\(.*://\).*,\1,g'`"
    if [[ ! -z $SERVICE ]]; then
        echo "/"$1 | sed -e s,$SERVICE,,g
    fi
}
