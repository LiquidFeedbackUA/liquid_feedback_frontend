function ui.bargraph(args)
  local text = ""
  for i, bar in ipairs(args.bars) do
    if #text > 0 then
      text = text .. " / "
    end
    text = text .. tostring(bar.value)
  end
  ui.container{
    attr = {
      class = args.class or "bargraph",
      title = tostring(text)
    },
    content = function()
      local at_least_one_bar = false
      local quorum = args.quorum and args.quorum * args.width / args.max_value or nil
      local length = 0
      for i, bar in ipairs(args.bars) do
        if bar.value > 0 then
          at_least_one_bar = true
          local value = bar.value * args.width / args.max_value
          if quorum and quorum < length + value then
            local dlength = math.max(quorum - length - 1, 0)
            if dlength > 0 then
              ui.container{
                attr = {
                  style = "width: " .. tostring(dlength) .. "px; background-color: " .. bar.color .. ";",
                },
                content = function() slot.put("&nbsp;") end
              }
            end
            ui.container{
              attr = {
                class = "quorum",
                style = "width: 1px; background-color: " .. (args.quorum_color or "blue") ..";",
              },
              content = function() slot.put("") end
            }
            length = dlength + 1
            value = value - dlength
            quorum = nil
          end
          length = length + value
          ui.container{
            attr = {
              style = "width: " .. tostring(value) .. "px; background-color: " .. bar.color .. ";",
            },
            content = function() slot.put("&nbsp;") end
          }
        end
      end
      if not at_least_one_bar then
        slot.put("&nbsp;")
      end
    end
  }
end
