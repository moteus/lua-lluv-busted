local uv = require "lluv"

setloop(require "lluv.busted.loop")

describe("basic test", function()
  it('should pass', function(done) async()
    uv.timer():start(100, function()
      assert.is_true(true)
      done()
    end)
  end)

  it('should ignore unrefed handles', function(done) async()
    uv.timer():start(100, function()
      assert.is_true(true)
      done()
    end)
    uv.signal():start(uv.SIGINT, function() end):unref()
  end)

  -- it('timeout', function(done) async() end)

  after_each(function(done) async()
    uv.handles(function(handle)
      if not(handle:closed() or handle:closing()) then
        if handle:active() then
          if not handle:has_ref() then
            -- we has no reference so assume we just can close it
            -- and it is not error in test
            return handle:close()
          end
          assert.truthy(false, 'Test leave active handle:' .. tostring(handle))
        end
      end
    end)

    done()
  end)
end)