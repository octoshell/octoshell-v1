module AdminHelper
  def link_to_attribute(record, attribute, value)
    if attribute.to_s =~ /_id$/
      link_to_relation(record, attribute, value)
    else
      value
    end
  end
  
  def link_to_relation(record, attribute, value)
    record.send("#{attribute}=", value)
    relation = attribute.to_s[/(.*)_id$/, 1]
    if respond_to?(attribute) && record.respond_to?(relation)
      link = smart_link_to record.send(relation)
      record.send("#{attribute}=", record.send("#{attribute}_was"))
      link
    end
  end

  def smart_link_to(record, name = nil, options = {})
    return unless record
    name ||= record.link_name if record
    options[:class] ||= ""
    options[:class] << " shorted"
    link_to_if may?(:manage, record.models_name), name, [:admin, record], options
  end

  def link_to_project(project, options = {})
    return unless project
    link_to_if (may?(:manage, :projects) || may?(:review, :projects)), project.link_name, [:admin, project], options
  end
end
