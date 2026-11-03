-- Leave one row between the path and file columns.
local root_layout = Root.layout
function Root:layout()
  root_layout(self)
  local body = #self._chunks - 1
  if self._chunks[body].h < 2 then
    return
  end
  for i = 2, body do
    local area = self._chunks[i]
    self._chunks[i] = ui.Rect {
      x = area.x, y = area.y + 1, w = area.w,
      h = area.h - (i == body and 1 or 0),
    }
  end
end
