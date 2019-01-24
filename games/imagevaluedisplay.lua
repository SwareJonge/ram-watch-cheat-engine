package.loaded.layouts = nil
local layouts = require "layouts"
package.loaded.utils = nil
local utils = require "utils"
local readIntBE = utils.readIntBE
local subclass = utils.subclass
local CompoundElement = layouts.CompoundElement
local SimpleElement = layouts.SimpleElement



-- Display a memory value using per-character images (effectively a bitmap font).
local ImageValueDisplay = subclass(CompoundElement)

function ImageValueDisplay:init(window, memoryValue, numCharacters, passedDisplayOptions)
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

function ImageValueDisplay:update()
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


local ImageNumberDisplay = subclass(SimpleElement)

function ImageNumberDisplay:init(window, numberMemoryValue)
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

  function ImageNumberDisplay:update()
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

  local ImageNumberDisplayvertical = subclass(SimpleElement)

  function ImageNumberDisplayvertical:init(window, numberMemoryValue)
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

    function ImageNumberDisplayvertical:update()
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

  local ImageNumberDisplayDPAD = subclass(SimpleElement)

  function ImageNumberDisplayDPAD:init(window, numberMemoryValue)
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

  function ImageNumberDisplayDPAD:update()
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

  function ImageNumberDisplayDPAD:update()
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


  local ImageNumberDisplayABLR = subclass(SimpleElement)

  function ImageNumberDisplayABLR:init(window, numberMemoryValue)
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
  self.d15 = createPicture()
  self.d15:loadFromFile(InputDirectory .. '/ABInput11.png')

      self.uiObj = createImage(window)
      self.uiObj:setSize(74, 37)
  end

  function ImageNumberDisplayABLR:update()
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
        self.uiObj.setPicture(self.d11)
      elseif onesDigit == 8 then
        self.uiObj.setPicture(self.d8)
      elseif onesDigit == 10 then
        self.uiObj.setPicture(self.d10)
      elseif onesDigit == 11 then
        self.uiObj.setPicture(self.d11)
      elseif onesDigit == 14 then
        self.uiObj.setPicture(self.d14)
      else
        self.uiObj.setPicture(self.d15)
    end
  end

  local ImageNumberDisplayManderMode = subclass(SimpleElement)

  function ImageNumberDisplayManderMode:init(window, numberMemoryValue)
    self.numberMemoryValue = numberMemoryValue

  InputDirectory = RWCEMainDirectory .. '/ManderMode'
    self.d0 = createPicture()
  self.d0:loadFromFile(InputDirectory .. '/layout0.png')
    self.d1 = createPicture()
  self.d1:loadFromFile(InputDirectory .. '/layout.png')

      self.uiObj = createImage(window)
      self.uiObj:setSize(416, 102)
  end

  function ImageNumberDisplayManderMode:update()
   local number = self.numberMemoryValue:get()
   local onesDigit = number % 1000
      if onesDigit == 0 then
        self.uiObj.setPicture(self.d0)
      else
        self.uiObj.setPicture(self.d1)
    end
  end


  return {
  ImageValueDisplay = ImageValueDisplay,
  ImageNumberDisplay = ImageNumberDisplay,
  ImageNumberDisplayvertical = ImageNumberDisplayvertical,
  ImageNumberDisplayDPAD = ImageNumberDisplayDPAD,
  ImageNumberDisplayABLR = ImageNumberDisplayABLR,
  ImageNumberDisplayManderMode = ImageNumberDisplayManderMode,
}
