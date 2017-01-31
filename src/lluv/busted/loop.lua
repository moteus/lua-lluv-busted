local uv = require'lluv'

local loop = {}

local timeout, default_timeout, active_timer, debug_traceback

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

-- !extension to overwrite busted hardcoded value (1s)
loop.set_timeout = function(secs)
  local old = timeout

  timeout = secs or default_timeout or 1

  if active_timer and active_timer:active() then
    active_timer:again(timeout * 1000)
  end

  return old
end

-- !extension to check either after test end there exists handles
--  which may prevent to stop libuv loop
-- @usage 
--   after_each(function(done) async()
--     loop.verify_after()
--     done()
--   end)
loop.verify_after = function ()
  uv.handles(function(handle)
    if not(handle:closed() or handle:closing()) then
      if handle:active() and handle:has_ref() then
        assert.truthy(false, 'Test left active handle: ' .. tostring(handle))
      end
      -- we has no reference so assume we just can close it
      -- and it is not error in test
      return handle:close()
    end
  end)
end

loop.set_traceback = function(traceback)
  debug_traceback = traceback
end

loop.step = function()
  uv.run(debug_traceback)
end

loop.pcall = pcall

return loop
