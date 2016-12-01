# Redmine Tweaks plugin for Redmine
# Copyright (C) 2013-2016 AlphaNodes GmbH

# Last_updated_at wiki macros
module ZZEcloserieCustomizations
  module WikiMacros
    Redmine::WikiFormatting::Macros.register do
      desc <<-EOHELP
      Displays a date that updated the page.
        {{last_updated_at}}
        {{last_updated_at(project_name, wiki_page)}}
        {{last_updated_at(project_identifier, wiki_page)}}
      EOHELP

      macro :last_updated_at do |obj, args|
        return '' unless @project
        if args.empty?
          page = obj
        else
          raise '{{last_updated_at(project_identifier, wiki_page)}}' if args.length < 2
          project_name = args[0].strip
          page_name = args[1].strip
          project = Project.find_by_name(project_name)
          project = Project.find_by_identifier(project_name) unless project
          return '' unless project
          wiki = Wiki.find_by_project_id(project.id)
          return '' unless wiki
          page = wiki.find_page(page_name)
        end

        return '' unless page

        content_tag(:span,
                    l(:label_updated_time, time_tag(page.updated_on)).html_safe,
                    class: 'last-updated-at')
      end
    end
  end
end
