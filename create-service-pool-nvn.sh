#!/bin/bash
# Must remove nohup in file: /app/run_pool_nghiepnv.sh

echo -e 'Creating a service for Aleo Prover Pool NVN...\n' && sleep 1
echo "[Unit]
Description=Aleo Prover Pool NVN
After=network-online.target

[Service]
#User=$my_user_name
ExecStart=/bin/bash /app/run_pool_nghiepnv.sh
Restart=always
RestartSec=60
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
" > $HOME/aleo-pool-nvn.service
# mv $HOME/aleo-pool-nvn.service /etc/systemd/system
mkdir -p $HOME/.config/systemd/user/
mv $HOME/aleo-pool-nvn.service $HOME/.config/systemd/user/aleo-pool-nvn.service

#echo -e 'Service path: /etc/systemd/system/aleo-pool-nvn.service'
echo -e 'Service path: $HOME/.config/systemd/user/aleo-pool-nvn.service'
systemctl --user daemon-reload

echo -e '\nRuning Aleo Prover Pool\n' && sleep 1
systemctl --user enable aleo-pool-nvn
systemctl --user restart aleo-pool-nvn


echo -e "Your Aleo Prover Node installed and works!"
echo -e "You can check node status by the command systemctl --user status aleo-pool-nvn"
echo -e "You can check Aleo Prover Node logs by the command journalctl --user -u aleo-pool-nvn -f -o cat"
echo -e "Press ctrl+c for exit from logs"
