local issue_id = assert(param.get("issue_id", atom.integer), "no issue id given")

local interest = Interest:by_pk(issue_id, app.session.member.id)

local issue = Issue:new_selector():add_where{ "id = ?", issue_id }:for_share():single_object_mode():exec()

if issue.closed then
  slot.put_into("error", _"This issue is already closed.")
  return false
elseif issue.fully_frozen then 
  slot.put_into("error", _"Voting for this issue has already begun.")
  return false
end

if param.get("delete", atom.boolean) then
  if interest then
    interest:destroy()
    slot.put_into("notice", _"Interest removed")
  else
    slot.put_into("notice", _"Interest not existant")
  end
  return
end

if not interest then
  interest = Interest:new()
  interest.issue_id   = issue_id
  interest.member_id  = app.session.member_id
  interest.autoreject = false
end

interest.autoreject = param.get("autoreject", atom.boolean)

interest:save()

slot.put_into("notice", _"Interest updated")