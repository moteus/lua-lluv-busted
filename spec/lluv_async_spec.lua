local uv = require "lluv"

setloop(require "lluv.busted.loop")

describe("basic test", function()
  it('should pass', function(done) async()
    uv.timer():start(100, function()
      assert.is_true(true)
      done()
    end)
  end)
end)