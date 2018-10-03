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
local fixedWidthFontName = "Consolas"
-- Cheat Engine uses blue-green-red order for some reason
local inputColor = 0x880000


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

self.window:setSize(600, 500)
  self.labelDefaults = {fontSize=fontSize, fontName=fixedWidthFontName}
  self.itemDisplayDefaults = {narrow=true}


 self:addLabel()
self:addImage(game.ImageValueDisplay, {game:V(game.Velocity, "XZ"), 10, {beforeDecimal=3, afterDecimal=1}}, {x=280, y=420})

end

layouts.ctgprecording = subclass(Layout)
function layouts.ctgprecording:init(noShake)
  noShake = noShake or false

  local game = self.game
  self.margin = margin
  -- Velocity can't be obtained directly from RAM. It must be computed as a
  -- position difference between consecutive frames. So we use breakpoint-based
  -- updates in order to not miss any frames.
  self:setBreakpointUpdateMethod()

self.window:setSize(600, 500)
  self.labelDefaults = {fontSize=fontSize, fontName=fixedWidthFontName}
  self.itemDisplayDefaults = {narrow=true}


 self:addLabel()
self:addImage(game.ImageValueDisplay, {game.vehiclespeed, 10, {beforeDecimal=2, afterDecimal=0}}, {x=400, y=420})

end


return {
  layouts = layouts,
}

