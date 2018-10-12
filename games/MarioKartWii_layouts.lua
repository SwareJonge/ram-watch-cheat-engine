package.loaded.utils = nil
local utils = require 'utils'
local subclass = utils.subclass

package.loaded.valuetypes = nil
local valuetypes = require 'valuetypes'
package.loaded.layouts = nil
local layoutsModule = require 'layouts'
local Layout = layoutsModule.Layout


local layouts = {}

local narrowWindowWidth = 200
local dolphinNativeResolutionHeight = 600
local margin = 6
local fontSize = 12
-- alt: Lucida Console
local fixedWidthFontName = "Px437 TandyNew TV"
-- Cheat Engine uses blue-green-red order for some reason
local inputColor = 0xFFFFFF


layouts.velocityAndRaceInfo = subclass(Layout)
function layouts.velocityAndRaceInfo:init(noShake)
  noShake = noShake or false

  local game = self.game
  self.margin = margin
  -- Velocity can't be obtained directly from RAM. It must be computed as a
  -- position difference between consecutive frames. So we use breakpoint-based
  -- updates in order to not miss any frames.
  self:setBreakpointUpdateMethod()
  self:activateAutoPositioningY()
self.window:setSize(500, 200)
  self.window:setSize(narrowWindowWidth, dolphinNativeResolutionHeight)
  self.labelDefaults = {fontSize=fontSize, fontName=fixedWidthFontName}
  self.itemDisplayDefaults = {narrow=true}

  self:addLabel()
  self:addItem(game:V(game.Velocity, "Y"))
  self:addItem(game:V(game.Velocity, "XZ"))
  self:addItem(game:V(game.Velocity, "XYZ"))
  self:addItem(game.pos)

  self:addLabel()
self:addItem(game.airtime)
self:addLabel()
self:addItem(game.mtcharge)
self:addLabel()
self:addItem(game.checkpoint)
self:addLabel()
self:addItem(game.keycheckpoint)
self:addLabel()
self:addItem(game.lapcompleted)
self:addLabel()
self:addItem(game.mtboost)
self:addLabel()
self:addItem(game.mushroomboost)
self:addLabel()
self:addItem(game.trickboost)



  self:addLabel()
  self:addItem(game.stageTime)
end

layouts.recording = subclass(Layout)
function layouts.recording:init(noShake)
  noShake = noShake or false

  local game = self.game
  self.margin = margin
  -- Velocity can't be obtained directly from RAM. It must be computed as a
  -- position difference between consecutive frames. So we use breakpoint-based
  -- updates in order to not miss any frames.
  self:setBreakpointUpdateMethod()

self.window:setSize(200, 500)
  self.labelDefaults = {fontSize=fontSize, fontName=fixedWidthFontName}
  self.itemDisplayDefaults = {narrow=true}


 self:addLabel()
self:addImage(game.ImageValueDisplay, {game:V(game.Velocity, "XZ"), 10, {beforeDecimal=3, afterDecimal=1, leftPaddingMethod='space'}}, {x=280, y=420})

end

layouts.ctgprecording = subclass(Layout)
function layouts.ctgprecording:init(noShake)
  noShake = noShake or false

  local game = self.game
  self.margin = margin
  self:setBreakpointUpdateMethod()
self.window:setSize(200, 500)
  self.labelDefaults = {fontSize=fontSize, fontName=fixedWidthFontName}
  self.itemDisplayDefaults = {narrow=true}


 self:addLabel()
self:addImage(game.ImageValueDisplay, {game.vehiclespeed, 10, {beforeDecimal=2, afterDecimal=0, leftPaddingMethod='space'}}, {x=40, y=400})
self:addImage(game.ImageValueDisplay, {game.gtmtcharge, 10, {trimTrailingZeros=true, beforeDecimal=4, leftPaddingMethod='space'}}, {x=-10, y=200})
end

layouts.Inputs = subclass(Layout)
function layouts.Inputs:init(noShake)
  noShake = noShake or false

  local game = self.game
  self.margin = margin
  self:setBreakpointUpdateMethod()
