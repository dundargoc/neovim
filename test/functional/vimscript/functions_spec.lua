-- Tests for misc Vimscript |vimscript-functions|.
--
-- If a function is non-trivial, consider moving its spec to:
--    test/functional/vimscript/<funcname>_spec.lua
--
-- Core "eval" tests live in eval_spec.lua.

local t = require('test.testutil')
local n = require('test.functional.testnvim')()

local clear = n.clear
local eval = n.eval
local matches = t.matches
local is_os = t.is_os

before_each(clear)

it('windowsversion()', function()
  clear()
  matches(is_os('win') and '^%d+%.%d+$' or '^$', eval('windowsversion()'))
end)
