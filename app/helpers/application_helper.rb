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
  
  def submenu_item(controller_name, link)
    klass = current_controller?(controller_name) ? 'active' : ''
    content_tag :li, link, class: klass
  end
  
  def current_controller?(controller_name)
    controller_name == params[:controller].to_sym
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
      link_to 'открыть', surety
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
  
  def link_to_organization_kind(organization_kind)
    link_to organization_kind.name, organization_kind
  end
  
  def link_to_membership(membership)
    if membership
      link_to 'открыть', membership
    else
      'Удалено'
    end
  end
  
  def link_to_credential(credential)
    if credential
      link_to credential.name, credential
    else
      'Удалено'
    end
  end
  
  def link_to_ticket_question(ticket_question)
    link_to ticket_question.question, ticket_question
  end
  
  def link_to_ticket_field(ticket_field)
    link_to ticket_field.name, ticket_field
  end
  
  def link_to_task(task)
    if task
      link_to 'открыть', task
    else
      'Удалено'
    end
  end
  
  def link_to_cluster_user(cluster_user)
    if cluster_user
      link_to ClusterUser.model_name.human, cluster_user
    else
      'Удалено'
    end
  end
  
  def link_to_task_resource(task)
    if task.resource
      link_to task.resource.class.model_name.human, task.resource
    else
      'Удалено'
    end
  end
  
  def link_to_ticket(ticket)
    link_to ticket.subject, ticket
  end
  
  def link_to_function(name, *args, &block)
     html_options = args.extract_options!.symbolize_keys

     function = block_given? ? update_page(&block) : args[0] || ''
     onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
     href = html_options[:href] || '#'

     content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
  end
  
  def link_to_attachment(record)
    if record.attachment?
      "#{link_to record.attachment_file_name, record.attachment.url, target: '_blank'} #{record.attachment.size} byte".html_safe
    end
  end
end
