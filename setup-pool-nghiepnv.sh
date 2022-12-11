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

POOL_ADDRESS=51.222.44.165:9090

echo "=================================================="
echo -e 'Setup your aleo address ...\n' && sleep 1

read -p 'Aleo address: ' aleo_address

echo "=================================================="
echo -e 'Installing dependencies...\n' && sleep 1
apt update >> install-node.log
apt install make clang pkg-config libssl-dev build-essential gcc xz-utils git curl vim tmux ntp jq llvm ufw -y --no-install-recommends >> install-node.log
echo "=================================================="



if [ $SUDO_USER ]; then my_user_name=$SUDO_USER; else my_user_name=`whoami`; fi
# or use: 
#[ $SUDO_USER ] && my_user_name=$SUDO_USER || my_user_name=`whoami`

my_home_dir=`sudo -u $my_user_name -H bash -c 'echo $HOME'`

BASE_DIR="/app"
mkdir $BASE_DIR

cd $BASE_DIR

POOL_NGHIEPNV_DIR="aleo-pool-nghiepnv"

echo -e 'Clone project ...\n' && sleep 1

git clone https://github.com/HarukaMa/aleo-prover -b testnet3-new $POOL_NGHIEPNV_DIR >> install_node.log
cd $POOL_NGHIEPNV_DIR

INSTALL_DIR=$BASE_DIR/$POOL_NGHIEPNV_DIR

cd $INSTALL_DIR

echo -e 'Build project ...\n' && sleep 1
cargo build --release >> install_node.log

echo -e 'Built DONE!' && sleep 1

echo -e 'Seting up execute file ...' && sleep 1
echo "
#!/bin/bash
if ps aux | grep 'aleo-prover' | grep -v 'grep'; then
    echo "Aleo Miner already running."
    exit 1
else
    nohup $INSTALL_DIR/target/release/aleo-prover -a $aleo_address -p $POOL_ADDRESS >> aleo_pool_nghiepnv.log 2>&1 &
fi
"> $BASE_DIR/run_pool_nghiepnv.sh


chmod +x $INSTALL_DIR/target/release/aleo-prover
chmod +x $BASE_DIR/run_pool_nghiepnv.sh

chown -R $my_user_name:$my_user_name $INSTALL_DIR
chown $my_user_name:$my_user_name $BASE_DIR/run_pool_nghiepnv.sh
chown $my_user_name:$my_user_name $BASE_DIR/install_node.log

echo -e 'Finish!!!' && sleep 1


