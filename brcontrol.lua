-- Simple automatic BigReactor control program
-- Author: jinks
--
-- Heavily based on code by DW20


local images = {}

if not fs.exists("/touchpoint") then
   shell.run("/openp/github", "get", "lyqyd/Touchpint/master/touchpoint", "/touchpoint")
end
os.loadAPI("touchpoint")

local function findMonitor()
   for p in peripheral.getNames() do
      if type(p) == "string" and p:find("monitor") then
         return p
      end
   end
   error("No monitor found!")
end

local function init()
   if not fs.isDir("/reactorImages") then
      fs.mkDir("/reactorImages")
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
   end

   images["turbineOff"] = paintutils.loadImage("/reactorImages/turbineOff.img")
   images["turbineOn"] = paintutils.loadImage("/reactorImages/turbineOn.img")
   images["rods"] = paintutils.loadImage("/reactorImages/rodsBG.img")
end

init()
