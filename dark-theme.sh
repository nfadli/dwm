#!/usr/bin/env bash
set -e

URL="https://github.com/lassekongo83/adw-gtk3/releases/download/v6.5/adw-gtk3v6.5.tar.xz"
T="$HOME/.themes"
C3="$HOME/.config/gtk-3.0"
C4="$HOME/.config/gtk-4.0"

case "$1" in
    dark)  TH="adw-gtk3-dark"; SC="prefer-dark";  DK="true"  ;;
    white) TH="adw-gtk3";      SC="prefer-light"; DK="false" ;;
    reset)
        rm -rf "$T"/adw-gtk3* "$C3/settings.ini" "$C4/settings.ini"
        rmdir "$T" "$C3" "$C4" 2>/dev/null || true
        gsettings reset org.gnome.desktop.interface gtk-theme 2>/dev/null || true
        gsettings reset org.gnome.desktop.interface color-scheme 2>/dev/null || true
        echo "Reset selesai." && exit 0
        ;;
    *) echo "Pakai: $0 [dark|white|reset]" && exit 1 ;;
esac

curl -fsSL "$URL" -o /tmp/adw.tar.xz
mkdir -p "$T" "$C3" "$C4"
rm -rf "$T"/adw-gtk3*
tar -xf /tmp/adw.tar.xz -C "$T" && rm -f /tmp/adw.tar.xz

printf "[Settings]\ngtk-theme-name=%s\ngtk-application-prefer-dark-theme=%s\n" "$TH" "$DK" | tee "$C3/settings.ini" > "$C4/settings.ini"

gsettings set org.gnome.desktop.interface gtk-theme "$TH" 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme "$SC" 2>/dev/null || true
echo "Tema $TH diterapkan."
