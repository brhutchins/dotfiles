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
