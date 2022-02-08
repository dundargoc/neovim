local helpers = require('test.functional.helpers')(after_each)
local child_session = require('test.functional.terminal.helpers')
local clear = helpers.clear
local nvim_dir = helpers.nvim_dir

describe("shell command :!", function()
  local screen
  before_each(function()
    clear()
    screen = child_session.screen_setup(0, '["'..helpers.nvim_prog..
      '", "-u", "NONE", "-i", "NONE", "--cmd", "'..helpers.nvim_set..'"]')
    screen:expect([[
      {1: }                                                 |
      {4:~                                                 }|
      {4:~                                                 }|
      {4:~                                                 }|
      {4:~                                                 }|
                                                        |
      {3:-- TERMINAL --}                                    |
    ]])
  end)

  after_each(function()
    child_session.feed_data("\3") -- Ctrl-C
  end)

  it("displays output without LF/EOF. #4646 #4569 #3772", function()
    if helpers.pending_win32(pending) then return end
    -- NOTE: We use a child nvim (within a :term buffer)
    --       to avoid triggering a UI flush.
    child_session.feed_data(":!printf foo; sleep 200\n")
    screen:expect([[
                                                        |
      {4:~                                                 }|
      {4:~                                                 }|
      {5:                                                  }|
      :!printf foo; sleep 200                           |
      foo                                               |
      {3:-- TERMINAL --}                                    |
    ]])
  end)

  it("throttles shell-command output greater than ~10KB", function()
    if 'openbsd' == helpers.uname() then
      pending('FIXME #10804')
    end
    child_session.feed_data(":!"..nvim_dir.."/shell-test REP 30001 foo\n")

    -- If we observe any line starting with a dot, then throttling occurred.
    -- Avoid false failure on slow systems.
    screen:expect{any="\n%.", timeout=20000}

    -- Final chunk of output should always be displayed, never skipped.
    -- (Throttling is non-deterministic, this test is merely a sanity check.)
    screen:expect([[
      29997: foo                                        |
      29998: foo                                        |
      29999: foo                                        |
      30000: foo                                        |
                                                        |
      {10:Press ENTER or type command to continue}{1: }          |
      {3:-- TERMINAL --}                                    |
    ]], {
      -- test/functional/helpers.lua defaults to background=light.
      [1] = {reverse = true},
      [3] = {bold = true},
      [10] = {foreground = 2},
    })
  end)
end)
