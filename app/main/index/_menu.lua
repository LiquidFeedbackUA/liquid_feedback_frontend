-- this file is used for the drop-down member menu and for the member menu page

ui.tag{ tag = "ul", content = function()

  if app.session.member_id then

    ui.tag{ tag = "li", content = function()

      ui.link{
        text = _"Profile",
        module = "member",
        view = "show",
        id = app.session.member_id
      }

    end }

    ui.tag{ tag = "li", content = function()

      ui.link{
        content = _"Contacts",
        module = 'contact',
        view   = 'list'
      }

    end }

    ui.tag{ tag = "li", content = function()

      ui.link{
        text   = _"Settings",
        module = "member",
        view = "settings"
      }

    end }

    if app.session.member.admin then

      ui.tag{ tag = "li", content = function()

        ui.link{
          text   = _"Admin",
          module = 'admin',
          view   = 'index'
        }

      end }

    end

  end

  for i, lang in ipairs(config.enabled_languages) do

    local langcode

    locale.do_with({ lang = lang }, function()
      langcode = _("[Name of Language]")
    end)

    ui.tag{ tag = "li", content = function()
      ui.link{
        content = _('Select language "#{langcode}"', { langcode = langcode }),
        module = "index",
        action = "set_lang",
        params = { lang = lang },
        routing = {
          default = {
            mode = "redirect",
            module = request.get_module(),
            view = request.get_view(),
            id = param.get_id_cgi(),
            params = param.get_all_cgi()
          }
        }
      }
    end }
  end

end }

