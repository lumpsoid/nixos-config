local hop = require('hop')
local jump_regex = require('hop.jump_regex')
local mkdnflow_links = require('mkdnflow.links')

local M = {}

function M.hint_wikilink_follow()
  hop.hint_with_regex(
    jump_regex.regex_by_case_searching("[[", true, hop.opts),
    hop.opts,
    function(jt)
      hop.move_cursor_to(jt, hop.opts)
      mkdnflow_links.followLink()
    end
  )
end

return M
