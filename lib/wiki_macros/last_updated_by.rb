# Redmine Tweaks plugin for Redmine
# Copyright (C) 2013-2016 AlphaNodes GmbH

# Last_updated_by wiki macros
module ZZEcloserieCustomizations
  module WikiMacros
    Redmine::WikiFormatting::Macros.register do
      desc <<-EOHELP
      Displays a user who updated the page.
        {{last_updated_by}}
      EOHELP

      macro :last_updated_by do |obj, args|
        raise 'The correct usage is {{last_updated_by}}' unless args.empty?
        content_tag(:span,
                    "#{avatar(obj.author, size: 14)} #{link_to_user(obj.author)}".html_safe,
                    class: 'last-updated-by')
      end
    end
  end
end
