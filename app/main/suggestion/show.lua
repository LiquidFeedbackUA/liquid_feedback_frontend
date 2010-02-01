local suggestion = Suggestion:by_id(param.get_id())

slot.put_into("title", encode.html(_"Suggestion for initiative: '#{name}'":gsub("#{name}", suggestion.initiative.name) ))

slot.select("actions", function()
  ui.link{
    content = function()
        ui.image{ static = "icons/16/resultset_previous.png" }
        slot.put(_"Back")
    end,
    module = "initiative",
    view = "show",
    id = suggestion.initiative.id,
    params = { tab = "suggestion" }
  }
end)

ui.form{
  attr = { class = "vertical" },
  record = suggestion,
  readonly = true,
  content = function()
    ui.field.text{ label = _"Name",        name = "name" }
    ui.field.text{ label = _"Description", name = "description" }
  end
}

execute.view{
  module = "suggestion",
  view = "_list",
  params = { suggestions_selector = Suggestion:new_selector():add_where{ "id = ?", suggestion.id } }
}

execute.view{
  module = "opinion",
  view = "_list",
  params = { 
    opinions_selector = Opinion:new_selector()
      :add_field("member.name", "member_name")
      :add_where{ "suggestion_id = ?", suggestion.id }
      :join("member", nil, "member.id = opinion.member_id")
      :add_order_by("member.id DESC")
  }
}