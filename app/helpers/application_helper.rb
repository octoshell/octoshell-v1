# coding: utf-8
module ApplicationHelper
  def title title
    content_for :title, title
  end
  
  def render_git_version
    "<!-- version: #{MSU::VERSION} -->".html_safe
  end
  
  def active_menu?(_namespace, submenu = false)
    n = submenu ? subnamespace :  namespace
    _namespace == n ? 'active' : ''
  end
  
  def submenu_item(controller_name, link)
    klass = current_controller?(controller_name) ? 'active' : ''
    content_tag :li, link, class: klass
  end
  
  def current_controller?(controller_name)
    controller_name == params[:controller].to_sym
  end
  
  def link_to_project(project)
    link_to project.name, project
  end
  
  def link_to_surety(surety)
    link_to 'открыть', surety
  end
  
  def link_to_membership(membership)
    link_to 'открыть', membership
  end
  
  def link_to_credential(credential)
    link_to credential.name, credential
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
        label: Organization.model_name.human,
        name: :organization_id_eq,
        admin: true,
        source: organizations_path
      },
      user: {
        label: User.model_name.human,
        name: :user_id_eq,
        admin: true,
        source: users_path
      },
      project: {
        label: Project.model_name.human, 
        name: :project_id_eq,
        admin: true,
        source: projects_path
      }
    }
    
    options = default_options[type].merge(options)
    return if options[:admin] && maynot?(:access, :admin)
    
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
