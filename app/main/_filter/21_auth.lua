local auth_needed = not (
  request.get_module() == 'index'
  and (
       request.get_view()   == 'login'
    or request.get_action() == 'login'
    or request.get_view()   == "register"
    or request.get_action() == "register"
    or request.get_view()   == "about"
    or request.get_view()   == "reset_password"
    or request.get_action() == "reset_password"
    or request.get_view()   == "confirm_notify_email"
    or request.get_action() == "confirm_notify_email"
    or request.get_action() == "set_lang"
  )
)

-- if not app.session.user_id then
--   trace.debug("DEBUG: AUTHENTICATION BYPASS ENABLED")
--   app.session.user_id = 1
-- end

if auth_needed and app.session.member == nil then
  trace.debug("Not authenticated yet.")
  request.redirect{ module = 'index', view = 'login' }
elseif auth_needed and app.session.member.locked then
  trace.debug("Member locked.")
  request.redirect{ module = 'index', view = 'login' }
else
  if auth_needed then
    trace.debug("Authentication accepted.")
  else
    trace.debug("No authentication needed.")
  end

  --db:query("SELECT check_everything()")

  execute.inner()
  trace.debug("End of authentication filter.")
end
