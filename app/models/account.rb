require 'timeout'

# Модель доступа пользователя к проекту. Имеет 2 независимых состояния: Доступ к проекту (access_state: “allowed” или “denied”) и Доступ к кластеру (cluster_state: “active” или “closed”)
class Account < ActiveRecord::Base
  has_paper_trail

  default_scope order("#{table_name}.id desc")

  delegate :state_name, to: :user, prefix: true, allow_nil: true
  delegate :state_name, to: :project, prefix: true, allow_nil: true

  belongs_to :user, inverse_of: :accounts
  belongs_to :project, inverse_of: :accounts

  validates :user, :project, presence: true
  validates :username, presence: true, on: :update

  attr_accessible :user_id

  scope :by_params, proc { |p| where(project_id: p[:project_id], user_id: p[:user_id]) }

  after_create :assign_username

  # доступ к кластеру. выполнил ли пользователь необходимые условия для доступа
  state_machine :cluster_state, initial: :closed do
    state :active do
      validates :user_state_name, inclusion: { in: [:sured] }
      validate :user_faults_validator
    end
    state :closed

    event :activate do
      transition :closed => :active
    end

    event :close do
      transition :active => :closed
    end
  end

  # доступ к проекту. разрешил ли руководитель доступ
  state_machine :access_state, initial: :denied do
    state :denied
    state :allowed

    event :allow do
      transition :denied => :allowed
    end

    event :deny do
      transition :allowed => :denied
    end

    inside_transition :on => :allow, &:activate
    inside_transition :on => :deny, &:close

    around_transition on: :deny do |account, _, block|
      account.transaction do
        account.close unless account.closed?
        block.call
      end
    end
  end

  def username=(username)
    self[:username] = username
  end

  def to_s
    username
  end

  def login
    "#{project.project_prefix}#{username}"
  end

  def link_name
    to_s
  end

  def change_login(new_login)
    if login_available?(new_login)
      transaction do
        update_attribute(:username, new_login)
        project.requests.with_states(:active, :blocked).each(&:request_maintain!)
      end
    else
      false
    end
  end

  def on_clusters(login = username)
    @on_clusters ||=
      Cluster.with_state(:active).find_all do |cluster|
        res, cmd = "", "sudo /usr/octo/check_user #{login}"
        Timeout::timeout(3) do
          ::Net::SSH.start(cluster.host, "octo", keys: [Settings.octokey]) do |ssh|
            ssh.open_channel do |channel|
              channel.request_pty do |ch, success|
                ch.exec cmd
              end
              channel.on_data do |ch, data|
                res = data.chomp
              end
            end
          end
        end

        res != "closed"
      end
  end

  def login_available?(login = username)
    unless (login =~ /([a-z_][a-z0-9_]{0,30})/) == 0
      errors.add :username, "Не правильный формат"
      return false
    end

    Account.where("id != ?", id).where(username: login).empty?
  end

  def assign_username
    username = user.username.to_s.downcase.first(12)
    update_attribute :username, "#{username}_#{id}"
  end

  def user_faults_validator
    if user.faults.with_state(:actual).where(kind_of_block: :account).any?
      errors.add(:base, "Пользователь заблокирован")
    end
  end

  def block(desc)
    Fault.create! do |f|
      f.user = user
      f.kind = :account
      f.kind_of_block = :account
      f.reference_id = id
      f.description = desc
    end
  end
end
