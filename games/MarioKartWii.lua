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

  jp = 'RMCJ01',
  ja = 'RMCJ01',

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
    self.addrs.MEMPointer = self.addrs.o + 0x429F14    
  elseif self.gameId == 'RMCJ01' then
    self.addrs.refPointer = self.addrs.o + 0x9C0958
    self.addrs.ckptPointer = self.addrs.o + 0x9BC790
    self.addrs.MEMPointer = self.addrs.o + 0x42DC14
  elseif self.gameId == 'RMCP01' then
    self.addrs.refPointer = self.addrs.o + 0x9C18F8
    self.addrs.ckptPointer = self.addrs.o + 0x9BD730
    self.addrs.MEMPointer = self.addrs.o + 0x42E324
  elseif self.gameId == 'RMCK01' then
    self.addrs.refPointer = self.addrs.o + 0x9AFF38
    self.addrs.ckptPointer = self.addrs.o + 0x9ABD70
    self.addrs.MEMPointer = self.addrs.o + 0x41C2B4
  end
end



-- These addresses can change more frequently, so we specify them as
-- functions that can be run continually.

function SMG1:updateRefPointer()
  self.pointerValues.ref =
readIntBE(self.addrs.refPointer, 4)
end



function SMG1:updateckptPointer()
  self.pointerValues.ckptref = readIntBE(self.addrs.ckptPointer, 4)
end

function SMG1:updateMEMPointer()
  self.pointerValues.MEMref = readIntBE(self.addrs.MEMPointer, 4)
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
  self:updateMEMPointer()
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

SMG1.MEMValue = subclass(MemoryValue)

function SMG1.MEMValue:getAddress()
  return (
    self.game.addrs.o + self.game.pointerValues.MEMref - 0x80000000 + self.offset)
end


function SMG1.MEMValue:isValid()
  return self.game.pointerValues.MEMref ~= 0
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
    [' '] = FontDirectory .. '/empty.png',
    ['<'] = FontDirectory .. '/empty.png',
    ['I'] = FontDirectory .. '/empty.png',
    ['n'] = FontDirectory .. '/empty.png',
    ['v'] = FontDirectory .. '/empty.png',
    ['a'] = FontDirectory .. '/empty.png',
    ['l'] = FontDirectory .. '/empty.png',
    ['i'] = FontDirectory .. '/empty.png',
    ['d'] = FontDirectory .. '/empty.png',
    ['v'] = FontDirectory .. '/empty.png',
    ['a'] = FontDirectory .. '/empty.png',
    ['l'] = FontDirectory .. '/empty.png',
    ['u'] = FontDirectory .. '/empty.png',
    ['e'] = FontDirectory .. '/empty.png',
    ['>'] = FontDirectory .. '/empty.png',

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

package.loaded.layouts = nil
local layouts = require "layouts"
local SimpleElement = layouts.SimpleElement

SMG1.ImageNumberDisplay = subclass(SimpleElement)

function SMG1.ImageNumberDisplay:init(window, numberMemoryValue)
  self.numberMemoryValue = numberMemoryValue

InputDirectory = RWCEMainDirectory .. '/Input'
  self.d0 = createPicture()
