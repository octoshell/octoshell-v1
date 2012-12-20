# coding: utf-8
class Report::PersonalSurvey < ActiveRecord::Base
  SOFTWARE = (1..50).map { |n| "name#{n}" }
  TECHNOLOGIES = [
    'C/C++',
    'Fortran',
    'MPI',
    'OpenMP',
    'OpenCL',
    'CUDA',
    'OpenACC',
    'Прикладные пакеты'
  ]
  COMPILATORS = [
    'Intel',
    'GNU',
    'PGI',
    'CUDA compiler'
  ]
  LEARNINGS = [
     'Технология MPI',
     'Технология OpenMP',
     'Технологии программирования графических процессоров',
     'Введение в параллельные методы решения задач',
     'Оптимизация и повышение эффективности параллельных приложений',
     'Отладка параллельных приложений',
     'Работа с конкретным пакетом или инструментарием',
     'Название'
  ]
  attr_accessible :software, :technologies, :compilators, :learning,
    :wanna_be_speaker
end
