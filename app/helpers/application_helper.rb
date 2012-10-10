# coding: utf-8
module ApplicationHelper
  def link_to_attribute(record, attribute, value)
    if attribute.to_s =~ /_id$/
      record.send("#{attribute}=", value)
      relation = attribute.to_s[/(.*)_id$/, 1]
      link_method = "link_to_#{relation}"
      if respond_to?(link_method) && record.respond_to?(relation)
        link = send link_method, record.send(relation)
      end
      record.send("#{attribute}=", record.send("#{attribute}_was"))
      link
    else
      value
    end
  end
  
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
    return unless cluster
    link_to_if can?(:show, cluster), cluster.name, cluster
  end
  
  def link_to_user(user)
    return unless user
    link_to_if (can? :show, user), user.full_name, user
  end
  
  def link_to_project(project)
    return unless project
    link_to_if can?(:show, project), project.name, project
  end
  
  def link_to_surety(surety)
    return unless surety
    link_to_if can?(:show, surety), 'открыть', surety
  end
  
  def link_to_organization(organization)
    return unless organization
    link_to_if can?(:show, organization), organization.name, organization
  end
  
  def link_to_organization_kind(organization_kind)
    return unless organization_kind
    link_to_if can?(:show, organization_kind), organization_kind.name, organization_kind
  end
  
  def link_to_membership(membership)
    return unless membership
    link_to_if can?(:show, membership), 'открыть', membership
  end
  
  def link_to_credential(credential)
    return unless credential
    link_to_if can?(:show, credential), credential.name, credential
  end
  
  def link_to_ticket_template(ticket_template)
    return unless ticket_template
    link_to_if can?(:show, ticket_template), ticket_template.subject, ticket_template
  end
  
  def link_to_ticket_question(ticket_question)
    return unless ticket_question
    link_to_if can?(:show, ticket_question), ticket_question.question, ticket_question
  end
  
  def link_to_ticket_field(ticket_field)
    return unless ticket_field
    link_to_if can?(:show, ticket_field), ticket_field.name, ticket_field
  end
  
  def link_to_task(task)
    return unless task
    link_to_if can?(:show, task), "Задание ##{task.id}", task
  end
  
  def link_to_cluster_user(cluster_user)
    return unless cluster_user
    link_to_if can?(:show, cluster_user), cluster_user.username, cluster_user
  end
  
  def link_to_task_resource(task)
    return unless task
    link_to_if can?(:show, task), task.resource.class.model_name.human, task.resource
  end
  
  def link_to_ticket(ticket)
    return unless ticket
    link_to_if can?(:show, ticket), ticket.subject, ticket
  end
  
  def link_to_ticket_tag(ticket_tag)
    return unless ticket_tag
    link_to_if can?(:show, ticket_tag), ticket_tag.name, ticket_tag
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
      output = "#{link_to record.attachment_file_name, record.attachment.url, target: '_blank'} #{record.attachment.size} byte".html_safe
      
      if record.attachment_image?
        output << "<br />".html_safe
        output << link_to(image_tag(record.attachment.url, class: 'preview'), record.attachment.url, target: '_blank')
      end
      
      output
    end
  end
  
  def disabled(condition)
    'disabled' unless condition
  end
  
  def load_bar(extend, type)
    return unless extend.send("#{type}?")
    content_tag :div, id: extend.send(type) do
      content_tag :div, class: 'progress progress-striped active' do
        content_tag :div, nil, class: 'bar', style: 'width: 100%'
      end
    end
  end
  
  def safe_paginate(records)
    paginate records if records.respond_to? :current_page
  end
  
  def autocomplete(type, form, options = {})
    default_options = {
      organization: {
        label: "Организация",
        name: :organization_id_eq,
        admin: true,
        source: organizations_path
      },
      user: {
        label: "Пользователь",
        name: :user_id_eq,
        admin: true,
        source: users_path
      },
      project: {
        label: "Проект", 
        name: :project_id_eq,
        admin: true,
        source: projects_path
      }
    }
    
    options = default_options[type].merge(options)
    return if options[:admin] && !admin?
    
    content_tag(:div, class: "control-group select") do
      content_tag(:div, class: "select control-label") do
        content_tag :label, options[:label]
      end + 
        content_tag(:div, class: "controls") do
          form.hidden_field options[:name], class: 'chosen ajax', data: { source: options[:source] }
        end
    end
  end
end
