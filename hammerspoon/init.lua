stackline = require "stackline.stackline.stackline"

local hyper = { "cmd", "alt", "ctrl", "shift" }

--
-- Reload config
hs.hotkey.bind(hyper, ";", function()
    hs.reload()
end)

--
-- Lock the screen
hs.hotkey.bind(hyper, "l", function()
  hs.caffeinate.lockScreen()
end)

--
-- Stackline
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
