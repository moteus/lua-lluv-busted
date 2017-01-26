# lluv-busted
[![Licence](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](LICENSE)
[![Build Status](https://travis-ci.org/moteus/lua-lluv-busted.svg?branch=master)](https://travis-ci.org/moteus/lua-lluv-busted)

Support async tests for busted with lluv library

#### Usage

```Lua
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
```