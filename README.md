# setup-aleo

## 1. Pool DamoMiner

`wget -q -O setup-pool-damominer.sh https://raw.githubusercontent.com/mrkim22222/setup-aleo/main/setup-pool-damominer.sh && chmod +x setup-pool-damominer.sh && sudo /bin/bash setup-pool-damominer.sh`


## 2. Pool NVN

### 2.1: Install, run via nohup
wget -q -O setup-pool-nvn.sh https://raw.githubusercontent.com/mrkim22222/setup-aleo/main/setup-pool-nvn.sh && chmod +x setup-pool-nvn.sh && sudo /bin/bash setup-pool-nvn.sh

### 2.2 Kill service: 
Create script:
```
#!/bin/sh
SERVICE='aleo-prover'

if ps ax | grep -v grep | grep $SERVICE > /dev/null
then
    echo "$SERVICE service running, killing --> $SERVICE"
    kill $(ps -AF | grep $SERVICE | grep -v grep | awk '{print $2}')
else
    echo "$SERVICE is not running"
fi
```

### 2.3: Create service for start with OS

This service run without root

Refer:
[Service Pool NVN](https://github.com/mrkim22222/setup-aleo/blob/main/create-service-pool-nvn.sh).

Command: 
- Start: ```systemctl --user start aleo-pool-nvn```
- Stop: ```systemctl --user stop aleo-pool-nvn```
- Status: ```systemctl --user status aleo-pool-nvn```
- Check Log: ```journalctl --user -u aleo-pool-nvn -f -o cat```
- Enable: ```systemctl --user enable aleo-pool-nvn```
- Disable: ```systemctl --user disable aleo-pool-nvn```
- Restart: ```systemctl --user restart aleo-pool-nvn```

