-- Super Mario Galaxy



-- Imports

-- package.loaded.<module> ensures that the module gets de-cached as needed.
-- That way, if we change the code in those modules and then re-run the script,
-- we won't need to restart Cheat Engine to see the code changes take effect.

package.loaded.utils = nil
local utils = require "utils"
local readIntBE = utils.readIntBE
local subclass = utils.subclass

package.loaded.valuetypes = nil
local valuetypes = require "valuetypes"
local V = valuetypes.V
local MV = valuetypes.MV
local MemoryValue = valuetypes.MemoryValue
local FloatType = valuetypes.FloatTypeBE
local IntType = valuetypes.IntTypeBE
local ShortType = valuetypes.ShortTypeBE
local ByteType = valuetypes.ByteType
local SignedIntType = valuetypes.SignedIntTypeBE
local StringType = valuetypes.StringType
local BinaryType = valuetypes.BinaryType
local Vector3Value = valuetypes.Vector3Value

package.loaded._supermariogalaxyshared = nil
local SMGshared = require "_supermariogalaxyshared"



local SMG1 = subclass(SMGshared)

SMG1.supportedGameVersions = {
  -- Wii must be set to English language.
  na = 'RMCE01',
  us = 'RMCE01',

  jp = 'RMGJ01',
  ja = 'RMGJ01',

  kr = 'RMCK01',
  ko = 'RMCK01',


  -- Wii must be set to English language.
  eu = 'RMCP01',
  pal = 'RMCP01',
}

SMG1.layoutModuleNames = {'MarioKartWii_layouts'}
SMG1.framerate = 60
-- Use D-Pad Down to reset max-value displays, average-value displays, etc.
SMG1.defaultResetButton = 'v'

function SMG1:init(options)
  SMGshared.init(self, options)

  self.addrs = {}
  self.pointerValues = {}
  self:initConstantAddresses()
end

local GV = SMG1.blockValues



-- These are addresses that should stay constant for the most part,
-- as long as the game start address is constant.

function SMG1:initConstantAddresses()
  -- Start or 'origin' address.
  self.addrs.o = self:getGameStartAddress()

  -- It's useful to have an address where there's always a ton of zeros.
  -- We can use this address as the result when an address computation
  -- is invalid. Zeros are better than unreadable memory (results in
  -- error) or garbage values.
  -- This group of zeros should go on for 0x20000 to 0x30000 bytes.
  self.addrs.zeros = self.addrs.o + 0x626000

  if self.gameId == 'RMCE01' then
    self.addrs.refPointer = self.addrs.o + 0x9BD110
    self.addrs.ckptPointer = self.addrs.o + 0x9B8F70
  elseif self.gameId == 'RMCJ01' then
    self.addrs.refPointer = self.addrs.o + 0x9C0958
    self.addrs.ckptPointer = self.addrs.o + 0x9BC790
  elseif self.gameId == 'RMCP01' then
    self.addrs.refPointer = self.addrs.o + 0x9C18F8
    self.addrs.ckptPointer = self.addrs.o + 0x9BD730
  elseif self.gameId == 'RMCK01' then
    self.addrs.refPointer = self.addrs.o + 0x9AFF38
    self.addrs.ckptPointer = self.addrs.o + 0x9ABD70
  end
end



-- These addresses can change more frequently, so we specify them as
-- functions that can be run continually.

function SMG1:updateRefPointer()
  -- Not sure what this is meant to point to exactly, but when this pointer
  -- changes value, some other relevant addresses (like pos and vel)
  -- move by the same amount as the value change.
  --
  -- This pointer value changes whenever you load a different area.
  -- It's invalid during transition screens and before the
  -- title screen.
  self.pointerValues.ref = readIntBE(self.addrs.refPointer, 4)
end



