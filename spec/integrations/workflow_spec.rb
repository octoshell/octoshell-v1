# coding: utf-8
require 'spec_helper'

describe 'Workflow', js: true do
  let!(:admin)    { create(:admin_user) }
  let!(:manager)  { create(:user) }
  let!(:coworker) { create(:user) }
  
  it do
    # scene #1. Admin setup entities
    
    login admin
    
    click_link 'Еще'
    click_link 'Типы организаций'
    click_link 'Новый тип организации'
    fill_in 'Name', with: 'ВУЗ'
    click_button 'Create Organization kind'
    
    click_link 'Еще'
    click_link 'Позиции в организациях'
    click_link 'Новая позиция'
    fill_in 'Name', with: 'Должность'
    click_button 'Create Position name'
    
    click_link 'Кластеры'
    click_link 'Новый кластер'
    fill_in 'Name', with: 'Ломоносов'
    fill_in 'Host', with: 'lomonosov.parallel.ru'
    click_button 'Create Cluster'
    
    click_link 'Поддержка'
    click_link 'Вопросы в заявках'
    click_link 'Новый вопрос'
    fill_in 'Question', with: 'Другое'
    click_button 'Create Ticket question'
    logout
    
    # scene #2. Manager create surety
    
    login manager
    
    click_link 'Личный кабинет'
    click_link 'Мои поручительства'
    click_link 'Новое поручительство'
    click_link 'Добавить организацию'
    fill_in 'Name', with: 'Evrone'
    select 'ВУЗ', from: 'Organization kind'
    click_button 'Create Organization'
    
    click_link 'Личный кабинет'
    click_link 'Мои поручительства'
    click_link 'Новое поручительство'
    select 'Evrone', from: 'Organization'
    click_button 'Create Surety'
    
    click_link 'Мои места работы'
    click_link 'Новое место работы'
    select 'Evrone', from: 'Organization'
    fill_in 'Должность', with: 'Разработчик'
    click_button 'Create Membership'
    
    click_link 'Мои публичные ключи'
    click_link 'Новый публичный ключ'
    fill_in 'Name', with: 'PC'
    fill_in 'Public key', with: '=== atata'
    click_button 'Create Credential'
    
    click_link 'Поддержка'
    click_link 'Заявки (0)'
    click_link 'Новая заявка'
    select 'Другое', from: 'Ticket question'
    click_button 'Продолжить'
    fill_in 'Subject', with: 'Скан поручительства'
    fill_in 'Message', with: 'Прикладываю файл'
    click_button 'Create Ticket'
    
    logout
    
    # scene #3. Approving surety
    login admin
    
    click_link 'Поддержка'
    click_link 'Заявки (1)'
    click_link 'Скан поручительства'
    fill_in 'Message', with: 'ОК'
    click_button 'Create Reply'
    
    fill_in 'ticket_tag_name', with: 'Поручительства'
    click_button 'Создать'
    
    click_link 'Кабинет Администратора'
    click_link 'Поручительства (1)'
    click_link 'открыть'
    click_link 'activate'
    
    logout
    
    # scene #4. Creating project
    login manager
    
    click_link 'Мои проекты'
    click_link 'Новый проект'
    select 'Evrone', from: 'Organization'
    fill_in 'Name', with: 'octoshell'
    fill_in 'Description', with: 'octopus + shell'
    select 'Ломоносов', from: 'Cluster'
    fill_in 'Hours', with: 10
    fill_in 'Size', with: 10
    click_button 'Create Project'
    
    logout
    
    # scene #5. Approving request
    login admin
    
    click_link 'Заявки (1)'
    click_link 'открыть'
    click_link 'activate'
    
    logout
    
    # scene #5. Invite coworker
    login coworker
    
    click_link 'Личный кабинет'
    click_link 'Мои поручительства'
    click_link 'Новое поручительство'
    select 'Evrone', from: 'Organization'
    click_button 'Create Surety'
    
    click_link 'Мои места работы'
    click_link 'Новое место работы'
    select 'Evrone', from: 'Organization'
    fill_in 'Должность', with: 'Разработчик'
    click_button 'Create Membership'
    
    click_link 'Мои публичные ключи'
    click_link 'Новый публичный ключ'
    fill_in 'Name', with: 'PC'
    fill_in 'Public key', with: '=== atata'
    click_button 'Create Credential'
    
    click_link 'Поддержка'
    click_link 'Заявки (0)'
    click_link 'Новая заявка'
    select 'Другое', from: 'Ticket question'
    click_button 'Продолжить'
    fill_in 'Subject', with: 'Скан поручительства'
    fill_in 'Message', with: 'Прикладываю файл'
    click_button 'Create Ticket'
    
    logout
    
    login admin
    
    click_link 'Кабинет Администратора'
    click_link 'Поручительства (1)'
    click_link 'открыть'
    click_link 'activate'
    
    logout
    
    login coworker
    
    click_link 'Доступы к проектам (0/0)'
    click_link 'Новый доступ'
    
    within '#request_account' do
      select 'octoshell', from: 'Project'
      click_button 'Запросить'
    end
    
    logout
    
    login manager
    
    click_link 'Доступы к проектам (1/2)'
    within '#account-2' do
      click_link 'открыть'
    end
    click_link 'activate'
    
    logout
    
    login coworker
    
    sleep 3
  end
end
