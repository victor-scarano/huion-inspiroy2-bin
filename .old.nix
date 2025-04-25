{ stdenv, lib, fetchurl, xdotool }: stdenv.mkDerivation {
	pname = "huion-inspiroy";
	version = "15.0.0.162";

	src = fetchurl {
		url = "https://driverdl.huion.com/driver/Linux/HuionTablet_LinuxDriver_v15.0.0.162.x86_64.tar.xz";
	};

	buildInputs = [ xdotool ];

	installPhase = ''
		mkdir -p $out/lib/udev/rules.d
		cp huion/huiontablet/res/rule/20-huion.rules $out/lib/udev/rules.d

		cp -r huion/huiontablet $out/lib

		mkdir -p $out/share/applications
		cp huion/xdg/autostart/huiontablet.desktop $out/share/applications

		mkdir -p $out/share/icons
		cp huion/icon/huiontablet.png $out/share/icons
	'';

	meta = {
		description = "";
		homepage = "";
		# license
		# maintainers
		platforms = lib.platforms.linux;
	};
}

/*
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
*/
