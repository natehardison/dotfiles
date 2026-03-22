#!/usr/bin/env bash
#
# macOS system defaults — Dock, menu bar, hot corners.
# Run via: make macos

set -euo pipefail

# -- Dock behavior -------------------------------------------------------------

defaults write com.apple.dock tilesize -int 64
defaults write com.apple.dock largesize -int 128
defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock show-recents -bool false

# -- Dock apps -----------------------------------------------------------------

dock_add() {
  local app="$1"
  local label
  label=$(basename "$app" .app)
  if dockutil --find "$label" &>/dev/null; then
    return
  fi
  dockutil --add "$app" --no-restart
}

if command -v dockutil &>/dev/null; then
  dock_add /Applications/Ghostty.app
  dock_add /Applications/Visual\ Studio\ Code.app
  dock_add /Applications/Slack.app
  dock_add /Applications/1Password.app
else
  echo "warning: dockutil not found, skipping Dock app layout"
fi

# -- Disable hot corners ---------------------------------------------------------------

defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-modifier -int 0

# -- Menu bar clock ------------------------------------------------------------

defaults write com.apple.menuextra.clock IsAnalog -bool false
defaults write com.apple.menuextra.clock Show24Hour -bool false
defaults write com.apple.menuextra.clock ShowAMPM -bool true
defaults write com.apple.menuextra.clock ShowDate -int 0
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowSeconds -bool true

# -- Control Center ------------------------------------------------------------

defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible ScreenMirroring" -bool false

# -- Finder --------------------------------------------------------------------

defaults write com.apple.finder AppleShowAllFiles -bool true

# -- Window management ---------------------------------------------------------

# Disable macOS Sequoia tiling in favor of Rectangle.
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

# Launch Rectangle at login.
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Rectangle.app", hidden:true}' &>/dev/null || true

# -- Screenshots ---------------------------------------------------------------

mkdir -p "$HOME/screenshots"
defaults write com.apple.screencapture location "$HOME/screenshots"

# -- Trackpad ------------------------------------------------------------------

# Disable "Look Up & data detectors" (fires during large text selections).
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0

# -- Key repeat ----------------------------------------------------------------

# Disable press-and-hold for VS Code so Vim key repeat works.
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# -- Appearance ----------------------------------------------------------------

# Force dark mode system-wide (Chrome and other apps follow this)
defaults write -g AppleInterfaceStyle -string "Dark"

# Reduce brightness intensity
defaults write -g CGDisplayReduceWhitePoint -bool true
defaults write -g CGDisplayReduceWhitePointEnabled -bool true

# Disable harsh UI effects
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g NSScrollAnimationEnabled -bool false

# Font smoothing (0–3 range; try 1 or 2 depending on your display)
defaults write -g AppleFontSmoothing -int 1

# -- Apply ---------------------------------------------------------------------

killall Dock
killall SystemUIServer 2>/dev/null || true
