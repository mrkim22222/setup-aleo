#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
	echo ''
else
   apt install curl -y < "/dev/null"
fi

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Aborting: run as root user!"
    exit 1
fi

echo "=================================================="
echo -e 'Setup your worker ...\n' && sleep 1

read -p 'Your worker number: ' worker_number
read -p 'Aleo address:: ' aleo_address

echo "=================================================="
echo -e 'Installing dependencies...\n' && sleep 1
apt-get update >> install_tool.log
apt-get install make clang pkg-config libssl-dev build-essential gcc xz-utils git curl vim tmux ntp jq llvm ufw htop iftop -y >> install_tool.log
apt-get install linux-headers-$(uname -r)

echo "=================================================="
echo -e 'Installing cuda...\n' && sleep 1
apt-key del 7fa2af80
wget -q -O cuda-keyring_1.0-1_all.deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
dpkg -i cuda-keyring_1.0-1_all.deb >> install_tool.log

echo "-----------------------"
echo -e 'Updating repository...\n' && sleep 1
apt-get update >> install_tool.log

echo "-----------------------"
echo -e 'Install cuda lib ...\n' && sleep 1
apt-get install cuda -y >> install_tool.log

echo -e 'Update enviroment ...\n' && sleep 1
echo "export PATH=/usr/local/cuda-11.8/bin${PATH:+:${PATH}}" >> $HOME/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> $HOME/.bashrc
source $HOME/.bashrc

echo "=================================================="
echo -e 'Install DamoMiner tool ...\n' && sleep 1
mkdir $HOME/aleo-pool-damominer
cd $HOME/aleo-pool-damominer

echo -e 'Downloading tool ...\n'
wget -q -O damominer_linux_v2.0.0.tar https://github.com/damomine/aleominer/releases/download/damominer_linux_v2.0.0/damominer_linux_v2.0.0.tar
tar -xf damominer_linux_v2.0.0.tar
echo -e 'Download done!'

echo -e 'Update file: run_gpu.sh ...\n'
rm -f $HOME/aleo-pool-damominer/run_gpu.sh
echo "
#!/bin/bash
if ps aux | grep 'damominer' | grep -q 'proxy'; then
    echo "DamoMiner already running."
    exit 1
else
    nohup $HOME/aleo-pool-damominer/damominer --address $aleo_address --proxy aleo3.damominer.hk:9090 --worker worker_$worker_number >> aleo.log 2>&1 &
fi
" > $HOME/aleo-pool-damominer/run_gpu.sh

chmod +x $HOME/aleo-pool-damominer/run_gpu.sh
chmod +x $HOME/aleo-pool-damominer/damominer

echo "=================================================="
echo -e 'Setup finished \n' && sleep 1
echo -e "Reboot your system and run file: $HOME/aleo-pool-damominer/run_gpu.sh with root and RUN: \n"
echo -e "sudo $HOME/aleo-pool-damominer/run_gpu.sh \n"
echo -e "OR \n"
echo -e "cd $HOME/aleo-pool-damominer/"
echo -e "sudo ./run_gpu.sh \n"
