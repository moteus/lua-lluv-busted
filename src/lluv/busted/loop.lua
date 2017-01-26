local uv = require'lluv'

local loop = {}

loop.create_timer = function(secs, on_timeout)
  local timer

  timer = uv.timer():start(secs * 1000, function(self)
    timer:close()
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
