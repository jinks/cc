-- Simple automatic BigReactor control program
-- Author: jinks
--
-- Heavily based on code by DW20

local config = {
   numCapacitors = 8,
   turnOnAt = 50,
   turnOffAt = 90
}


-- fetch and load APIs
if not fs.exists("/touchpoint") then
   shell.run("/openp/github", "get", "lyqyd/Touchpoint/master/touchpoint", "/touchpoint")
end
os.loadAPI("touchpoint")

if not fs.exists("/drawmon") then
   shell.run("/openp/github", "get", "jinks/cc/master/drawmon.lua", "/drawmon")
end
os.loadAPI("drawmon")

local monitor = peripheral.wrap(findMonitor())
local powerStorage = peripheral.find("tile_blockcapacitorbank_name")
local reactor = peripheral.find("BigReactors-Reactor")
local turbines = {peripheral.find("BigReactors-Turbine")}

local steamReactor = reactor and reactor.isActivelyCooled()
local images = {}
local energy = {}
local turbineData = {}

local reactorPage = touchpoint.new(findMonitor())
local turbinePage = touchpoint.new(findMonitor())

local function findMonitor()
   for _,p in pairs(peripheral.getNames()) do
      if type(p) == "string" and p:find("monitor") then
         return p
      end
   end
   error("No monitor found!")
end

local function init()
   if not fs.isDir("/reactorImages") then
      fs.makeDir("/reactorImages")
   end
   if not fs.exists("/reactorImages/turbineOff.img") then
      img = fs.open("/reactorImages/turbineOff.img","w")
      img.writeLine("7777777")
      img.writeLine("7887887")
      img.writeLine("7877787")
      img.writeLine("7887887")
      img.writeLine("7877787")
      img.writeLine("7887887")
      img.writeLine("7877787")
      img.writeLine("7887887")
      img.writeLine("78b7b87")
      img.writeLine("78b7b87")
      img.writeLine("78b7b87")
      img.write("7777777")
      img.close()
   end
   if not fs.exists("/reactorImages/turbineOn.img") then
      img = fs.open("/reactorImages/turbineOn.img","w")
      img.writeLine("7777777")
      img.writeLine("7887887")
      img.writeLine("7877787")
      img.writeLine("7887887")
      img.writeLine("7877787")
      img.writeLine("7887887")
      img.writeLine("7877787")
      img.writeLine("7887887")
      img.writeLine("78e7e87")
      img.writeLine("78e7e87")
      img.writeLine("78e7e87")
      img.write("7777777")
      img.close()
   end
   if not fs.exists("/reactorImages/rodsBG.img") then
      img = fs.open("reactorImages/rodsBG.img","w")
      img.writeLine("7777777")
      img.writeLine("7444447")
      img.writeLine("7444447")
      img.writeLine("7444447")
      img.writeLine("7444447")
      img.writeLine("7444447")
      img.writeLine("7444447")
      img.writeLine("7444447")
      img.writeLine("7444447")
      img.writeLine("7444447")
      img.writeLine("7444447")
      img.write("7777777")
      img.close()
   end

   images["turbineOff"] = paintutils.loadImage("/reactorImages/turbineOff.img")
   images["turbineOn"] = paintutils.loadImage("/reactorImages/turbineOn.img")
   images["rods"] = paintutils.loadImage("/reactorImages/rodsBG.img")
end

function checkEn()
   energy.stored = powerStorage.getEnergyStored()
   energy.maxStored = powerStorage.getMaxEnergyStored()
   energy.storedPercent = math.floor((energy.stored/energy.maxStored)*100)
   energy.rfProduction = reactor.getEnergyProducedLastTick()
   energy.fuelUse = math.floor(reactor.getFuelConsumedLastTick()*100)/100
   energy.coreTemp = reactor.getFuelTemperature()
   energy.reactorOnline = reactor.getActive()
   local tempEnergy = powerStorage.getEnergyStored()
   sleep(0.1)
   energy.change = ((powerStorage.getEnergyStored()-tempEnergy)/2)*numCapacitors
end

function checkTurbines()
   if steamReactor then
      local online = false
      local avgSpeed = 0
      local rfGen = 0
      local fluidRate = 0
      for _,t in pairs(turbines) do
         if t.getActive() then online = true end
         avgSpeed = avgSpeed + t.getRotorSpeed()
         rfGen = rfGen + t.getEnergyProducedLastTick()
         fluidRate = fluidrate + t.getFluidFlowRate()
      end
      turbineData.online = online
      turbineData.speed = avgSpeed / #turbines
      turbineData.rfGen = rfGen
      turbineData.fluidRate = fluidRate
   end
end

function mainLoop()
   checkEn()
   checkTurbines()
   term.clear()
   print("Storage: "..energy.stored.." / "..energy.maxStored.." ("..energy.storedPercent.."%)")
   print("Change: "..energy.change)
   print()
   print(#turbines.." Turbines @"..turbineData.speed.." avg RPM")
   print("Generating "..turbineData.rfGen.." RF/t from "..turbineData.fluidRate.." mB/t Steam.")
end

init()
-- drawmon.drawImage(monitor, images["turbineOff"],5,1)
