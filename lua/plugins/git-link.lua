return {
  'juacker/git-link.nvim',
  opts = {
    url_rules = {
      -- SQPC GitLab rule
      -- origin  ssh://git@gitlab.sqpc.sqrpnt.com:2222/data/data-platform/spde/de-spde.git (fetch)
      -- we want:
      -- e.g. https://gitlab.sqpc.sqrpnt.com/data/data-platform/spde/de-spde/-/blob/master/spde/src/spde/_assets/_cli/_client.py?ref_type=heads#L9
      -- e.g. https://gitlab.sqpc.sqrpnt.com/data/data-platform/spde/de-spde/-/blob/master/spde/src/spde/_assets/_cli/_client.py?ref_type=heads#L9-17
      {
        pattern = '^ssh://git@gitlab.sqpc.sqrpnt.com:%d+/(.+).git$',
        replace = 'https://gitlab.sqpc.sqrpnt.com/%1/-/blob',
        format_url = function(base_url, params)
          -- For single line
          if params.start_line == params.end_line then
            return string.format('%s/%s/%s?ref_type=heads#L%d', base_url, params.branch, params.file_path, params.start_line)
          else
            -- For line ranges
            return string.format('%s/%s/%s?ref_type=heads#L%d-%d', base_url, params.branch, params.file_path, params.start_line, params.end_line)
          end
        end,
      },
    },
  },
  keys = {
    {
      '<leader>gw',
      function()
        require('git-link.main').copy_line_url()
      end,
      desc = 'Copy code link to clipboard',
      mode = { 'n', 'x' },
    },
  },
}
