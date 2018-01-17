# Aliases for zsh

alias gsw="git show"
alias gfr="grep -Fr"
alias gfri="grep -Fri"
alias gfp="git format-patch"

# chroot into CentOS (mount it at /centos in fstab)
# For building ancient firmwares
function cent() {
        sudo umount /centos/proc
        sudo umount /centos/dev
        sudo umount /centos/sys
        sudo mount -t proc proc /centos/proc
        sudo mount -o bind /dev /centos/dev
        sudo mount -t sysfs sys /centos/sys
        sudo chroot --userspec=myuser /centos /bin/zsh
}

# Find current wireless phy name, takes no argument
function findphy() {
        CURR_PHY=`iw phy|head -n1|grep -oE 'phy[0-9]+'`
}

# Turn WiFi adapter into monitor mode (ath9k)
# Too lazy to change wlp4s0
# Takes no argument
function wifimon() {
        findphy

        sudo iw phy ${CURR_PHY} interface add mon0 type monitor
        sudo iw dev wlp4s0 del
        sudo ip link set mon0 up
}

# Set the channel to be monitored
# Takes one argument: channel number
function setchan() {
        sudo ip link set mon0 up
        sudo iw dev mon0 set channel $1
}

# Reset WiFi adapter to STA mode
# No argument
function wifires() {
        findphy

        sudo iw dev mon0 del
        sudo iw phy ${CURR_PHY} interface add wlp4s0 type managed
}

# SSH to servers without a persistent host key (e.g. routers)
# Mandatory argument: server IP
function sr() {
        local tgt_ip=$1

        if [ -z "$tgt_ip" ]; then
                tgt_ip=192.168.1.1
        fi

        ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no $tgt_ip:6666
}
