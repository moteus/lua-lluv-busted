local uv = require'lluv'

local loop = {}

local function close_all_handles()
  uv.handles(function(handle)
    if not(handle:closed() or handle:closing()) then
      return handle:close()
    end
  end)
end

loop.create_timer = function(secs, on_timeout)
  local timer

  timer = uv.timer():start(secs * 1000, function(self)
    close_all_handles()

    assert(timer:closed() or timer:closing())

    timer = nil

    on_timeout()
  end)

  return {
    stop = function()
      if timer then
        timer:stop()
        timer = nil
      end
    end
  }
end

loop.step = function()
  uv.run()
end

loop.pcall = pcall

return loop
