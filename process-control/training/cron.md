# A cron job to print current date and save it to a file

Here we've created a cron job that runs every 5 minutes and prints the current date and time to the console. It also saves the date and time to a file called `current-date.txt`.
We've put everything in a bash script called `current-date.sh` and made it executable.

```bash
#!/bin/bash

echo "Current date and time: $(date)" >> current-date.txt
echo "Current date and time: $(date)"
```
    
```bash
chmod +x current-date.sh
```

```bash
crontab -e
```

Then edit the configuration file to create a new cron job that runs every 5 minutes:

```bash
*/5 * * * * /path/to/current-date.sh
```

```bash
crontab -l

*/5 * * * * /path/to/current-date.sh
```

Here's what the file `current-date.txt` looks like after a few runs:

```bash
cat current-date.txt
Current date and time: 06 mars 2024 17:08:01 CET
Current date and time: 06 mars 2024 17:13:01 CET
Current date and time: 06 mars 2024 17:18:01 CET
Current date and time: 06 mars 2024 17:23:01 CET
```
