stackline = require "stackline.stackline.stackline"

local hyper = { "cmd", "alt", "ctrl", "shift" }

--
-- Reload config
hs.hotkey.bind(hyper, ";", function()
    hs.reload()
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
