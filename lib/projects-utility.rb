# Renders the projects action links
def render_projects_contextual_links
    links = []
    if User.current.allowed_to?(:add_project, nil, :global => true)
      links << link_to(l(:label_project_new), new_project_path, :class => 'icon icon-add')
    end
    if User.current.allowed_to?(:view_issues, nil, :global => true)
      links << link_to(l(:label_issue_view_all), issues_path)
    end
    links.join(" | ").html_safe
end

# Renders the projects index
def render_project_list_flat(projects)
  html = []
  if projects.any?
		image_per_project_field_id = Setting.plugin_zz_asso_kit['image_per_project'].to_i
		project_tags_field_id = Setting.plugin_zz_asso_kit['project_tags'].to_i
  	html << '<div class="project-list flat">'
		projects.sort_by(&:lft).each do |project|
			project_html = []

			# header
			project_header = []
			# image
			project_image_field = project.custom_values.detect {|v| v.custom_field_id == image_per_project_field_id}
			if project_image_field && !project_image_field.value.blank?
				project_html << '<div class="project-item with-image">'
				project_header << '<img src="' + project_image_field.value.html_safe + '" />'
			else
				project_html << '<div class="project-item">'
			end
			# description
			if project.description.present? && !project.description.blank?
				project_header << '<div class="description">' + project.short_description.html_safe + '</div>'
			end
			project_header_string = project_header.empty? ? '' : project_header.join("\n").html_safe
			if project.archived?
				project_html << '<div class="header">' + project_header_string + '</div>'
			else
				project_html << link_to(project_header_string, project_url(project, {:only_path => true}), :class => 'header')
			end

			# title
			project_html << link_to_project(project, {}, :class => "title #{project.css_classes} #{User.current.member_of?(project) ? 'my-project' : nil}")

			# informations
			project_html << '<div class="informations">'
			project_tags_field = project.custom_values.detect {|v| v.custom_field_id == project_tags_field_id}
			if project_tags_field && !project_tags_field.value.blank?
				tags_splitted = project_tags_field.value.split(',');
				project_html << '<div class="tags">'
				tags_splitted.each do |t|
					project_html << '<span class="' + t.strip + '">' + t.strip.html_safe + '</span>'
				end
				project_html << '</div>'
			else
				project_html << '<div class="created"><span class="qualifier">' + l(:label_created_on) + '</span>' + format_date(project.created_on) + '</div>'
			end
			# users
			project_html << '<div class="users" title="' + l(:label_number_of) + ' ' + l(:label_member_plural).downcase + '"><span class="qualifier">' + (project.users.size > 1 ? l(:label_member_plural) : l(:label_member)) + '</span>' + project.users.size.to_s + '</div>'
			# activity
			@activity_fetcher = Redmine::Activity::Fetcher.new(User.current, :project => project, :with_subprojects => true)
			last_activity_entry = @activity_fetcher.events(nil, nil, :limit => 1).last
			project_html << '<div class="last-activity-entry" title="' + l(:label_last_activity) + '"><span class="qualifier">' + l(:label_last_activity) + '</span>' + (!last_activity_entry.nil? ? format_date(last_activity_entry.event_datetime) : '') + '</div>'

			# end of header
			project_html << '</div>'
			
			# end of project item
			project_html << '</div>'

			html << project_html.join("\n").html_safe
		end
  	html << '</div>'
  end
  html.empty? ? '' : html.join("\n").html_safe
end

