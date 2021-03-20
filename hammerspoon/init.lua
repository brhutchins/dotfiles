stackline = require "stackline.stackline.stackline"

local hyper = { "cmd", "alt", "ctrl", "shift" }

local myStackline = {
    appearance = { 
      showIcons = false,
    },
    features = {
        clickToFocus = false,
        fzyFrameDetect = {
            fuzzFactor = 25
        },
    },
}

stackline:init(myStackline)

local VimMode = hs.loadSpoon('VimMode')
local vim = VimMode:new()

vim
  :disableForApp('Code')
  :disableForApp('Emacs')
  :disableForApp('kitty')
  :disableForApp('zoom.us')
  :enterWithSequence('jk')
  :enableBetaFeature('block_cursor_overlay')