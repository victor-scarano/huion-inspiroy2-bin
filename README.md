# huion-inspiroy-bin

My scuffed Nix packaging of the Huion Inspiroy 2 S M L pen tablet.

## TODO:

chmod +0777 /usr/lib/huiontablet/huionCore.sh
chmod +0777 /usr/lib/huiontablet/huionCore
chmod +0777 /usr/lib/huiontablet/huiontablet 
chmod 0777 /usr/lib/huiontablet/.HuionCore.pid
chmod 0777 /usr/lib/huiontablet/.DriverUI.pid
chmod 777 /usr/lib/huiontablet/log.conf
chmod 777 /usr/lib/huiontablet/.huion.log
chmod 0777 /usr/share/icons/huiontablet.png
chmod -R +0777 /usr/lib/huiontablet
chmod 0666 /dev/uinput
cp -a ./huion/xdg/autostart/huiontablet.desktop /etc/xdg/autostart/huiontablet.desktop
