# coding: utf-8
class Project::Card < ActiveRecord::Base
  ALL_FIELDS = [:name, :en_name, :driver, :en_driver, :strategy,
    :en_strategy, :objective, :en_objective, :impact, :en_impact, :usage,
    :en_usage]
  
  RU_FIELDS = [:name, :driver, :strategy, :objective, :impact, :usage]
  EN_FIELDS = [:en_name, :en_driver, :en_strategy, :en_objective, :en_impact,
    :en_usage]
  
  belongs_to :project
  
  validates ALL_FIELDS + [:project], presence: true
  validates RU_FIELDS, format: { with: /[а-яё№\d[:space:][:punct:]\+]+/i, message: "Должно быть на русском" }
  validates EN_FIELDS, format: { with: /\A[a-z\d[:space:][:punct:]\+]+\z/i, message: "Должно быть на английском" }
  
  attr_accessible ALL_FIELDS
end
