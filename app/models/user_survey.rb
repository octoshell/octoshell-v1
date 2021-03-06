# Опрос, который заполняет пользователь
class UserSurvey < ActiveRecord::Base
  delegate :session, to: :survey

  has_paper_trail

  belongs_to :user
  belongs_to :survey
  belongs_to :project
  has_many :survey_values, class_name: "Survey::Value", dependent: :destroy

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

    inside_transition :on => :accept do |us|
      us.survey.fields.each do |field|
        us.survey_values.create! do |v|
          v.field = field
        end
      end
    end
  end

  def human_name
    case true
    when personal? then
      I18n.t('user_survey.personal')
    when projects? then
      I18n.t('user_survey.projects', name: project.title)
    when counters? then
      I18n.t('user_survey.counters', name: project.title)
    end
  end

  def fill_values(fields)
    transaction do
      saves = fields.map do |field_id, value|
        record = survey_values.find { |v| v.survey_field_id == field_id.to_i }
        record.value = value
        record.save
      end
      saves.all? || (raise ActiveRecord::Rollback)
    end
  end

  def fill_values_and_submit(fields)
    transaction do
      (fill_values(fields) && submit) || raise(ActiveRecord::Rollback)
    end
  end

  def save_as_file(format)
    path = "/tmp/us-#{SecureRandom.hex(4)}.#{format}"
    File.open(path, "wb") do |f|
      f.write send("to_#{format}")
    end
    path
  end

  def as_json(options = nil)
    {
      user_name: user.full_name,
      user_id: user.id,
      values: survey_values.map do |value|
        {
          field: {
            name: value.field.name,
            kind: value.field.kind,
            collection: value.field.collection_values
          },
          value: value.value
        }
      end
    }
  end

  def to_html
    controller = Class.new(AbstractController::Base) do
      include AbstractController::Rendering

      self.view_paths = "app/views"

      def initialize(us)
        @us = us
      end

      def show
        render "admin/user_surveys/show", layout: "layouts/mini"
      end
    end
    controller.new(self).show
  end

  %w(personal projects counters).each do |type|
    define_method "#{type}?" do
      Session.where("#{type}_survey_id" => survey_id).exists?
    end
  end
end
