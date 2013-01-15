# coding: utf-8
class Report::PersonalData < ActiveRecord::Base
  with_options on: :update do |m|
    m.validates :first_name, :last_name, :middle_name, :email, :phone,
      presence: true
    m.validates :first_name, :last_name, :middle_name, format: { with: /\A[A-ZА-ЯЁ]/ }
    m.validate :full_name_validator
    m.validates :phone, format: { with: /\A[\+\-\d\(\)\s]+\z/ }
    m.validates_email_format_of :email
  end
  attr_accessible :first_name, :last_name, :middle_name, :email, :phone

private

  def full_name_validator
    %w(first_name last_name middle_name).each do |attr|
      value = send(attr)
      next if value.blank?

      if value =~ /[a-z]/i
        errors.add(attr, :invalid_format) unless value =~ /\A[a-z]+\z/i
      else
        errors.add(attr, :invalid_format) unless value =~ /\A[а-яё]+\z/i
      end
    end
  end
end
