if ActiveRecord::Base.connection.table_exists?(:settings)
  # Workaround inability to access Setting.plugin_name['setting'], both directly as well as via overridden
  # module containing the call to Setting.*, before completed plugin registration since we use a call to either:
  # * Setting.plugin_redmine_custom_help_url['custom_help_url'] or (and replaced by)
  # * RedmineCustomHelpUrl::Redmine::Info.help_url,
  # which both can *only* be accessed *after* completed plugin registration (http://www.redmine.org/issues/7104)
  #
  # We now use overridden module RedmineCustomHelpUrl::Redmine::Info instead of directly calling
  # Setting.plugin_redmine_custom_help_url['custom_help_url']
  Rails.configuration.to_prepare do
    # Patches
    require_dependency 'menu-utility'
    require_dependency 'wiki_patch'
    require_dependency 'projects-utility'

    # Hooks
    require_dependency 'hooks'

    # Wiki macros
    require_dependency 'wiki_macros/calendar'
    require_dependency 'wiki_macros/date'
    require_dependency 'wiki_macros/last_updated_at'
    require_dependency 'wiki_macros/last_updated_by'
    require_dependency 'wiki_macros/member_macro'
    require_dependency 'wiki_macros/project_macro'
    require_dependency 'wiki_macros/recently_updated'
    require_dependency 'wiki_macros/twitter'
    require_dependency 'wiki_macros/user_macro'
    require_dependency 'wiki_macros/vimeo'
    require_dependency 'wiki_macros/youtube'
  end
end
