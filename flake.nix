# NOTE: does user need to have hardware.bluetooth.enable = true; ?
{
	description = "";

	inputs.nixpkgs.url = "github:NixOS/nixpkgs";

	outputs = { self, nixpkgs }: {
		packages.x86_64-linux.default =
		let
			pkgs = import nixpkgs { system = "x86_64-linux"; };
		in
			pkgs.stdenv.mkDerivation {
				pname = "huion-inspiroy";
				version = "15.0.0.162";

				src = pkgs.fetchurl {
					url = "https://driverdl.huion.com/driver/Linux/HuionTablet_LinuxDriver_v15.0.0.162.x86_64.tar.xz";
					hash = "sha256-cGa3XGE6q7+M8aV+pUkQpPYiRd24mGqgGu8wDgst6H0=";
				};

				nativeBuildInputs = [
					pkgs.autoPatchelfHook
					pkgs.makeWrapper
				];

				buildInputs = with pkgs; [
					xdotool
					xorg.libX11
					stdenv.cc.cc.lib
					libusb1
					libz
					freetype
					fontconfig
					libGL
					e2fsprogs # for libcom_err.so.2
					libgpg-error
				];

				installPhase = ''
					mkdir -p $out/lib/udev/rules.d
					cp huiontablet/res/rule/20-huion.rules $out/lib/udev/rules.d

					cp -r huiontablet $out/lib

					mkdir -p $out/share/applications
					cp xdg/autostart/huiontablet.desktop $out/share/applications

					mkdir -p $out/share/icons
					cp icon/huiontablet.png $out/share/icons

					mkdir -p $out/bin

					makeWrapper $out/lib/huiontablet/huionCore \
						$out/bin/huionCore \
						--set-default LD_LIBRARY_PATH $out/lib/huiontablet/libs \
						--add-flags "-d" \
						--chdir /tmp
						# --set HOME "/tmp"
						# --set LD_LIBRARY_PATH $out/lib/huiontablet/libs \
				'';

				meta = {
					description = "";
					homepage = "";
					# license
					# maintainers
					platforms = pkgs.lib.platforms.linux;
				};
			};
	};
}

# cp ./huion/huiontablet/res/rule/20-huion.rules /usr/lib/udev/rules.d/20-huion.rules
# cp -rf ./huion/huiontablet /usr/lib
# chmod +0777 /usr/lib/huiontablet/huionCore.sh
# chmod +0777 /usr/lib/huiontablet/huionCore
# chmod +0777 /usr/lib/huiontablet/huiontablet 
# chmod 0777 /usr/lib/huiontablet/.HuionCore.pid
# chmod 0777 /usr/lib/huiontablet/.DriverUI.pid
# chmod 777 /usr/lib/huiontablet/log.conf
# chmod 777 /usr/lib/huiontablet/.huion.log
# cp -a ./huion/xdg/autostart/huiontablet.desktop /usr/share/applications/huiontablet.desktop
# cp ./huion/icon/huiontablet.png /usr/share/icons/huiontablet.png
# chmod 0777 /usr/share/icons/huiontablet.png
# cp -a ./huion/xdg/autostart/huiontablet.desktop /etc/xdg/autostart/huiontablet.desktop
# chmod -R +0777 /usr/lib/huiontablet
# chmod 0666 /dev/uinput

# user may need to set gdm/custom.conf
	# [daemon]
	# WaylandEnable=false
	# DefaultSession=x11
# might need to force wayland
	# services.xserver.displayManager.gdm.enable = true;
	# services.xserver.displayManager.gdm.wayland = false;
# cp -a ./huion/huiontablet/xdotool/libxdo.so.3 /usr/lib/libxdo.so.3
# sed -i 's/#UserspaceHID=true/UserspaceHID=true/' /etc/bluetooth/input.conf