self.d0:loadFromFile(InputDirectory .. '/Left7.png')
self.d1 = createPicture()
self.d1:loadFromFile(InputDirectory .. '/Left6.png')
self.d2 = createPicture()
self.d2:loadFromFile(InputDirectory .. '/Left5.png')
self.d3 = createPicture()
self.d3:loadFromFile(InputDirectory .. '/Left4.png')
self.d4 = createPicture()
self.d4:loadFromFile(InputDirectory .. '/Left3.png')
self.d5 = createPicture()
self.d5:loadFromFile(InputDirectory .. '/Left2.png')
self.d6 = createPicture()
self.d6:loadFromFile(InputDirectory .. '/Left1.png')
self.d7 = createPicture()
self.d7:loadFromFile(InputDirectory .. '/Input07.png')
self.d8 = createPicture()
self.d8:loadFromFile(InputDirectory .. '/Right1.png')
self.d9 = createPicture()
self.d9:loadFromFile(InputDirectory .. '/Right2.png')
self.d10 = createPicture()
self.d10:loadFromFile(InputDirectory .. '/Right3.png')
self.d11 = createPicture()
self.d11:loadFromFile(InputDirectory .. '/Right4.png')
self.d12 = createPicture()
self.d12:loadFromFile(InputDirectory .. '/Right5.png')
self.d13 = createPicture()
self.d13:loadFromFile(InputDirectory .. '/Right6.png')
self.d14 = createPicture()
self.d14:loadFromFile(InputDirectory .. '/Right7.png')

    self.uiObj = createImage(window)
    self.uiObj:setSize(96, 48)
  end

  function SMG1.ImageNumberDisplay:update()
    local number = self.numberMemoryValue:get()
    local onesDigit = number % 100
    if onesDigit == 0 then
      self.uiObj.setPicture(self.d0)
    elseif onesDigit == 1 then
      self.uiObj.setPicture(self.d1)
    elseif onesDigit == 2 then
      self.uiObj.setPicture(self.d2)
    elseif onesDigit == 3 then
      self.uiObj.setPicture(self.d3)
    elseif onesDigit == 4 then
      self.uiObj.setPicture(self.d4)
    elseif onesDigit == 5 then
      self.uiObj.setPicture(self.d5)
    elseif onesDigit == 6 then
      self.uiObj.setPicture(self.d6)
    elseif onesDigit == 7 then
      self.uiObj.setPicture(self.d7)
    elseif onesDigit == 8 then
      self.uiObj.setPicture(self.d8)
    elseif onesDigit == 9 then
      self.uiObj.setPicture(self.d9)
    elseif onesDigit == 10 then
      self.uiObj.setPicture(self.d10)
    elseif onesDigit == 11 then
      self.uiObj.setPicture(self.d11)
    elseif onesDigit == 12 then
      self.uiObj.setPicture(self.d12)
    elseif onesDigit == 13 then
      self.uiObj.setPicture(self.d13)
    else
      self.uiObj.setPicture(self.d14)
    end
  end

  SMG1.ImageNumberDisplayvertical = subclass(SimpleElement)

  function SMG1.ImageNumberDisplayvertical:init(window, numberMemoryValue)
    self.numberMemoryValue = numberMemoryValue

  InputDirectory = RWCEMainDirectory .. '/Input'
    self.d0 = createPicture()
  self.d0:loadFromFile(InputDirectory .. '/Down7.png')
  self.d1 = createPicture()
  self.d1:loadFromFile(InputDirectory .. '/Down6.png')
  self.d2 = createPicture()
  self.d2:loadFromFile(InputDirectory .. '/Down5.png')
  self.d3 = createPicture()
  self.d3:loadFromFile(InputDirectory .. '/Down4.png')
  self.d4 = createPicture()
  self.d4:loadFromFile(InputDirectory .. '/Down3.png')
  self.d5 = createPicture()
  self.d5:loadFromFile(InputDirectory .. '/Down2.png')
  self.d6 = createPicture()
  self.d6:loadFromFile(InputDirectory .. '/Down1.png')
  self.d7 = createPicture()
  self.d7:loadFromFile(InputDirectory .. '/Input07.png')
  self.d8 = createPicture()
  self.d8:loadFromFile(InputDirectory .. '/Up1.png')
  self.d9 = createPicture()
  self.d9:loadFromFile(InputDirectory .. '/Up2.png')
  self.d10 = createPicture()
  self.d10:loadFromFile(InputDirectory .. '/Up3.png')
  self.d11 = createPicture()
  self.d11:loadFromFile(InputDirectory .. '/Up4.png')
  self.d12 = createPicture()
  self.d12:loadFromFile(InputDirectory .. '/Up5.png')
  self.d13 = createPicture()
  self.d13:loadFromFile(InputDirectory .. '/Up6.png')
  self.d14 = createPicture()
  self.d14:loadFromFile(InputDirectory .. '/Up7.png')

      self.uiObj = createImage(window)
      self.uiObj:setSize(96, 48)
    end

    function SMG1.ImageNumberDisplayvertical:update()
      local number = self.numberMemoryValue:get()
      local onesDigit = number % 100
      if onesDigit == 0 then
        self.uiObj.setPicture(self.d0)
      elseif onesDigit == 1 then
        self.uiObj.setPicture(self.d1)
      elseif onesDigit == 2 then
        self.uiObj.setPicture(self.d2)
      elseif onesDigit == 3 then
        self.uiObj.setPicture(self.d3)
      elseif onesDigit == 4 then
        self.uiObj.setPicture(self.d4)
      elseif onesDigit == 5 then
        self.uiObj.setPicture(self.d5)
      elseif onesDigit == 6 then
        self.uiObj.setPicture(self.d6)
      elseif onesDigit == 7 then
        self.uiObj.setPicture(self.d7)
      elseif onesDigit == 8 then
        self.uiObj.setPicture(self.d8)
      elseif onesDigit == 9 then
        self.uiObj.setPicture(self.d9)
      elseif onesDigit == 10 then
        self.uiObj.setPicture(self.d10)
      elseif onesDigit == 11 then
        self.uiObj.setPicture(self.d11)
      elseif onesDigit == 12 then
        self.uiObj.setPicture(self.d12)
      elseif onesDigit == 13 then
        self.uiObj.setPicture(self.d13)
      else
        self.uiObj.setPicture(self.d14)
      end
    end

    SMG1.ImageNumberDisplayhorizontalManderMode = subclass(SimpleElement)

    function SMG1.ImageNumberDisplayhorizontalManderMode:init(window, numberMemoryValue)
      self.numberMemoryValue = numberMemoryValue

    InputDirectory = RWCEMainDirectory .. '/ManderMode'
      self.d0 = createPicture()
    self.d0:loadFromFile(InputDirectory .. '/Left7.png')
    self.d1 = createPicture()
    self.d1:loadFromFile(InputDirectory .. '/Left6.png')
    self.d2 = createPicture()
    self.d2:loadFromFile(InputDirectory .. '/Left5.png')
    self.d3 = createPicture()
    self.d3:loadFromFile(InputDirectory .. '/Left4.png')
    self.d4 = createPicture()
    self.d4:loadFromFile(InputDirectory .. '/Left3.png')
    self.d5 = createPicture()
    self.d5:loadFromFile(InputDirectory .. '/Left2.png')
    self.d6 = createPicture()
    self.d6:loadFromFile(InputDirectory .. '/Left1.png')
    self.d7 = createPicture()
    self.d7:loadFromFile(InputDirectory .. '/Input07.png')
    self.d8 = createPicture()
    self.d8:loadFromFile(InputDirectory .. '/Right1.png')
    self.d9 = createPicture()
    self.d9:loadFromFile(InputDirectory .. '/Right2.png')
    self.d10 = createPicture()
    self.d10:loadFromFile(InputDirectory .. '/Right3.png')
    self.d11 = createPicture()
    self.d11:loadFromFile(InputDirectory .. '/Right4.png')
    self.d12 = createPicture()
    self.d12:loadFromFile(InputDirectory .. '/Right5.png')
    self.d13 = createPicture()
    self.d13:loadFromFile(InputDirectory .. '/Right6.png')
    self.d14 = createPicture()
    self.d14:loadFromFile(InputDirectory .. '/Right7.png')

        self.uiObj = createImage(window)
        self.uiObj:setSize(67, 33)
      end

      function SMG1.ImageNumberDisplayhorizontalManderMode:update()
        local number = self.numberMemoryValue:get()
        local onesDigit = number % 100
        if onesDigit == 0 then
          self.uiObj.setPicture(self.d0)
        elseif onesDigit == 1 then
          self.uiObj.setPicture(self.d1)
        elseif onesDigit == 2 then
          self.uiObj.setPicture(self.d2)
        elseif onesDigit == 3 then
          self.uiObj.setPicture(self.d3)
        elseif onesDigit == 4 then
          self.uiObj.setPicture(self.d4)
        elseif onesDigit == 5 then
          self.uiObj.setPicture(self.d5)
        elseif onesDigit == 6 then
          self.uiObj.setPicture(self.d6)
        elseif onesDigit == 7 then
          self.uiObj.setPicture(self.d7)
        elseif onesDigit == 8 then
          self.uiObj.setPicture(self.d8)
        elseif onesDigit == 9 then
          self.uiObj.setPicture(self.d9)
        elseif onesDigit == 10 then
          self.uiObj.setPicture(self.d10)
        elseif onesDigit == 11 then
          self.uiObj.setPicture(self.d11)
        elseif onesDigit == 12 then
          self.uiObj.setPicture(self.d12)
        elseif onesDigit == 13 then
          self.uiObj.setPicture(self.d13)
        else
          self.uiObj.setPicture(self.d14)
        end
      end

      SMG1.ImageNumberDisplayverticalManderMode = subclass(SimpleElement)

      function SMG1.ImageNumberDisplayverticalManderMode:init(window, numberMemoryValue)
        self.numberMemoryValue = numberMemoryValue

      InputDirectory = RWCEMainDirectory .. '/ManderMode'
        self.d0 = createPicture()
      self.d0:loadFromFile(InputDirectory .. '/Down7.png')
      self.d1 = createPicture()
      self.d1:loadFromFile(InputDirectory .. '/Down6.png')
      self.d2 = createPicture()
      self.d2:loadFromFile(InputDirectory .. '/Down5.png')
      self.d3 = createPicture()
      self.d3:loadFromFile(InputDirectory .. '/Down4.png')
      self.d4 = createPicture()
      self.d4:loadFromFile(InputDirectory .. '/Down3.png')
      self.d5 = createPicture()
      self.d5:loadFromFile(InputDirectory .. '/Down2.png')
      self.d6 = createPicture()
      self.d6:loadFromFile(InputDirectory .. '/Down1.png')
      self.d7 = createPicture()
      self.d7:loadFromFile(InputDirectory .. '/Input07.png')
      self.d8 = createPicture()
      self.d8:loadFromFile(InputDirectory .. '/Up1.png')
      self.d9 = createPicture()
      self.d9:loadFromFile(InputDirectory .. '/Up2.png')
      self.d10 = createPicture()
      self.d10:loadFromFile(InputDirectory .. '/Up3.png')
      self.d11 = createPicture()
      self.d11:loadFromFile(InputDirectory .. '/Up4.png')
      self.d12 = createPicture()
      self.d12:loadFromFile(InputDirectory .. '/Up5.png')
      self.d13 = createPicture()
      self.d13:loadFromFile(InputDirectory .. '/Up6.png')
      self.d14 = createPicture()
      self.d14:loadFromFile(InputDirectory .. '/Up7.png')

          self.uiObj = createImage(window)
          self.uiObj:setSize(67, 33)
        end

        function SMG1.ImageNumberDisplayverticalManderMode:update()
          local number = self.numberMemoryValue:get()
          local onesDigit = number % 100
          if onesDigit == 0 then
            self.uiObj.setPicture(self.d0)
          elseif onesDigit == 1 then
            self.uiObj.setPicture(self.d1)
          elseif onesDigit == 2 then
            self.uiObj.setPicture(self.d2)
          elseif onesDigit == 3 then
            self.uiObj.setPicture(self.d3)
          elseif onesDigit == 4 then
            self.uiObj.setPicture(self.d4)
          elseif onesDigit == 5 then
            self.uiObj.setPicture(self.d5)
          elseif onesDigit == 6 then
            self.uiObj.setPicture(self.d6)
          elseif onesDigit == 7 then
            self.uiObj.setPicture(self.d7)
          elseif onesDigit == 8 then
            self.uiObj.setPicture(self.d8)
          elseif onesDigit == 9 then
            self.uiObj.setPicture(self.d9)
          elseif onesDigit == 10 then
            self.uiObj.setPicture(self.d10)
          elseif onesDigit == 11 then
            self.uiObj.setPicture(self.d11)
          elseif onesDigit == 12 then
            self.uiObj.setPicture(self.d12)
          elseif onesDigit == 13 then
            self.uiObj.setPicture(self.d13)
          else
            self.uiObj.setPicture(self.d14)
          end
        end

  SMG1.ImageNumberDisplayDPAD = subclass(SimpleElement)

  function SMG1.ImageNumberDisplayDPAD:init(window, numberMemoryValue)
    self.numberMemoryValue = numberMemoryValue

  InputDirectory = RWCEMainDirectory .. '/Input'
    self.d0 = createPicture()
  self.d0:loadFromFile(InputDirectory .. '/dpad0.png')
  self.d1 = createPicture()
  self.d1:loadFromFile(InputDirectory .. '/dpad10.png')
  self.d2 = createPicture()
  self.d2:loadFromFile(InputDirectory .. '/dpad20.png')
  self.d3 = createPicture()
  self.d3:loadFromFile(InputDirectory .. '/dpad30.png')
  self.d4 = createPicture()
  self.d4:loadFromFile(InputDirectory .. '/dpad40.png')
  self.d5 = createPicture()
  self.d5:loadFromFile(InputDirectory .. '/dpad50.png')
  self.d6 = createPicture()
  self.d6:loadFromFile(InputDirectory .. '/dpad60.png')
  self.d7 = createPicture()
  self.d7:loadFromFile(InputDirectory .. '/dpad70.png')
  self.d8 = createPicture()
  self.d8:loadFromFile(InputDirectory .. '/dpad80.png')
  self.d9 = createPicture()
  self.d9:loadFromFile(InputDirectory .. '/dpad90.png')
  self.d10 = createPicture()
  self.d10:loadFromFile(InputDirectory .. '/dpadA0.png')

      self.uiObj = createImage(window)
      self.uiObj:setSize(96, 96)
  end

  function SMG1.ImageNumberDisplayDPAD:update()
   local number = self.numberMemoryValue:get()
   local onesDigit = number % 1000
      if onesDigit == 0 then
        self.uiObj.setPicture(self.d0)
      elseif onesDigit == 1 then
        self.uiObj.setPicture(self.d1)
      elseif onesDigit == 2 then
        self.uiObj.setPicture(self.d2)
      elseif onesDigit == 3 then
        self.uiObj.setPicture(self.d3)
      elseif onesDigit == 4 then
        self.uiObj.setPicture(self.d4)
      elseif onesDigit == 5 then
        self.uiObj.setPicture(self.d5)
      elseif onesDigit == 6 then
        self.uiObj.setPicture(self.d6)
      elseif onesDigit == 7 then
        self.uiObj.setPicture(self.d7)
      elseif onesDigit == 8 then
        self.uiObj.setPicture(self.d8)
      elseif onesDigit == 9 then
        self.uiObj.setPicture(self.d9)
      else
        self.uiObj.setPicture(self.d10)
    end
  end

  function SMG1.ImageNumberDisplayDPAD:update()
   local number = self.numberMemoryValue:get()
   local onesDigit = number % 1000
      if onesDigit == 0 then
        self.uiObj.setPicture(self.d0)
      elseif onesDigit == 1 then
        self.uiObj.setPicture(self.d1)
      elseif onesDigit == 2 then
        self.uiObj.setPicture(self.d2)
      elseif onesDigit == 3 then
        self.uiObj.setPicture(self.d3)
      elseif onesDigit == 4 then
        self.uiObj.setPicture(self.d4)
      elseif onesDigit == 5 then
        self.uiObj.setPicture(self.d5)
      elseif onesDigit == 6 then
        self.uiObj.setPicture(self.d6)
      elseif onesDigit == 7 then
        self.uiObj.setPicture(self.d7)
      elseif onesDigit == 8 then
        self.uiObj.setPicture(self.d8)
      elseif onesDigit == 9 then
        self.uiObj.setPicture(self.d9)
      else
        self.uiObj.setPicture(self.d10)
    end
  end

  SMG1.ImageNumberDisplayABLRManderMode = subclass(SimpleElement)

  function SMG1.ImageNumberDisplayABLRManderMode:init(window, numberMemoryValue)
    self.numberMemoryValue = numberMemoryValue

  InputDirectory = RWCEMainDirectory .. '/ManderMode'
    self.d0 = createPicture()
  self.d0:loadFromFile(InputDirectory .. '/noinput.png')
  self.d1 = createPicture()
  self.d1:loadFromFile(InputDirectory .. '/A.png')
  self.d4 = createPicture()
  self.d4:loadFromFile(InputDirectory .. '/L.png')
  self.d5 = createPicture()
  self.d5:loadFromFile(InputDirectory .. '/AL.png')
  self.d10 = createPicture()
  self.d10:loadFromFile(InputDirectory .. '/B.png')
  self.d11 = createPicture()
  self.d11:loadFromFile(InputDirectory .. '/AB.png')
  self.d14 = createPicture()
  self.d14:loadFromFile(InputDirectory .. '/BL.png')
  self.d15 = createPicture()
  self.d15:loadFromFile(InputDirectory .. '/ABL.png')


      self.uiObj = createImage(window)
      self.uiObj:setSize(99, 33)
  end

  function SMG1.ImageNumberDisplayABLRManderMode:update()
   local number = self.numberMemoryValue:get()
   local onesDigit = number % 1000
      if onesDigit == 0 then
        self.uiObj.setPicture(self.d0)
      elseif onesDigit == 1 then
        self.uiObj.setPicture(self.d1)
      elseif onesDigit == 2 then
        self.uiObj.setPicture(self.d10)
      elseif onesDigit == 3 then
        self.uiObj.setPicture(self.d11)
      elseif onesDigit == 4 then
        self.uiObj.setPicture(self.d4)
      elseif onesDigit == 5 then
        self.uiObj.setPicture(self.d5)
      elseif onesDigit == 6 then
        self.uiObj.setPicture(self.d14)
      elseif onesDigit == 7 then
        self.uiObj.setPicture(self.d15)
      elseif onesDigit == 8 then
        self.uiObj.setPicture(self.d10)
      elseif onesDigit == 10 then
        self.uiObj.setPicture(self.d10)
      elseif onesDigit == 14 then
        self.uiObj.setPicture(self.d14)
      elseif onesDigit == 11 then
        self.uiObj.setPicture(self.d11)
      else
        self.uiObj.setPicture(self.d15)
    end
  end

  SMG1.ImageNumberDisplayABLR = subclass(SimpleElement)

  function SMG1.ImageNumberDisplayABLR:init(window, numberMemoryValue)
    self.numberMemoryValue = numberMemoryValue

  InputDirectory = RWCEMainDirectory .. '/Input'
    self.d0 = createPicture()
  self.d0:loadFromFile(InputDirectory .. '/ABInput0.png')
  self.d1 = createPicture()
  self.d1:loadFromFile(InputDirectory .. '/ABInput1.png')
  self.d4 = createPicture()
  self.d4:loadFromFile(InputDirectory .. '/ABInput4.png')
  self.d5 = createPicture()
  self.d5:loadFromFile(InputDirectory .. '/ABInput5.png')
  self.d10 = createPicture()
  self.d10:loadFromFile(InputDirectory .. '/ABInput10.png')
  self.d11 = createPicture()
  self.d11:loadFromFile(InputDirectory .. '/ABInput11.png')
  self.d14 = createPicture()
  self.d14:loadFromFile(InputDirectory .. '/ABInput14.png')

      self.uiObj = createImage(window)
      self.uiObj:setSize(74, 37)
  end

  function SMG1.ImageNumberDisplayABLR:update()
   local number = self.numberMemoryValue:get()
   local onesDigit = number % 1000
      if onesDigit == 0 then
        self.uiObj.setPicture(self.d0)
      elseif onesDigit == 1 then
        self.uiObj.setPicture(self.d1)
      elseif onesDigit == 3 then
        self.uiObj.setPicture(self.d11)
      elseif onesDigit == 4 then
        self.uiObj.setPicture(self.d4)
      elseif onesDigit == 5 then
        self.uiObj.setPicture(self.d5)
      elseif onesDigit == 6 then
        self.uiObj.setPicture(self.d14)
      elseif onesDigit == 7 then
        self.uiObj.setPicture(self.d11)
      elseif onesDigit == 8 then
        self.uiObj.setPicture(self.d8)
      elseif onesDigit == 14 then
        self.uiObj.setPicture(self.d14)
      else
        self.uiObj.setPicture(self.d11)
    end
  end

  SMG1.ImageNumberDisplayManderMode = subclass(SimpleElement)

  function SMG1.ImageNumberDisplayManderMode:init(window, numberMemoryValue)
    self.numberMemoryValue = numberMemoryValue

  InputDirectory = RWCEMainDirectory .. '/ManderMode'
    self.d0 = createPicture()
  self.d0:loadFromFile(InputDirectory .. '/layout.png')

      self.uiObj = createImage(window)
      self.uiObj:setSize(416, 102)
  end

  function SMG1.ImageNumberDisplayManderMode:update()
   local number = self.numberMemoryValue:get()
   local onesDigit = number % 1000
      if onesDigit == 0 then
        self.uiObj.setPicture(self.d0)
      else
        self.uiObj.setPicture(self.d0)
    end
  end



