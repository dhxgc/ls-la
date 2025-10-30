# Ubuntu (24.04)

```bash
sudo apt update && sudo apt install software-properties-common
sudo apt update                                
sudo add-apt-repository ppa:gns3/ppa
sudo apt update                                
sudo apt install gns3-gui gns3-server
```

# Arch

```bash
# GNS
python3 -m pip install gns3-gui==2.2.53 --break-system-packages
python3 -m pip install gns3-server==2.2.53 --break-system-packages
pip3 install PyQt5 --break-system-packages
echo "PATH=$PATH:~/.local/bin" >> ~/.bashrc && exec bash

# VNC
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
yay -S realvnc-vnc-viewer

# SPICE
sudo pacman -S virt-viewer
```