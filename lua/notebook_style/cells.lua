local M = {}

--- Find all cell delimiters in the buffer
--- @param bufnr number Buffer number
--- @param pattern string Delimiter pattern
--- @return table List of line numbers where delimiters are found
function M.find_delimiters(bufnr, pattern)
  local delimiters = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for i, line in ipairs(lines) do
    if line:match(pattern) then
      table.insert(delimiters, i - 1)  -- 0-indexed
    end
  end

  return delimiters
end

--- Get cell boundaries from delimiter positions
--- @param bufnr number Buffer number
--- @param delimiters table List of delimiter line numbers
--- @param total_lines number Total lines in buffer
--- @return table List of cells with start and end line numbers
function M.get_cells(bufnr, delimiters, total_lines)
  local cells = {}

  if #delimiters < 2 then
    return cells
  end

  local all_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Group delimiters in pairs (start and end)
  for i = 1, #delimiters - 1, 2 do
    local start_line = delimiters[i]
    local end_line = delimiters[i + 1]

    table.insert(cells, {
      delimiter = start_line,
      start_line = start_line,
      end_line = end_line,
      end_delimiter = end_line,
    })
  end

  return cells
end

--- Check if a cell is valid (has content beyond delimiter)
--- @param cell table Cell with start_line and end_line
--- @return boolean True if cell has content
function M.is_valid_cell(cell)
  return cell.end_line > cell.start_line
end

return M
