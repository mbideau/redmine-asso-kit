module ZZEcloserieCustomizations
  class HookListener < Redmine::Hook::ViewListener
  	render_on(:view_layouts_base_html_head, partial: 'global_html_header')
  	render_on(:view_layouts_base_body_top, partial: 'global_body_header')
    render_on(:view_layouts_base_body_bottom, partial: 'go_to_top')

  	render_on(:view_account_login_bottom, partial: 'login_message')
  	render_on(:view_issues_new_top, partial: 'new_task_message')

	def self.settings
	  Setting[:plugin_zz_asso_kit]
	end
  end
end

