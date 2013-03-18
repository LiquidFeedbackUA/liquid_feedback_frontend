Delegation = mondelefant.new_class()
Delegation.table = 'delegation'

Delegation:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'truster_id',
  that_key      = 'id',
  ref           = 'truster',
}

Delegation:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'trustee_id',
  that_key      = 'id',
  ref           = 'trustee',
}

Delegation:add_reference{
  mode          = 'm1',
  to            = "Unit",
  this_key      = 'unit_id',
  that_key      = 'id',
  ref           = 'unit',
}

Delegation:add_reference{
  mode          = 'm1',
  to            = "Area",
  this_key      = 'area_id',
  that_key      = 'id',
  ref           = 'area',
}

Delegation:add_reference{
  mode          = 'm1',
  to            = "Issue",
  this_key      = 'issue_id',
  that_key      = 'id',
  ref           = 'issue',
}

-- get all delegations
function Delegation:by_pk(truster_id, unit_id, area_id, issue_id)
  local selector = self:new_selector()
  selector:add_where{ "truster_id = ?", truster_id }
  if unit_id then
    selector:add_where{ "unit_id = ?",    unit_id }
  else
    selector:add_where("unit_id ISNULL")
  end
  if area_id then
    selector:add_where{ "area_id = ?",    area_id }
  else
    selector:add_where("area_id ISNULL")
  end
  if issue_id then
    selector:add_where{ "issue_id = ? ",  issue_id }
  else
    selector:add_where("issue_id ISNULL")
  end
  selector:add_order_by("preference")
  return selector:exec()
end

function Delegation:by_trustee(truster_id, trustee_id, unit_id, area_id, issue_id)
  local selector = self:new_selector()
  selector:optional_object_mode()
  selector:add_where{ "truster_id = ?", truster_id }
  selector:add_where{ "trustee_id = ?", trustee_id }
  if unit_id then
    selector:add_where{ "unit_id = ?",    unit_id }
  else
    selector:add_where("unit_id ISNULL")
  end
  if area_id then
    selector:add_where{ "area_id = ?",    area_id }
  else
    selector:add_where("area_id ISNULL")
  end
  if issue_id then
    selector:add_where{ "issue_id = ? ",  issue_id }
  else
    selector:add_where("issue_id ISNULL ")
  end
  return selector:exec()
end

-- number of delegations in one preference list
function Delegation:count(truster_id, unit_id, area_id, issue_id)
  local selector = self:new_selector()
  selector:add_where{ "truster_id = ?", truster_id }
  if unit_id then
    selector:add_where{ "unit_id = ?",    unit_id }
  else
    selector:add_where("unit_id ISNULL")
  end
  if area_id then
    selector:add_where{ "area_id = ?",    area_id }
  else
    selector:add_where("area_id ISNULL")
  end
  if issue_id then
    selector:add_where{ "issue_id = ? ",  issue_id }
  else
    selector:add_where("issue_id ISNULL")
  end
  return selector:count()
end

function Delegation:selector_for_broken(member_id)
  return Delegation:new_selector()
    :left_join("issue", nil, "issue.id = delegation.issue_id")
    :add_where("issue.id ISNULL OR issue.closed ISNULL")
    :join("member", nil, "delegation.trustee_id = member.id")
    :add_where{"delegation.truster_id = ?", member_id}
    :add_where("member.active = FALSE")
end
