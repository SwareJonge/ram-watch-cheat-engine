package.loaded.utils = nil
local utils = require 'utils'
local subclass = utils.subclass

package.loaded.valuetypes = nil
local valuetypes = require 'valuetypes'
package.loaded.layouts = nil
local layoutsModule = require 'layouts'
local Layout = layoutsModule.Layout

package.loaded.imagevaluedisplay = nil
local MKWImageValueDisplay = require "imagevaluedisplay"
local ImageValueDisplay = MKWImageValueDisplay.ImageValueDisplay
local ImageNumberDisplay = MKWImageValueDisplay.ImageNumberDisplay
local ImageNumberDisplayvertical = MKWImageValueDisplay.ImageNumberDisplayvertical
local ImageNumberDisplayDPAD = MKWImageValueDisplay.ImageNumberDisplayDPAD
local ImageNumberDisplayABLR = MKWImageValueDisplay.ImageNumberDisplayABLR
local ImageNumberDisplayManderMode = MKWImageValueDisplay.ImageNumberDisplayManderMode


local layouts = {}

local narrowWindowWidth = 200
local dolphinNativeResolutionHeight = 600
local margin = 6
local fontSize = 12
-- alt: Lucida Console
local fixedWidthFontName = "Consolas"
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
self.window:setSize(400, 500)
  self.window:setColor(0x000000)
  self.labelDefaults = {fontSize=10, fontName="Px437 TandyNew TV"}
  self.itemDisplayDefaults = {narrow=true}
    self.window:setCaption("MKW Race Info")

  self:addLabel{fontColor=inputColor}
  self:addItem(game:V(game.Velocity, "Y"))
  self:addItem(game:V(game.Velocity, "XZ"))
  self:addItem(game:V(game.Velocity, "XYZ"))
  self:addItem(game.pos)

  self:addLabel{fontColor=inputColor, y=100}
self:addItem(game.airtime)
self:addItem(game.mtcharge)
self:addItem(game.checkpoint)
self:addItem(game.keycheckpoint)
self:addItem(game.lapcompleted)
self:addItem(game.BoostType)
  self:addLabel{fontColor=inputColor, x=12, y=180}
self:addItem(game.horizontalbyte)
  self:addLabel{fontColor=inputColor, x=48, y=180}
self:addItem(game.verticalbyte)
  self:addLabel{fontColor=inputColor, x=84, y=180}
self:addItem(game.ABLRInput)
  self:addLabel{fontColor=inputColor, x=120, y=180}
self:addItem(game.DPAD)
  self:addLabel{fontColor=inputColor, y=300}
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

self.window:setSize(300, 500)
  self.labelDefaults = {fontSize=fontSize, fontName=fixedWidthFontName}
  self.itemDisplayDefaults = {narrow=true}


 self:addLabel()
self:addImage(ImageValueDisplay, {game:V(game.Velocity, "XZ"), 10, {beforeDecimal=3, afterDecimal=1, leftPaddingMethod='space'}}, {x=0, y=420})

end

layouts.ctgprecording = subclass(Layout)
function layouts.ctgprecording:init(noShake)
  noShake = noShake or false

  local game = self.game
  self.margin = margin
  self:setBreakpointUpdateMethod()
self.window:setSize(400, 500)
  self.labelDefaults = {fontSize=fontSize, fontName=fixedWidthFontName}
  self.itemDisplayDefaults = {narrow=true}
  self.window:setCaption("MKW Speedometer")


 self:addLabel()
self:addImage(ImageValueDisplay, {game.vehiclespeed, 10, {beforeDecimal=2, afterDecimal=0, leftPaddingMethod='space'}}, {x=140, y=360})
self:addImage(ImageValueDisplay, {game.airtime, 10, {beforeDecimal=4, afterDecimal=0, leftPaddingMethod='space'}}, {x=90, y=120})
self:addImage(ImageValueDisplay, {game.mttype, 10, {trimTrailingZeros=true, beforeDecimal=4, leftPaddingMethod='space'}}, {x=90, y=180})
self:addImage(ImageValueDisplay, {game.Boost, 10, {trimTrailingZeros=true, beforeDecimal=3, leftPaddingMethod='space'}}, {x=140, y=240})
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
  self:addImage(ImageNumberDisplayABLR,{game.ABLRInput}, {x=200, y=163})
  self:addImage(ImageNumberDisplay,{game.horizontalbyte}, {x=96, y=150})
  self:addImage(ImageNumberDisplayvertical,{game.verticalbyte}, {x=0, y=150})
  self:addImage(ImageNumberDisplayDPAD,{game.DPAD}, {x=200, y=83})
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

  self.labelDefaults = {fontSize=fontSize, fontName="Px437 TandyNew TV"}
    self.itemDisplayDefaults = {narrow=true}

  --km/h icon
  self:addLabel()
  self:addImage(ImageNumberDisplayManderMode, {game.kmh})
  --speed + MT Charge
  self:addLabel{fontColor=inputColor, x=-54, y=42}
  self:addItem(game.mt)
  self:addLabel{fontColor=inputColor, x=-18, y=8}
  self:addItem(game.speed, {beforeDecimal=2, afterDecimal=0, leftPaddingMethod='space'})
  --Inputs
  self:addLabel{fontColor=inputColor,x=232, y=76}
  self:addItem(game.ABLRInput)
  self:addLabel{fontColor=inputColor,x=124, y=76}
  self:addItem(game.verticalbyte)
  self:addLabel{fontColor=inputColor,x=18, y=76}
  self:addItem(game.horizontalbyte)
  self:addLabel{fontColor=inputColor,x=350, y=76}
  self:addItem(game.DPADmandermode)
end


return {
  layouts = layouts,
}
