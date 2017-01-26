local uv = require "lluv"

local loop = require "lluv.busted.loop"

loop.set_timeout(10)

setloop(loop)

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

  it('should pass timeout', function(done) async()
    uv.timer():start(5000, function()
      assert.is_true(true)
      done()
    end)
  end)

  after_each(function()
    loop.verify_after()
  end)
end)