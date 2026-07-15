#!/usr/bin/env bash

if [[ ! -L ~/.config/my/background ]]; then 
  echo "No background wallpaper applied. Setting..."
  ~/.local/share/my/bin/hypr-set-wallpaper -i ~/.local/share/my/themes/lovely-day/backgrounds/default.jpg

else
  awww img ~/.config/my/background
fi

if [[ ! -L ~/.config/my/theme ]]; then 
  echo "No theme applied. Setting..."
  ~/.local/share/my/bin/hypr-set-current-theme lovely-day
fi

