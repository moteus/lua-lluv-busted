local uv = require'lluv'

local loop = {}

local timeout, default_timeout, active_timer

local function close_all_handles()
  uv.handles(function(handle)
    if not(handle:closed() or handle:closing()) then
      return handle:close()
    end
  end)
end

loop.create_timer = function(secs, on_timeout)
  local timer

  default_timeout = secs

  timer = uv.timer():start((timeout or secs) * 1000, function(self)
    close_all_handles()

    assert(timer:closed() or timer:closing())

    timer = nil

    on_timeout()
  end)

  active_timer = timer

  return {
    stop = function()
      if timer then
        timer:stop()
        active_timer, timer = nil
      end
    end
  }
end

-- extension to overwrite 
loop.set_timout = function(secs)
  timeout = secs

  if active_timer then
    active_timer:again(timeout or default_timeout or 1)
  end
end

loop.step = function()
  uv.run()
end

loop.pcall = pcall

return loop
