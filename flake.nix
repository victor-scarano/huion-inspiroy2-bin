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

				dontWrapQtApps = true;

				nativeBuildInputs = [
					pkgs.autoPatchelfHook
					pkgs.makeWrapper
				];

				buildInputs = with pkgs; [
						stdenv.cc.cc.lib # libgcc_s.so.1 libstdc++.so.6
						xorg.libX11 # libX11.so.6
						xorg.libXrandr # libXrandr.so.2
						xorg.libXtst # libXtst.so.6
						xdotool # libXrandr.so.2
						libsForQt5.qt5.qtquickcontrols # libQt5Quick.so.5
						libsForQt5.qt5.qtx11extras # libQt5X11Extras.so.5
						e2fsprogs # libcom_err.so.2
						libusb1 # libusb-1.0.so.0
						libgpg-error # libgpg-error.so.0

						# libsForQt5.qt5.qtbase

						# libQt5Core.so.5
						# libQt5DBus.so.5
						# libQt5Gui.so.5
						# libQt5Qml.so.5
						# libQt5Quick.so.5
						# libQt5Widgets.so.5
						# libQt5X11Extras.so.5

						# libz
						# freetype
						# fontconfig
						# libGL
				];

				installPhase = ''
					mkdir -p $out/lib/huiontablet
					cp -r huiontablet $out/lib
					# cp -r * $out/lib/huiontablet
					# cp -r huiontablet $out

					mkdir -p $out/share/udev/rules.d
					cp huiontablet/res/rule/20-huion.rules $out/share/udev/rules.d

					mkdir -p $out/share/applications
					cp xdg/autostart/huiontablet.desktop $out/share/applications

					mkdir -p $out/share/icons
					cp icon/huiontablet.png $out/share/icons

					autoPatchelf huiontablet
					# chmod +x huiontablet/huionCore

					mkdir -p $out/bin
					makeWrapper $out/lib/huiontablet/huionCore $out/bin/huionCore \
						--set-default LD_LIBRARY_PATH $out/lib/huiontablet/libs \
						--add-flags -d \
						--set HOME /tmp
				'';

				meta = {
					description = "";
					homepage = "";
					# license
					# maintainers
					platforms = pkgs.lib.platforms.linux;
				};
			};

		apps.x86_64-linux.huionCore = {
			type = "app";
			program = "${self.packages.x86_64-linux.default}/bin/huionCore";
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

