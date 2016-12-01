require 'redmine'
require 'asso_kit'

Redmine::Plugin.register :zz_asso_kit do
  name 'Asso Kit plugin'
  author 'Michael Bideau'
  description 'Customize Redmine to a better UI and translation'
  version '0.0.1'
  url 'https://ecloserie.net/projects/ecloserie/redmine_plugin'
  author_url 'https://michaelbideau.com'

  # required redmine version
  requires_redmine version_or_higher: '3.3.0'

  # -- top menu / home menu : remove
  delete_menu_item(:top_menu, :home)

  # -- top menu / help menu : remove
  delete_menu_item(:top_menu, :help)

  # -- top menu / account menu
  if Redmine::Plugin.installed? :redmine_local_avatars
    menu :account_menu, :my_avatar, { :controller => 'my', :action => 'avatar' }, :caption => :label_my_avatar, :if => Proc.new { User.current.logged? }, :before => :logout
  end

  # -- top menu / user menu
  # move the 'My Page' menu to *new* user_menu
  delete_menu_item(:top_menu, :my_page)
  menu :user_menu, :my_page, { :controller => 'my', :action => 'page' }, :if => Proc.new { User.current.logged? }
  # move the 'My Issues' menu to *new* user_menu
  if Redmine::Plugin.installed? :unread_issues
	delete_menu_item(:top_menu, :us_my_issues)
	menu :user_menu, :us_my_issues, :us_my_issues_url, caption: Proc.new { User.current.my_issues_caption }, if: Proc.new { User.current.logged? }, first: true
  end

  # -- project home is the wiki (not overview)
  # remove 'Overview' project page from the project_menu
  delete_menu_item(:project_menu, :overview)
  # add a new route to redirect project home page to wiki page (preserving the special case *new*)
  RedmineApp::Application.routes.prepend do
    get 'projects/new', :controller => 'projects', :action => 'new'
    get 'projects/:project_id', :controller => 'wiki', :action => 'show'
  end

  # -- project menu / tasks (dropdown)
  # add *new* project menu 'tasks'
  menu :project_menu, :tasks, nil, :caption => :label_issue_plural, :html => { :id => 'tasks', :onclick => 'toggleTasksDropdown(); return false;' }, :after => :activity
  # TODO: add the javascript code
  # move menu items to the *new* parent menu :tasks
  delete_menu_item(:project_menu, :issues)
  delete_menu_item(:project_menu, :roadmap)
  delete_menu_item(:project_menu, :gantt)
  delete_menu_item(:project_menu, :calendar)
  if Redmine::Plugin.installed? :recurring_tasks
  	delete_menu_item(:project_menu, :recurring_tasks)
  end
  if Redmine::Plugin.installed? :redmine_dashboard
	delete_menu_item(:project_menu, :dashboard)
  end
  if Redmine::Plugin.installed? :easy_wbs
	delete_menu_item(:project_menu, :easy_wbs)
  end
  menu :project_menu, :new_issue, { :controller => 'issues', :action => 'new', :copy_from => nil }, :param => :project_id, :caption => :label_issue_new, :html => { :accesskey => Redmine::AccessKeys.key_for(:new_issue) }, :if => Proc.new { |p| Setting.new_item_menu_tab == '1' && Issue.allowed_target_trackers(p).any? }, :permission => :add_issues, :parent => :tasks
  menu :project_menu, :issues, { :controller => 'issues', :action => 'index' }, :param => :project_id, :caption => :label_issue_menu, :parent => :tasks
  if Redmine::Plugin.installed? :redmine_dashboard
	menu :project_menu, :dashboard, { :controller => 'rdb_dashboard', :action => 'index' }, :caption => :menu_label_dashboard, :parent => :tasks, :after => :issues
  end
  menu :project_menu, :roadmap, { :controller => 'versions', :action => 'index' }, :param => :project_id, :if => Proc.new { |p| p.shared_versions.any? }, :parent => :tasks
  if Redmine::Plugin.installed? :easy_wbs
	menu :project_menu, :easy_wbs, { controller: 'easy_wbs', action: 'index'}, param: :project_id, caption: :'easy_wbs.button_project_menu', :parent => :tasks
  end
  menu :project_menu, :gantt, { :controller => 'gantts', :action => 'show' }, :param => :project_id, :caption => :label_gantt, :parent => :tasks
  menu :project_menu, :calendar, { :controller => 'calendars', :action => 'show' }, :param => :project_id, :caption => :label_calendar, :parent => :tasks
  if Redmine::Plugin.installed? :recurring_tasks
	#menu :project_menu, :recurring_tasks, { :controller => 'recurring_tasks', :action => 'index' }, :caption => :label_recurring_tasks, :if => Proc.new { User.current.admin? && (Setting.plugin_recurring_tasks['show_top_menu'] == "1")}
        menu :project_menu, :recurring_tasks, { :controller => 'recurring_tasks', :action => 'index' }, :caption => :label_recurring_tasks, :parent => :tasks, :param => :project_id
  end
  menu :project_menu, :report, { :controller => 'reports', :action => 'issue_report' }, :param => :id, :caption => :label_report, :parent => :tasks

  #-- project menu  / '+' : add the 'new sub project' menu item
  menu :project_menu, :new_sub_project, {:controller => 'projects', :action => 'new'}, :param => 'parent_id', :caption => :label_subproject_new, :parent => :new_object, :last => true

  # -- rename 'Files' to 'Downloads'
  delete_menu_item(:project_menu, :files)
  menu :project_menu, :files, { :controller => 'files', :action => 'index' }, :caption => :label_download_plural, :param => :project_id, :after => :boards

  # -- default settings
  default_settings = {
    'image_per_project' => '',
    'theme_per_project' => '',
    'project_tags' => '',
    'meta_description' => '',
    'meta_keywords' => '',
    'meta_robots' => '',
    'add_go_to_top' => true,
    'disabled_modules' => nil,
    'new_task_message' => '',
    'wiki_sidebar' => '',
    'login_message' => '',
    'footer_message' => ''
  }
  5.times do |i|
    default_settings['custom_menu' + i.to_s + '_name'] = ''
    default_settings['custom_menu' + i.to_s + '_url'] = ''
    default_settings['custom_menu' + i.to_s + '_title'] = ''
  end
  settings(default: default_settings, partial: 'settings/asso_kit_settings')

end
