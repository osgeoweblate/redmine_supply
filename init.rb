require 'redmine'

Rails.configuration.to_prepare do
  RedmineSupply.setup
  RedmineResourceManager.setup
end

Redmine::Plugin.register :redmine_supply do
  name 'Redmine Supply and Resources Plugin'
  author 'Jens Krämer, Georepublic'
  author_url 'https://hub.georepublic.net/gtt/redmine_supply'
  description 'Adds configurable supply and resource items to issues'
  version '2.0.0'

  requires_redmine version_or_higher: '3.4.0'

  project_module :supply do

    permission :manage_supply_items, {
      supply_items: %i( index new edit update create destroy edit_stock update_stock),
    }, require: :member

    permission :view_supply_items, {
      supply_items: %i( index show ),
    }, require: :member, read: true

    permission :view_issue_supply_items, {}, require: :member, read: true
    permission :manage_issue_supply_items, {
      issue_supply_items: %i( new create destroy append ),
      supply_items: %i( autocomplete )
    }, require: :member

    permission :manage_resource_categories, {
      resource_categories: %i( new edit update create destroy ),
      projects: %i( manage_resource_categories )
    }, require: :member

    permission :view_resource_items, {
      resource_items: %i( index ),
    }, require: :member, read: true

    permission :manage_resource_items, {
      resource_items: %i( index new edit update create destroy ),
    }, require: :member


    permission :view_issue_resources, {}, require: :member, read: true

    permission :manage_issue_resources, {
      issue_resource_items: %i( new create destroy append ),
      resource_items: %i( autocomplete )
    }, require: :member
  end

  activity_provider :supply_item_journals, class_name: 'SupplyItemJournal'

  menu :project_menu,
    :resource_items,
    { controller: 'resource_items', action: 'index' },
    caption: :label_resource_item_plural,
    after: :issues,
    param: :project_id,
    permission: :view_resource_items

  menu :project_menu,
    :new_resource_item,
    { controller: 'resource_items', action: 'new' },
    caption: :label_resource_item_new,
    after: :new_version,
    param: :project_id,
    parent: :new_object,
    permission: :manage_resource_items

  menu :project_menu,
    :supply_items,
    { controller: 'supply_items', action: 'index' },
    caption: :label_supply_item_plural,
    after: :issues,
    param: :project_id,
    permission: :view_supply_items

  menu :project_menu,
    :new_supply_item,
    { controller: 'supply_items', action: 'new' },
    caption: :label_supply_item_new,
    after: :new_version,
    param: :project_id,
    parent: :new_object,
    permission: :manage_supply_items
end

