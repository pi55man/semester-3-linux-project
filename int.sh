#!/usr/bin/env bash

CACHE_FILE="$HOME/integrity.cache"
FILE="$1"

touch "$CACHE_FILE"

CUR_HASH=$(sha256sum "$FILE" | awk '{print $1}')

LINE=$(grep -F "  $FILE" "$CACHE_FILE")

if [ -z "$LINE" ]; then
    echo "$CUR_HASH  $FILE" >> "$CACHE_FILE"
    echo "[ADDED] $FILE → $CUR_HASH"
else
    OLD_HASH=$(echo "$LINE" | awk '{print $1}')
    if [ "$CUR_HASH" = "$OLD_HASH" ]; then
        echo "[OK] $FILE unchanged"
    else
        echo "[WARNING] $FILE modified!"
        echo "   old: $OLD_HASH"
        echo "   new: $CUR_HASH"
    fi
fi

if ! crontab -l 2>/dev/null | grep -q "int.sh $FILE"; then
    (crontab -l 2>/dev/null; \
     echo "0 22 * * * $HOME/semester-3-linux-project/int.sh $FILE >> $HOME/integrity-report.log 2>&1") | crontab -
    echo "[CRON] Daily check scheduled at 10:00 PM for $FILE"
    echo "       Report will be saved to $HOME/integrity-report.log"
fi
