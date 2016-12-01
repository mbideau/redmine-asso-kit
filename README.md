# redmine-asso-kit
A Redmine plugin for a better UI

Many functions where taken as-is or inspired by the [redmine_tweaks](https://github.com/alphanodes/redmine_tweaks) plugin.

## Features added/modified :
- UI Menu    top menu > account menu rendered as a Dropdown, with the username and avatar as button
- UI Menu    top menu > user menu added to contains the 'My Page' item and the 'My Issues' badges (from Unread Issues plugin)
- UI Menu    project menu > tasks added to contains the following menu items : 'Issues', 'Dashboard' (dashboard plugin), 'Roadmap', 'MindMap' (easy_wbs plugin), 'Gantt', 'Calendar', 'Recurring Tasks' (recurring_tasks plugin)
- UI Menu    project menu > '+' is added a 'new sub project' menu item
- UI Footer  'Go to top' button added
- UI Help    Add a message on 'new task' form
- UI Help    Add a message on wiki sidebar (global for all projects)
- UI Help    Add a login message
- Project    wiki is the project home default page (the project overview is removed)
- Projects	 projects are displayed like cards with usefull info and picture preview
- Admin      Modules disable option
- SEO        HTTP Meta tags 'keywords' customizable (default to: "asso kit,gestion de projet,tâches,wiki,forum")
- SEO        HTTP Meta tags 'robots' added and customizable (default to: "noindex,nofollow,noarchive")

## Installation
Get the sources and put them into a directory named _zz_asso_kit_ in the Redmine plugins directory :

	git clone https://github.com/mbideau/redmine-asso-kit.git plugins/zz_asso_kit

_The renaming allow the plugin to be the last one loaded, and therefor know of every other plugins_.

## Configure the plugin

### Add 4 custom fields

* Image link
  type: link
  regexp: \A/.*\.(png|PNG|jpg|JPG|jpeg|JPEG)\z

* CSS Link
  type: link
  regexp: \A/.*\.(css|CSS)\z

* Keywords list
  type: text
  regexp: ^[a-zA-Z0-9 '-]*(,[a-zA-Z0-9 '-]*)*$

* Custom menus
  type: long text
  regexp: \A([\n\r ]*\[ *[^]\|]+ *(\| *(first|last|after *: *[a-zA-Z0-9_-]+|before *: *[a-zA-Z0-9_-]+|parent *: *[a-zA-Z0-9_-]+))? *\] *\( *[^\)]+ *\)[\n\r ]*)*\z

