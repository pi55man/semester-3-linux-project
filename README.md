## semester-3-linux-project

tool to monitor a file for integrity changes.

Usage
- `chmod +x int.sh`
- `./int.sh /full/path/to/file`

Behavior
- Hashes saved to: `$HOME/integrity.cache`
- Daily cron (22:00) appends runs to: `$HOME/integrity-report.log`

Requirements: `sha256sum`, `awk`, `grep`, `crontab`


