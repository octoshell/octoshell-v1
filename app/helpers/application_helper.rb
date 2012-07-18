# coding: utf-8
module ApplicationHelper
  def title title
    content_for :title, title
  end
  
  def render_git_version
    "<!-- version: #{MSU::VERSION} -->".html_safe
  end
  
  def active_menu?(_namespace)
    namespace == _namespace ? 'active' : ''
  end
  
  def submenu_item(controller_name, content)
    klass = params[:controller].to_sym == controller_name ? 'active' : ''
    content_tag :li, content, class: klass
  end
  
  def link_to_cluster(cluster)
    if cluster
      link_to cluster.name, cluster
    else
      'Удален'
    end
  end
  
  def link_to_user(user)
    if user
      link_to user.full_name, user
    else
      'Удален'
    end
  end
  
  def link_to_project(project)
    if project
      link_to project.name, project
    else
      'Удален'
    end
  end
  
  def link_to_surety(surety)
    if surety
      link_to I18n.t('pages.profile.surety'), surety
    else
      'Удалено'
    end
  end
  
  def link_to_organization(organization)
    if organization
      link_to organization.name, organization
    else
      'Удалена'
    end
  end
  
  def link_to_membership(membership)
    if membership
      link_to 'Позиции', membership
    else
      'Удалено'
    end
  end
end
