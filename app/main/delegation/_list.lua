local delegations_selector = param.get("delegations_selector", "table")
local outgoing = param.get("outgoing", atom.boolean)
local incoming = param.get("incoming", atom.boolean)

local function delegation_scope(delegation)
  ui.container{
    attr = { class = "delegation_scope" },
    content = function()
      local area
      if delegation.issue then
        area = delegation.issue.area
      else
        area = delegation.area
      end
      if not area then
        ui.field.text{ value = _"Global delegation" }
      end
      if area then
        ui.link{
          content = _"Area '#{name}'":gsub("#{name}", area.name),
          module = "area",
          view = "show",
          id = area.id
        }
      end
      if delegation.issue then
        ui.link{
          content = _"Issue ##{id}":gsub("#{id}", delegation.issue.id),
          module = "issue",
          view = "show",
          id = delegation.issue.id
        }
      end
    end
  }
end


ui.paginate{
  selector = delegations_selector,
  content = function()
    for i, delegation in ipairs(delegations_selector:exec()) do
      ui.container{
        attr = { class = "delegation_list_entry" },
        content = function()
          if outgoing then
            delegation_scope(delegation)
          else
            execute.view{
              module = "member",
              view = "_show_thumb",
              params = { member = delegation.truster }
            }
          end
          ui.image{
            attr = { class = "delegation_arrow" },
            static = "delegation_arrow.jpg"
          }
          if incoming then
            delegation_scope(delegation)
          else
            execute.view{
              module = "member",
              view = "_show_thumb",
              params = { member = delegation.trustee }
            }
          end
        end
      }
    end
    slot.put("<br style='clear: left;' />")
  end
}
