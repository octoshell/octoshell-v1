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
  PRECISIONS = [
    'Принципиально важна двойная точность',
    'Достаточно одинарной точности',
    'Операции с плавающей точкой не являются принципиальными для моих приложений'
  ]
  COMPUTING = [
    'Используются графические процессоры (графическая часть суперкомпьютера "Ломоносов")',
    'Планируется использование графических процессоров в будущем',
    'Используются только классические многоядерные процессоры (разделы с процессорами Intel на суперкомпьютере "Ломоносов"и/или "Чебышев',
    'Используются (или планируется использование) суперкомпьютеров на основе FPGA'
  ]
  attr_accessible :software, :technologies, :compilators, :learning,
    :other_technology, :other_compilator, :other_learning, :request_technology,
    :computing, :comment


  serialize :software, Array
  serialize :technologies, Array
  serialize :compilators, Array
  serialize :computing, Array
end
