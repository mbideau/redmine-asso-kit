def render_account_menu_dropdown()
  html = []
  html << '<ul class="menu-children">'
  menu_items_for(:account_menu, nil) do |node|
    html << render_menu_node(node, nil)
  end
  html.empty? ? '' : html.join("\n").html_safe
end

def add_top_menu_custom_item(i, user_roles)
	menu_name = 'custom_menu' + i.to_s
	item = {
		url: Setting.plugin_zz_asso_kit[menu_name + '_url'],
		name: Setting.plugin_zz_asso_kit[menu_name + '_name'],
		title: Setting.plugin_zz_asso_kit[menu_name + '_title'],
		roles: Setting.plugin_zz_asso_kit[menu_name + '_roles']
	}

	unless item[:name].blank? || item[:url].blank? || item[:roles].nil?
		show_entry = false
		item[:roles].each do |role|
			if user_roles.empty? && role.to_i == Role::BUILTIN_ANONYMOUS
				show_entry = true
				break
			elsif User.current.logged? && role.to_i == Role::BUILTIN_NON_MEMBER
				# if user is logged in and non_member is active in item,
				# always show it
				show_entry = true
				break
			end

			user_roles.each do |user_role|
				if role.to_i == user_role.id.to_i
					show_entry = true
					break
				end
			end
			break if show_entry == true
		end
		handle_top_menu_item(menu_name, item, show_entry)
	end
end

def handle_top_menu_item(menu_name, item, show_entry = false)
	if !Redmine::MenuManager.map(:top_menu).exists?(menu_name.to_sym)
		if show_entry
			html_options = {}
			html_options[:class] = 'external' if item[:url].include? '://'
			html_options[:title] = item[:title] unless item[:title].blank?
			Redmine::MenuManager.map(:top_menu).push menu_name,
														item[:url],
														caption: item[:name].to_s,
														html: html_options,
														before: :help
		end
	end
end

def add_project_custom_menu(item_name, menu_name, text, position, url)
	if !Redmine::MenuManager.map(menu_name).exists?(item_name.to_sym)
		html_options = {}
		html_options[:class] = 'external' if url.include? '://'
		options = {
			caption: text,
			html: html_options
		}
		if position && !position.blank?
			position_mark, position_ref = /^ *(first|last|after|before|parent) *:? *([a-zA-Z0-9_-]+)? *$/.match(position).captures
		end
		if !position_mark || position_mark.blank?
			position_mark = 'last'
		end
		if !position_ref || position_ref.blank?
			position_ref = true
		end
		if position_ref === true 
			options[position_mark.to_sym] = position_ref
		else
			options[position_mark.to_sym] = position_ref.to_sym
		end
		#puts "[DEBUG] adding #{menu_name}:#{item_name} @#{position_mark}:#{position_ref} [#{text}] -> #{url}"
		Redmine::MenuManager.map(menu_name).push item_name.to_sym, url, options
	end
end