function SMG1:updateckptPointer()
  -- Not sure what this is meant to point to exactly, but when this pointer
  -- changes value, some other relevant addresses (like pos and vel)
  -- move by the same amount as the value change.
  --
  -- This pointer value changes whenever you load a different area.
  -- It's invalid during transition screens and before the
  -- title screen.
  self.pointerValues.ckptref = readIntBE(self.addrs.ckptPointer, 4)
end


function SMG1:updateMessageInfoPointer()
  -- Pointer that can be used to locate various message/text related info.
  --
  -- This pointer value changes whenever you load a different area.
  self.pointerValues.messageInfoRef = readIntBE(self.addrs.o + 0x9A9240, 4)
end

function SMG1:updatePosBlock()
  if self.pointerValues.ref == 0 then
    self.addrs.posBlock = nil
  else
    self.addrs.posBlock = (
      self.addrs.o + self.pointerValues.ref - 0x80000000 + 0x199C)
  end
end

function SMG1:updateAddresses()
  self:updateRefPointer()
  self:updateMessageInfoPointer()
  self:updateckptPointer()
  self:updatePosBlock()
end



-- Values at static addresses (from the beginning of the game memory).
SMG1.StaticValue = subclass(MemoryValue)

function SMG1.StaticValue:getAddress()
  return self.game.addrs.o + self.offset
end


-- Values that are a constant offset from the refPointer.
SMG1.RefValue = subclass(MemoryValue)

function SMG1.RefValue:getAddress()
  return (
    self.game.addrs.o + self.game.pointerValues.ref - 0x80000000 + self.offset)
end

function SMG1.RefValue:isValid()
  return self.game.pointerValues.ref ~= 0
end

-- Values that are a constant offset from the ckptPointer.
SMG1.ckptValue = subclass(MemoryValue)

function SMG1.ckptValue:getAddress()
  return (
    self.game.addrs.o + self.game.pointerValues.ckptref - 0x80000000 + self.offset)
end

function SMG1.ckptValue:isValid()
  return self.game.pointerValues.ckptref ~= 0
end




-- Values that are a constant small offset from the position values' location.
SMG1.PosBlockValue = subclass(MemoryValue)

function SMG1.PosBlockValue:getAddress()
  return self.game.addrs.posBlock + self.offset
end

function SMG1.PosBlockValue:isValid()
  return self.game.addrs.posBlock ~= nil
end


-- Values that are a constant offset from the messageInfoPointer.
SMG1.MessageInfoValue = subclass(MemoryValue)

function SMG1.MessageInfoValue:getAddress()
  return (
    self.game.addrs.o + self.game.pointerValues.messageInfoRef
    - 0x80000000 + self.offset)
end

function SMG1.MessageInfoValue:isValid()
  return self.game.pointerValues.messageInfoRef ~= 0
end


package.loaded.layouts = nil
local layouts = require "layouts"
local CompoundElement = layouts.CompoundElement

-- Display a memory value using per-character images (effectively a bitmap font).
SMG1.ImageValueDisplay = subclass(CompoundElement)

function SMG1.ImageValueDisplay:init(window, memoryValue, numCharacters, passedDisplayOptions)
  -- This can be any kind of MemoryValue. The only constraint is that all the possible
  -- characters that can be displayed are covered in the charImages defined below.
  self.memoryValue = memoryValue
  -- Max number of characters to show in this display. This is how many Image objects
  -- we'll maintain.
  self.numCharacters = numCharacters
  -- display options to pass into the memory value's display() method.
  self.displayOptions = {nolabel=true}
  if passedDisplayOptions then
    utils.updateTable(self.displayOptions, passedDisplayOptions)
  end

