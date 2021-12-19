stackline = require "stackline"

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
--[[ local myStackline = {
  paths = {
    jq    = 'jq',
    yabai = 'yabai'
  },
  appearance = {
    showIcons = false,
  },
  features = {
      clickToFocus = false,
      fzyFrameDetect = {
          fuzzFactor = 25
      },
  },
} ]]

local sl = {
  paths = {
    yabai               = '/run/current-system/sw/bin/yabai',
  },
  appearance = {
      color             = { white = 0.90 },
      alpha             = 1,
      dimmer            = 2.5,
      iconDimmer        = 1.1,
      showIcons         = false,
      size              = 32,
      radius            = 3,
      iconPadding       = 4,
      pillThinness      = 6,

      vertSpacing       = 1.2,
      offset            = {x=4, y=2},
      shouldFade        = true,
      fadeDuration      = 0.2,
  },
  features = {
      clickToFocus      = false,
      hsBugWorkaround   = true,
      winTitles         = false,
      dynamicLuminosity = false,
      fzyFrameDetect    = { enabled = true, fuzzFactor = 30, },
  },
  advanced = {
      maxRefreshRate = 0.5,
  }
}

stackline:init(sl)
--[[ stackline.config:set("paths.yabai", "yabai")
stackline.config:set("paths.jq", "jq") ]]