self.window:setSize(500, 200)
  self.labelDefaults = {fontSize=fontSize, fontName=fixedWidthFontName}
  self.itemDisplayDefaults = {narrow=true}


  self:addLabel()
  self:addImage(game.ImageNumberDisplayABLR,{game.ABLRInput}, {x=200, y=163})
  self:addImage(game.ImageNumberDisplay,{game.horizontal}, {x=96, y=150})
  self:addImage(game.ImageNumberDisplayvertical,{game.vertical}, {x=0, y=150})
  self:addImage(game.ImageNumberDisplayDPAD,{game.DPAD}, {x=200, y=83})
    self:addItem(game.stageTime, {x=400})
end

layouts.ManderMode = subclass(Layout)
function layouts.ManderMode:init(noShake)
  noShake = noShake or false

  local game = self.game
  local fontSize = 26
  self.margin = margin
  self.window:setColor(0x00FF00)
  self:setBreakpointUpdateMethod()
self.window:setSize(429, 150)

  self.labelDefaults = {fontSize=fontSize, fontName=fixedWidthFontName}
    self.itemDisplayDefaults = {narrow=true}

  --km/h icon
  self:addLabel()
  self:addImage(game.ImageNumberDisplayManderMode, {game.kmh})
  --speed + MT Charge
  self:addLabel{fontColor=inputColor, x=-54, y=6}
  self:addItem(game.mt)
  self:addLabel{fontColor=inputColor, x=-18, y=-28}
  self:addItem(game.speed, {beforeDecimal=2, afterDecimal=0, leftPaddingMethod='space'})
  --Inputs
  self:addLabel{fontColor=inputColor,x=111, y=40}
  self:addImage(game.ImageNumberDisplayABLRManderMode, {game.ABLRInput}, {x=215, y=75})
  self:addImage(game.ImageNumberDisplayverticalManderMode, {game.vertical}, {x=111, y=75})
  self:addImage(game.ImageNumberDisplayhorizontalManderMode, {game.horizontal}, {x=17, y=75})
  self:addLabel{fontColor=inputColor,x=350, y=41}
  self:addItem(game.DPADmandermode)
end

--Ghost



layouts.ManderModeGhost = subclass(Layout)
function layouts.ManderModeGhost:init(noShake)
  noShake = noShake or false

  local game = self.game
  local fontSize = 26
  self.margin = margin
  self.window:setColor(0x00FF00)
  self:setBreakpointUpdateMethod()
self.window:setSize(429, 150)

  self.labelDefaults = {fontSize=fontSize, fontName=fixedWidthFontName}
    self.itemDisplayDefaults = {narrow=true}

  --km/h icon
  self:addLabel()
  self:addImage(game.ImageNumberDisplayManderMode, {game.kmh})
  --speed + MT Charge
  self:addLabel{fontColor=inputColor, x=-54, y=6}
  self:addItem(game.gmt)
  self:addLabel{fontColor=inputColor, x=-18, y=-28}
  self:addItem(game.gspeed, {beforeDecimal=2, afterDecimal=0, leftPaddingMethod='space'})
  --Inputs
  self:addLabel{fontColor=inputColor,x=111, y=40}
  self:addImage(game.ImageNumberDisplayABLRManderMode, {game.ABLRInput}, {x=215, y=75})
  self:addImage(game.ImageNumberDisplayverticalManderMode, {game.vertical}, {x=111, y=75})
  self:addImage(game.ImageNumberDisplayhorizontalManderMode, {game.horizontal}, {x=17, y=75})
  self:addLabel{fontColor=inputColor,x=350, y=41}
  self:addItem(game.DPADmandermode)
end

layouts.ctgprecordingghost = subclass(Layout)
function layouts.ctgprecordingghost:init(noShake)
  noShake = noShake or false

  local game = self.game
  self.margin = margin
  self:setBreakpointUpdateMethod()
self.window:setSize(200, 500)
  self.labelDefaults = {fontSize=fontSize, fontName=fixedWidthFontName}
  self.itemDisplayDefaults = {narrow=true}


 self:addLabel()
self:addImage(game.ImageValueDisplay, {game.gtvehiclespeed, 10, {beforeDecimal=2, afterDecimal=0, leftPaddingMethod='space'}}, {x=40, y=400})
self:addImage(game.ImageValueDisplay, {game.gtmtcharge, 10, {trimTrailingZeros=true, beforeDecimal=4, leftPaddingMethod='space'}}, {x=-10, y=200})

end


return {
  layouts = layouts,
}
