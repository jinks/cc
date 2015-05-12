-- paintutils drawPixel/drawImage equivalent for wrapped monitors

function drawPixel(mon, x, y, col)
  if col ~= 0 then
    mon.setBackgroundColor(col)
    mon.setCursorPos(x, y)
    mon.write(" ")
  end
end

function drawImage(mon, image, x, y)
  for y, v in pairs(image) do
    for x, c in pairs(v) do
      drawPixel(mon, x, y, c)
    end
  end
end
