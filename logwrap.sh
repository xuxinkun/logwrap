#!/usr/bin/env bash
LOGWRAP_ENABLE_LOGWRAP=${LOGWRAP_ENABLE_LOGWRAP:=true}
LOGWRAP_ENABLE_LOGROTATE=${LOGWRAP_ENABLE_LOGROTATE:=true}
LOGWRAP_ENABLE_STDERR=${LOGWRAP_ENABLE_STDERR:=true}
LOGWRAP_LOGROTATE_ROTATE=${LOGWRAP_LOGROTATE_ROTATE:=4}
LOGWRAP_LOGROTATE_CYCLE=${LOGWRAP_LOGROTATE_CYCLE:=weekly}
LOGWRAP_LOGROTATE_SIZE=${LOGWRAP_LOGROTATE_SIZE:=100M}
LOGWRAP_COMMAND=${LOGWRAP_COMMAND:=$1}
LOGWRAP_WHOLECOMMAND=${LOGWRAP_WHOLECOMMAND:=$@}
LOGWRAP_FILE=${LOGWRAP_FILE:=/home/$LOGWRAP_COMMAND.log}


function gen_logroate_file() {
    echo "LOGWRAP_COMMAND is" ${LOGWRAP_COMMAND}
    LOGWRAP_LOGROATE_FILE="/etc/logrotate.d/$LOGWRAP_COMMAND"
    echo "LOGROATE_FILE is" ${LOGWRAP_LOGROATE_FILE}
    if [[ ! -f "$LOGWRAP_LOGROATE_FILE" ]];then
    echo ${LOGWRAP_LOGROATE_FILE} "does not exist. Generate it."

    cat >> $LOGWRAP_LOGROATE_FILE <<EOF
    $LOGWRAP_FILE {
            $LOGWRAP_LOGROTATE_CYCLE
            missingok
            rotate $LOGWRAP_LOGROTATE_ROTATE
            compress
            delaycompress
            dateext
            dateformat %Y-%m-%d-%s
            copytruncate
            size $LOGWRAP_LOGROTATE_SIZE
    }
EOF
else
    echo ${LOGWRAP_LOGROATE_FILE} "alreay exist."
fi

cat ${LOGWRAP_LOGROATE_FILE}
}

function ensure_file_dir() {
    echo "LOGWRAP will direct stdout to" ${LOGWRAP_FILE}
    LOG_DIR=`dirname ${LOGWRAP_FILE}`
    echo "LOGWRAP ensure log dir" ${LOG_DIR}
    mkdir -p $LOG_DIR
}

function start_command() {
    echo exec command: ${LOGWRAP_WHOLECOMMAND}
    echo "--------------------"
}


if [[ "$LOGWRAP_ENABLE_LOGWRAP" == "true" ]];then
    ensure_file_dir

    if [[ "$LOGWRAP_ENABLE_LOGROTATE" == "true" ]];then
        echo "LOGWRAP enable logrotate."
        count=`ps -ef |grep crond |grep -v "grep" |wc -l`
        if [[ 0 == ${count} ]];then
            echo "LOGWRAP start crond."
            crond
        else
            echo "LOGWRAP found crond alreay running."
        fi

        echo "LOGWRAP generate logrotate file."
        gen_logroate_file
    fi

    if [[ "$LOGWRAP_ENABLE_STDERR" == "true" ]];then
        start_command
        exec ${LOGWRAP_WHOLECOMMAND} &>> ${LOGWRAP_FILE}
    else
        start_command
        exec ${LOGWRAP_WHOLECOMMAND} >> ${LOGWRAP_FILE}
    fi
else
    start_command
    exec ${LOGWRAP_WHOLECOMMAND}
fi