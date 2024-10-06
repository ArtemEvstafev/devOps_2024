#!/bin/bash

PID_FILE="disk_monitor.pid"
LOG_DIR="./disk_monitor"
INTERVAL_IN_SEC=$((60 * 1))

create_csv_file() {
    TIMESTAMP=$(date +"%Y-%m-%d_%H:%M:%S")
    DATE=$(date +"%Y-%m-%d")
    CSV_FILE="${LOG_DIR}/disk_usage_${TIMESTAMP}_${DATE}.csv"
    echo "timestamp,disk_usage,inodes_free" > "$CSV_FILE"
    echo "$CSV_FILE"
}

monitor_disk_usage() {
    CSV_FILE=$(create_csv_file)
    CURRENT_DATE=$(date +"%Y-%m-%d")

    while true; do
        NEW_DATE=$(date +"%Y-%m-%d")
        if [[ "$NEW_DATE" != "$CURRENT_DATE" ]]; then
            CSV_FILE=$(create_csv_file)
            CURRENT_DATE="$NEW_DATE"
        fi
        
        # if [ -f "" ]

        TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
        DISK_USAGE=$(df / | awk 'NR==2 {print $5}')
        INODES_FREE=$(df -i / | awk 'NR==2 {print $4}')

        echo "$TIMESTAMP,$DISK_USAGE,$INODES_FREE" >> "$CSV_FILE"
        sleep "$INTERVAL_IN_SEC"
    done
}

start_monitoring() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "Мониторинг уже запущен с PID $(cat "$PID_FILE")"
    else
        echo "Запуск мониторинга..."
        mkdir -p "$LOG_DIR"
        monitor_disk_usage &
        echo $! > "$PID_FILE"
        echo "Мониторинг запущен с PID $(cat "$PID_FILE")"
    fi
}

check_status() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "Мониторинг запущен с PID $(cat "$PID_FILE")"
    else
        echo "Мониторинг не запущен"
    fi
}

stop_monitoring() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "Остановка мониторинга с PID $(cat "$PID_FILE")..."
        kill $(cat "$PID_FILE")
        rm -f "$PID_FILE"
        echo "Мониторинг остановлен"
    else
        echo "Мониторинг не запущен"
    fi
}

case "$1" in
    START)
        start_monitoring
        ;;
    STATUS)
        check_status
        ;;
    STOP)
        stop_monitoring
        ;;
    *)
        echo "Использование: $0 {START|STOP|STATUS}"
        exit 1
        ;;
esac

