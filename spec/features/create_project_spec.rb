# coding: utf-8
require 'spec_helper'

feature 'Create project', js: true do
  scenario 'with valid data' do
    user = factory!(:sured_user)
    main_organization = user.memberships.first.organization.name
    direction_of_science = factory!(:direction_of_science)
    critical_technology = factory!(:critical_technology)
    research_area = factory!(:research_area)
    
    sign_in(user)
    visit new_project_path
    
    fill_in 'Короткое название', with: 'Death Star'
    select main_organization, from: 'Главная организация'
    
    fill_in 'Полное название', with: 'ЗС-1 Орбитальная Боевая Станция'
    fill_in 'Full name', with: 'DS-1 Orbital Battle Station'
    fill_in 'Задача', with: 'Держать галактику в страхе'
    fill_in 'Driver', with: 'To keep galaxy in fear'
    fill_in 'Стратегия', with: 'Уничтожение планет'
    fill_in 'Strategy', with: 'Destroying planets'
    fill_in 'Цель', with: 'Уничтожение планет'
    fill_in 'Objective', with: 'Peace'
    fill_in 'Эффект', with: 'Смирение с Империей'
    fill_in 'Impact', with: 'Humility to the Empire'
    fill_in 'Использование', with: 'Для применения в беспокойных галактиках'
    fill_in 'Usage', with: 'For use in restive galaxies'
    
    check direction_of_science.name
    check critical_technology.name
    select research_area, from: 'Области науки'
    
    # fill_in 'ФИО руководителя организации', with: 'Palpatine'
    # fill_in 'Должность руководителя организации', with: 'Emperor'
    
    click_on 'Создать'
    
    expect(page).to have_content('Проект "Death Star" создан')
  end
end
