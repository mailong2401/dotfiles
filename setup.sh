#!/bin/bash

# =============================
#          SETUP SCRIPT
# =============================

# Cập nhật hệ thống trước khi cài đặt
echo "🔄 Đang cập nhật hệ thống..."
sudo pacman -Syu --noconfirm

# Cài đặt các gói cần thiết
echo "Cài đặt các gói: Hyprland, Neovim, Kitty, Wofi, Waybar, Zsh..."
sudo pacman -S --needed --noconfirm hyprland neovim kitty wofi waybar zsh lsd

# Clone và cài đặt `yay` nếu chưa tồn tại
if [ ! -d "yay" ]; then
    echo "Cloning yay..."
    git clone https://aur.archlinux.org/yay.git
fi

cd yay || exit
echo "Đang build và cài đặt yay..."
makepkg -si --noconfirm
cd ..

# Cấu hình auto-login cho TTY1
echo "Cấu hình auto-login cho TTY1..."
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
echo -e "[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin long --noclear %I \$TERM" | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf > /dev/null

# Cấu hình tự động vào Hyprland khi login vào TTY1
echo "Thêm cấu hình tự động khởi động Hyprland..."
if ! grep -q "exec hyprland" ~/.bash_profile; then
    echo 'if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then exec hyprland; fi' >> ~/.bash_profile
fi

# Cài đặt Oh My Zsh không cần tương tác
echo "Cài đặt Oh My Zsh..."
yes n | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


# Cài đặt các plugin Zsh
echo "Cài đặt Zsh Plugins..."
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi


cp -rf .zshrc ~/

# Cài đặt Google Chrome qua yay
echo "Cài đặt Google Chrome..."
yay -S --noconfirm google-chrome

# 🛠️ Cleanup sau khi cài đặt
echo "Dọn dẹp sau khi cài đặt..."
rm -rf yay

# ✅ Hoàn thành
echo "Quá trình cài đặt hoàn tất! Khởi động lại máy để hoàn tất cấu hình."

