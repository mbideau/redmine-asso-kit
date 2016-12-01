require_dependency 'wiki'

module ZZEcloserieCustomizations
	# Patch wiki to include sidebar
	module WikiPatch
		def self.included(base) # :nodoc:
		base.send(:include, InstanceMethodsForEcloserieCustomizationsWikiSideBar)
		base.class_eval do
			alias_method_chain :sidebar, :zz_asso_kit
		end
		end
	end

	# Instance methodes for Wiki
	module InstanceMethodsForEcloserieCustomizationsWikiSideBar
		def sidebar_with_zz_asso_kit
		@sidebar ||= find_page('Sidebar', with_redirect: false)
		if @sidebar && @sidebar.content
			sidebar_without_zz_asso_kit
		else
			wiki_sidebar = '' + Setting.plugin_zz_asso_kit['wiki_sidebar']
			@sidebar ||= find_page('Wiki', with_redirect: false)
			if wiki_sidebar != '' && @sidebar.try(:content)
			@sidebar.content.text = wiki_sidebar
			end
		end
		end
	end
end

unless Wiki.included_modules.include? ZZEcloserieCustomizations::WikiPatch
  Wiki.send(:include, ZZEcloserieCustomizations::WikiPatch)
end