FontDirectory = RWCEMainDirectory .. '/Fonts'
  self.charImageFiles = {
    ['0'] = FontDirectory .. '/0.png',
    ['1'] = FontDirectory .. '/1.png',
    ['2'] = FontDirectory .. '/2.png',
    ['3'] = FontDirectory .. '/3.png',
    ['4'] = FontDirectory .. '/4.png',
    ['5'] = FontDirectory .. '/5.png',
    ['6'] = FontDirectory .. '/6.png',
    ['7'] = FontDirectory .. '/7.png',
    ['8'] = FontDirectory .. '/8.png',
    ['9'] = FontDirectory .. '/9.png',
  
   
    ['-'] = FontDirectory .. '/minus.png',
    ['.'] = FontDirectory .. '/coron.png',
  }

  self.charImages = {}
  for char, charImageFilepath in pairs(self.charImageFiles) do
    self.charImages[char] = createPicture()
    self.charImages[char]:loadFromFile(charImageFilepath)
  end
  -- Empty picture to represent a space
  self.charImages[''] = createPicture()

  local width = 48
  local height = 64
  for n=1, numCharacters do
    local uiObj = createImage(window)
    uiObj:setSize(width, height)
    -- Allow the image to stretch to fit the size
    uiObj:setStretch(false)
    local relativePosition = {width*(n-1), 0}
    self:addElement(relativePosition, uiObj)
 end  
end

function SMG1.ImageValueDisplay:update()
  local valueString = self.memoryValue:display(self.displayOptions)

  for n, element in pairs(self.elements) do
    if valueString:len() >= n then
      local char = valueString:sub(n, n)
      if self.charImages[char] == nil then
        error(
          "No image specified for '" .. char
          .. "' (full string: " .. valueString .. ")")
      end
      element.uiObj.setPicture(self.charImages[char])
    else
      element.uiObj.setPicture(self.charImages[''])
    end
  end
end







GV.stageTimeFrames =
  MV("Race Time, frames", 0x9C38C0, SMG1.StaticValue, IntType)



-- Position, velocity, and other coordinates related stuff.
GV.pos = V(
  Vector3Value,
  MV("Pos X", 0x183C, SMG1.RefValue, FloatType),
  MV("Pos Y", 0x1840, SMG1.RefValue, FloatType),
  MV("Pos Z", 0x1844, SMG1.RefValue, FloatType)
)
GV.pos.label = "Position"
GV.pos.displayDefaults = {signed=true, beforeDecimal=5, afterDecimal=1}

-- Position, velocity, and other coordinates related stuff.
GV.posGhost = V(
  Vector3Value,
  MV("Pos X", 0x4, SMG1.PosBlockValue, FloatType),
  MV("Pos Y", 0x8, SMG1.PosBlockValue, FloatType),
  MV("Pos Z", 0xC, SMG1.PosBlockValue, FloatType)
)
GV.pos.label = "Position"
GV.pos.displayDefaults = {signed=true, beforeDecimal=5, afterDecimal=1}


GV.pos_early1 = V(
  Vector3Value,
  MV("Pos X", 0x183C, SMG1.RefValue, FloatType),
  MV("Pos Y", 0x1840, SMG1.RefValue, FloatType),
  MV("Pos Z", 0x1844, SMG1.RefValue, FloatType)
)
GV.pos_early1.label = "Position"
GV.pos_early1.displayDefaults =
  {signed=true, beforeDecimal=5, afterDecimal=1}




GV.airtime=
  MV("Airtime", 0x604, SMG1.RefValue, IntType)
GV.vehiclespeed =
  MV("Speed", 0x40C, SMG1.RefValue, FloatType)
GV.mtcharge =
  MV("MT Charge", 0x4EA, SMG1.RefValue, ShortType)
GV.checkpoint =
  MV("CheckPoint ID", 0xF7, SMG1.ckptValue, ByteType)
GV.keycheckpoint =
  MV("Key CheckPoint ID", 0x113, SMG1.ckptValue, ByteType)
GV.lapcompleted =
  MV("Lap Completion", 0xFC, SMG1.ckptValue, FloatType)
GV.mtboost =
  MV("MT Boost", 0x4EF, SMG1.RefValue, ByteType)
GV.mushroomboost =
  MV("Mushroom Boost", 0x4FD, SMG1.RefValue, ByteType)
GV.trickboost  =
  MV("TrickBoost", 0x501, SMG1.RefValue, ByteType)


return SMG1