GV.stageTimeFrames =
  MV("Race Time, frames", 0x9C38C0, SMG1.StaticValue, IntType)



-- Position, velocity, and other coordinates related stuff.
GV.pos = V(
  Vector3Value,
  MV("Pos X", 0x0, SMG1.PosBlockValue, FloatType),
  MV("Pos Y", 0x4, SMG1.PosBlockValue, FloatType),
  MV("Pos Z", 0x8, SMG1.PosBlockValue, FloatType)
)
GV.pos.label = "Position"
GV.pos.displayDefaults = {signed=true, beforeDecimal=5, afterDecimal=1}

-- Position, velocity, and other coordinates related stuff.
GV.posGhost= V(
  Vector3Value,
  MV("X Pos ", 0x4, SMG1.PosBlockValue, FloatType),
  MV("Y Pos ", 0x8, SMG1.PosBlockValue, FloatType),
  MV("Z Pos ", 0xC, SMG1.PosBlockValue, FloatType)
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
  MV("Airtime:", 0x604, SMG1.RefValue, IntType)
GV.vehiclespeed =
  MV("Vehicle speed:", 0x40C, SMG1.RefValue, FloatType)
GV.mtcharge=
  MV("MT Charge:", 0x4EA, SMG1.RefValue, ShortType)
GV.checkpoint=
  MV("CheckPoint ID:", 0xF7, SMG1.ckptValue, ByteType)
GV.keycheckpoint=
  MV("Key CheckPoint ID:", 0x113, SMG1.ckptValue, ByteType)
GV.lapcompleted=
  MV("Lap Completion:", 0xFC, SMG1.ckptValue, FloatType)
GV.mtboost=
  MV("MT Boost:", 0x4EF, SMG1.RefValue, ByteType)
GV.mushroomboost=
  MV("Mushroom Boost:", 0x4FD, SMG1.RefValue, ByteType)
GV.trickboost=
  MV("Trick Boost:", 0x501, SMG1.RefValue, ByteType)
  GV.ABLRInput=
    MV("Buttons:", 0x2841, SMG1.MEMValue, ByteType)
  GV.horizontal=
    MV("Horizontal:", 0x284C, SMG1.MEMValue, ByteType)
  GV.vertical=
    MV("Vertical:", 0x284D, SMG1.MEMValue, ByteType)
  GV.DPAD=
    MV("DPAD:", 0x284F, SMG1.MEMValue, ByteType)

    --For when racing a ghost
    GV.gtairtime=
      MV("Airtime:", 0x608, SMG1.RefValue, IntType)
    GV.gtvehiclespeed=
      MV("Vehicle speed:", 0x410, SMG1.RefValue, FloatType)
    GV.gtmtcharge=
      MV("MT Charge:", 0x4EE, SMG1.RefValue, ShortType)
    GV.gtcheckpoint=
      MV("CheckPoint ID:", 0xFB, SMG1.ckptValue, ByteType)
    GV.gtkeycheckpoint=
      MV("Key CheckPoint ID:", 0x117, SMG1.ckptValue, ByteType)
    GV.lapcompleted=
      MV("Lap Completion:", 0xFC, SMG1.ckptValue, FloatType)
    GV.gtmtboost=
      MV("MT Boost:", 0x4F3, SMG1.RefValue, ByteType)
    GV.gtmushroomboost=
      MV("Mushroom Boost:", 0x501, SMG1.RefValue, ByteType)
    GV.gttrickboost=
      MV("Trick Boost:", 0x505, SMG1.RefValue, ByteType)
        GV.posGhost= V(
          Vector3Value,
          MV("Pos X", 0x4, SMG1.PosBlockValue, FloatType),
          MV("Pos Y", 0x8, SMG1.PosBlockValue, FloatType),
          MV("Pos Z", 0xC, SMG1.PosBlockValue, FloatType)
        )
        GV.pos_early1.label = "Position"
        GV.pos_early1.displayDefaults =
          {signed=true, beforeDecimal=5, afterDecimal=1}





    --mandermode stuff
    --gspeed is address of speed when racing against a Ghost

    GV.speed=
      MV("", 0x40C, SMG1.RefValue, FloatType)
    GV.mt=
      MV("", 0x4EA, SMG1.RefValue, ShortType)
    GV.gspeed=
      MV("", 0x410, SMG1.RefValue, FloatType)
    GV.gmt=
      MV("", 0x4EE, SMG1.RefValue, ShortType)
    GV.DPADmandermode=
      MV("", 0x284F, SMG1.MEMValue, ByteType)
        --this address is used for the background image
        GV.kmh=
        MV("", 0x1550, SMG1.StaticValue, ByteType)

    function GV.mt:displayValue(options)
      return utils.floatToStr(self:get(), {trimTrailingZeros=true, beforeDecimal=4, leftPaddingMethod='space'})
    end

    function GV.mtcharge:displayValue(options)
      return utils.floatToStr(self:get(), {trimTrailingZeros=true, beforeDecimal=4, leftPaddingMethod='space'})
    end

    function GV.gtmtcharge:displayValue(options)
      return utils.floatToStr(self:get(), {trimTrailingZeros=true, beforeDecimal=4, leftPaddingMethod='space'})
    end

    function GV.gmt:displayValue(options)
      return utils.floatToStr(self:get(), {trimTrailingZeros=true, beforeDecimal=4, leftPaddingMethod='space'})
    end




return SMG1
