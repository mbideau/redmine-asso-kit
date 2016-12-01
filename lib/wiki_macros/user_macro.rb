# Redmine Tweaks plugin for Redmine
# Copyright (C) 2013-2016 AlphaNodes GmbH

# User wiki macros
module ZZEcloserieCustomizations
  module WikiMacros
    Redmine::WikiFormatting::Macros.register do
      desc "Display link to user profile\n\n" \
           "Syntax:\n\n" \
           "{{user(USER_NAME [, format=USER_FORMAT, avatar=BOOL])}}\n\n" \
           "USER_NAME can be user id or user name (login name)\n" \
           "USER_FORMATS\n" \
           "- system (use system settings) (default)\n- " +
           User::USER_FORMATS.keys.join("\n- ") + "\n\n" \
           "Examples:\n\n" \
           "{{user(1)}}\n" \
           "...Link to user with user id 1\n\n" \
           "{{user(1, avatar=true)}}\n" \
           "...Link to user with user id 1 with avatar\n\n" \
           "{{user(admin)}}\n" \
           "...Link to user with username 'admin'\n\n" \
           "{{user(admin, format=firstname)}}\n" \
           "...Link to user with username 'admin' and show firstname as link text"

      macro :user do |_obj, args|
        args, options = extract_macro_options(args, :format, :avatar)
        raise 'The correct usage is {{user(<user_id or username>, format=USER_FORMAT)}}' if args.empty?
        user_id = args[0]

        user = User.find_by_id(user_id)
        user ||= User.find_by_login(user_id)
        return '' if user.nil?

        name = if options[:format].blank?
                 user.name
               else
                 user.name(options[:format].to_sym)
               end

        s = ''
        if !options[:avatar].blank? && options[:avatar]
          s = avatar(user, size: 14)
        end

        s.html_safe << if user.active?
                         link_to(h(name),
                                 user_path(user),
                                 class: user.css_classes)
                       else
                         h(name)
                       end
      end
    end
  end
end
