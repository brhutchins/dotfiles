stackline = require "stackline.stackline.stackline"

local hyper = { "cmd", "alt", "ctrl", "shift" }

local myStackline = {
    appearance = { 
      showIcons = false,       -- default is true
    },
    features = {
        clickToFocus = false,  -- default is true
        fzyFrameDetect = {
            fuzzFactor = 25    -- default is 30
        },
    },
}

stackline:init(myStackline)