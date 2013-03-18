class UserSurvey < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  belongs_to :project
  
  validates :user, :survey, presence: true
  
  state_machine :state, initial: :pending do
    state :pending
    state :filling
    state :submitted
    
    event :accept do
      transition pending: :filling
    end
    
    event :submit do
      transition filling: :submitted
    end
    
    around_transition :on => :accept do |us, transition, block|
      us.transaction do
        block.call
        us.survey.fields.each do |field|
          Survey::Value.create! do |v|
            v.field = field
            v.user = us.user
          end
        end
      end
    end
  end
  
  def human_name
    case true
    when personal? then
      I18n.t('user_survey.personal')
    when projects? then
      I18n.t('user_survey.projects', name: project.name.truncate(10))
    when counters? then
      I18n.t('user_survey.counters', name: project.name.truncate(10))
    end
  end
  
  def field_value(id)
    find_value(id).value
  end
  
  def fill_values(fields)
    failed = false
    transaction do
      updater = proc { |id, value| find_value(id).update_value(value) }
      failed = fields.map(&updater).any? { |r| !r }
      raise ActiveRecord::Rollback if failed
    end
    !failed
  end
  
  %w(personal projects counters).each do |type|
    define_method "#{type}?" do
      Session.where("#{type}_survey_id" => survey_id).exists?
    end
  end
  
  def find_value(field_id)
    @values_cache ||= {}
    @values_cache[field_id.to_i] || begin
      value = begin
        condition = { survey_field_id: field_id, user_id: user.id }
        Survey::Value.where(condition).first_or_create! do |s|
          
        end
      end
      @values_cache[value.survey_field_id] = value
    end
  end
end
