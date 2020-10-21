--- ~ 16Klangs v0.1 ~
-- @oootini October 2020
-- 16 harmonically related sines
-- enc 2 = select step
-- enc 3 = tune step
-- key 2 = grab pitch
-- key 3 = mutate

local sliders = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local amp_sliders = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local edit = 1
local accum = 1
local step = 0
local freq_values = {55, 110, 220, 440, 880, 1760, 3520, 7040, 14080, 55, 110, 220, 440, 880, 1760, 3520}
local amp_values = {0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3}
local phase_values = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

engine.name = '16Klangs'

function init()
  print("loaded 16Klangs engine")
  --engine.freqs(table.unpack(freq_vales))
  --engine.amps(table.unpack(amp_values))
  --engine.phases(table.unpack(phase_values))
end


function enc(n, delta)
  if n == 1 then
    --do something
    mix:delta("output", delta)
  elseif n == 2 then
    accum = (accum + delta) % 16
    --edit is the slider number
    edit = accum
  elseif n == 3 then
    sliders[edit+1] = sliders[edit+1] + delta
    --amp_value is the 0 1 scaled value of the slider
    amp_value = util.clamp(((amp_sliders[edit+1] + delta) * .01), 0.0, 1.0)
    --TODO take the amp_value and apply to each array element
    --set_amp(edit, amp_value)
    if sliders[edit+1] > 32 then sliders[edit+1] = 32 end
    if sliders[edit+1] < 0 then sliders[edit+1] = 0 end
  end
  redraw()
end

function key(n, z)
  if n == 2 and z == 1 then
    sliders[1] = math.floor(math.random()*4)
    for i=2, 16 do
      sliders[i] = sliders[i-1]+math.floor(math.random()*9)-3
    end
    redraw()
  elseif n == 3 and z == 1 then
    for i=1, 16 do
      sliders[i] = sliders[i]+math.floor(math.random()*5)-2
    end
    redraw()
  end
end

function redraw()
  screen.aa(1)
  screen.line_width(2.0)
  screen.clear()

  for i=0, 15 do
    if i == edit then
      screen.level(15)
    else
      screen.level(2)
    end
    screen.move(32+i*4, 48)
    screen.line(32+i*4, 46-sliders[i+1])
    screen.stroke()
  end

  screen.level(10)
  screen.line(32+step*4, 54)
  screen.stroke()

  screen.update()
end
