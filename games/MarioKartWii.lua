-- Mario Kart Wii



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

package.loaded.imagevaluedisplay = nil
local MKWImageValueDisplay = require "imagevaluedisplay"


local MKW = subclass(SMGshared)

MKW.supportedGameVersions = {
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


MKW.layoutModuleNames = {'MarioKartWii_layouts'}
MKW.framerate = 60
-- Use D-Pad Down to reset max-value displays, average-value displays, etc.
MKW.defaultResetButton = 'v'

function MKW:init(options)
  SMGshared.init(self, options)

  self.addrs = {}
  self.pointerValues = {}
  self:initConstantAddresses()
end

local GV = MKW.blockValues



-- These are addresses that should stay constant for the most part,
-- as long as the game start address is constant.

function MKW:initConstantAddresses()
  -- Start or 'origin' address.
  self.addrs.o = self:getGameStartAddress()

  self.addrs.zeros = self.addrs.o + 0x1700000
  if self.gameId == 'RMCE01' then
    self.playerBase =  0x9BD110
    self.ckptPointerOffset = 0x9B8F70
    self.MEMOffset = 0x429F14
  elseif self.gameId == 'RMCJ01' then
    self.playerBase  =  0x9C0958
    self.ckptPointerOffset = 0x9BC790
    self.MEMOffset = 0x42DC14
  elseif self.gameId == 'RMCP01' then
    self.playerBase  = 0x9C18F8
    self.ckptPointerOffset = 0x9BD730
    self.MEMOffset = 0x42E324
  elseif self.gameId == 'RMCK01' then
    self.playerBase = 0x9AFF38
    self.ckptPointerOffset = 0x9ABD70
    self.MEMOffset = 0x41C2B4
  end
end

--RaceData(speed etc.)
function MKW:updateplayerBase()
  -- Not sure what this is meant to point to exactly, but when this pointer
  -- changes value, some other relevant addresses
  -- move by the same amount as the value change.
  self.addrs.playerBaseAddress =
    self.addrs.o
    + readIntBE(self.addrs.o + self.playerBase , 4)
    - 0x80000000
end

function MKW:updateplayerBasePointer1()
  -- Another reference pointer, which can be used to find position values.

  local ptrValue = readIntBE(self.addrs.playerBaseAddress + 0x20, 4)

  if ptrValue < 0x80000000 or ptrValue > 0x90000000 then
    -- Rough check that we do not have a valid pointer. This happens when
    -- switching between Mario and Luigi. In this case, we'll give up
    -- on finding the position and read a bunch of zeros instead.
    self.addrs.playerBaselvl1 = "Invalid Value"
  end

  self.addrs.playerBaselvl1 = self.addrs.o + ptrValue - 0x80000000
end

function MKW:updateplayerBasePointer2()
  -- Another reference pointer, which can be used to find position values.

  local ptrValue = readIntBE(self.addrs.playerBaselvl1 + 0x0, 4)

  if ptrValue < 0x80000000 or ptrValue > 0x90000000 then
    -- Rough check that we do not have a valid pointer. This happens when
    -- switching between Mario and Luigi. In this case, we'll give up
    -- on finding the position and read a bunch of zeros instead.
    self.addrs.playerBaselvl2 = self.addrs.zeros
  end

  self.addrs.playerBaselvl2 = self.addrs.o + ptrValue - 0x80000000
end

function MKW:updateplayerBasePointer3()
  -- Another reference pointer, which can be used to find position values.

  local ptrValue = readIntBE(self.addrs.playerBaselvl2 + 0x10, 4)

  if ptrValue < 0x80000000 or ptrValue > 0x90000000 then
    -- Rough check that we do not have a valid pointer. This happens when
    -- switching between Mario and Luigi. In this case, we'll give up
    -- on finding the position and read a bunch of zeros instead.
    self.addrs.playerBaselvl3 = self.addrs.zeros
  end

  self.addrs.playerBaselvl3 = self.addrs.o + ptrValue - 0x80000000
end

function MKW:updateplayerBasePointer4()
  -- Another reference pointer, which can be used to find position values.

  local ptrValue = readIntBE(self.addrs.playerBaselvl3 + 0x10, 4)

  if ptrValue < 0x80000000 or ptrValue > 0x90000000 then
    -- Rough check that we do not have a valid pointer. This happens when
    -- switching between Mario and Luigi. In this case, we'll give up
    -- on finding the position and read a bunch of zeros instead.
    self.addrs.playerBaselvl4 = self.addrs.zeros
  end

  self.addrs.playerBaselvl4 = self.addrs.o + ptrValue - 0x80000000
end


--CKPT Data
function MKW:updateckptPointer()
  self.addrs.ckptPointer =
    self.addrs.o
    + readIntBE(self.addrs.o + self.ckptPointerOffset, 4)
    - 0x80000000
end

function MKW:updateckptlvl1Pointer()
  local ptrValue = readIntBE(self.addrs.ckptPointer + 0xAC, 4)

  if ptrValue < 0x80000000 or ptrValue > 0x90000000 then
    self.addrs.ckptlvl1Pointer = self.addrs.zeros
  end

  self.addrs.ckptlvl1Pointer = self.addrs.o + ptrValue - 0x80000000
end

--Input Data
function MKW:updateMEMPointer()
  self.addrs.MEMAddress =
    self.addrs.o
    + readIntBE(self.addrs.o + self.MEMOffset , 4)
    - 0x80000000
end


function MKW:updateAddresses()
  self:updateplayerBase()
  self:updateplayerBasePointer1()
  self:updateplayerBasePointer2()
  self:updateplayerBasePointer3()
  self:updateplayerBasePointer4()
  self:updateckptPointer()
  self:updateckptlvl1Pointer()
  self:updateMEMPointer()
end



-- Values at static addresses (from the beginning of the game memory).
MKW.StaticValue = subclass(MemoryValue)

function MKW.StaticValue:getAddress()
  return self.game.addrs.o + self.offset
end

-- Values that are a constant offset from the ckptPointer.

MKW.playerBaseValue5 = subclass(MemoryValue)

function MKW.playerBaseValue5:getAddress()
  return self.game.addrs.playerBaselvl4 + self.offset
end

MKW.ckptlvl1Value = subclass(MemoryValue)

function MKW.ckptlvl1Value:getAddress()
  return self.game.addrs.ckptlvl1Pointer + self.offset
end

--mem2 area
MKW.MEMValue = subclass(MemoryValue)

function MKW.MEMValue:getAddress()
  return self.game.addrs.MEMAddress + self.offset
end

-- Values that are a constant small offset from the position values' location.


 GV.stageTimeFrames =
  MV("Race Time, frames", 0x9BF0B8, MKW.StaticValue, IntType)

  GV.mtboost=
    MV("MT Boost:", 0x103, MKW.playerBaseValue5, ByteType)
  GV.mushroomboost=
    MV("Mushroom Boost:", 0x149, MKW.playerBaseValue5, ByteType)
  GV.trickboost=
    MV("Trick Boost:", 0x115, MKW.playerBaseValue5, ByteType)


-- Position, velocity, and other coordinates related stuff.
GV.pos = V(
  Vector3Value,
  MV("Pos X", 0x1450, MKW.playerBaseValue5, FloatType),
  MV("Pos Y", 0x1454, MKW.playerBaseValue5, FloatType),
  MV("Pos Z", 0x1458, MKW.playerBaseValue5, FloatType)
)
GV.pos.label = "Position"
GV.pos.displayDefaults =
 {signed=true, beforeDecimal=5, afterDecimal=1}

-- Position, velocity, and other coordinates related stuff.


GV.pos_early1 = V(
  Vector3Value,
  MV("Pos X", 0x1450, MKW.playerBaseValue5, FloatType),
  MV("Pos Y", 0x1454, MKW.playerBaseValue5, FloatType),
  MV("Pos Z", 0x1458, MKW.playerBaseValue5, FloatType)
)
GV.pos_early1.label = "Position"
GV.pos_early1.displayDefaults =
  {signed=true, beforeDecimal=5, afterDecimal=1}



--Global values
GV.airtime=
  MV("Airtime:", 0x21A, MKW.playerBaseValue5, ShortType)
GV.vehiclespeed =
  MV("Vehicle speed:", 0x20, MKW.playerBaseValue5, FloatType)
GV.mtcharge=
  MV("MT Charge:", 0xFE, MKW.playerBaseValue5, ShortType)
GV.checkpoint=
  MV("CheckPoint ID:", 0xA, MKW.ckptlvl1Value, ShortType)
GV.keycheckpoint=
  MV("Key CheckPoint ID:", 0x27, MKW.ckptlvl1Value, ByteType)
GV.lapcompleted=
  MV("Lap Completion:", 0xC, MKW.ckptlvl1Value, FloatType)

--Input
GV.ABLRInput=
  MV("Buttons:", 0x2841, MKW.MEMValue, ByteType)
GV.horizontal=
  MV("Horizontal:", 0x285C, MKW.MEMValue, FloatType)
GV.vertical=
  MV("Vertical:", 0x2860, MKW.MEMValue, FloatType)
GV.DPAD=
  MV("DPAD:", 0x284F, MKW.MEMValue, ByteType)

  GV.horizontalbyte=
    MV("Horizontal:", 0x284C, MKW.MEMValue, ByteType)
  GV.verticalbyte=
    MV("Vertical:", 0x284D, MKW.MEMValue, ByteType)

    --mandermode stuff

    GV.speed=
      MV("", 0x20, MKW.playerBaseValue5, FloatType)
    GV.mt=
      MV("", 0xFE, MKW.playerBaseValue5, ShortType)
    GV.DPADmandermode=
      MV("", 0x284F, MKW.MEMValue, ByteType)
        --this address is used for the background image
        GV.kmh=
        MV("", 0x9BD110, MKW.StaticValue, ByteType)

    function GV.mt:displayValue(options)
      return utils.floatToStr(self:get(), {trimTrailingZeros=true, beforeDecimal=4, leftPaddingMethod='space'})
    end

    function GV.mtcharge:displayValue(options)
      return utils.floatToStr(self:get(), {trimTrailingZeros=true, beforeDecimal=4, leftPaddingMethod='space'})
    end


return MKW
