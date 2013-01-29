# coding: utf-8
class Report::PersonalSurvey < ActiveRecord::Base
  SOFTWARE = [
    'Abinit',
    'Amber',
    'CRYSTAL-09',
    'Firefly (PC-GAMESS)',
    'FlowVision',
    'Lammps',
    'Magma',
    'Materials Studio',
    'Molpro',
    'Namd',
    'NWChem 6.1',
    'OpenFOAM',
    'Quantum Espresso',
    'Turbomole',
    'VASP',
    'WIEN2k',
    'Компиляторы Intel',
    'PGI compiler',
    'PathScale Compiler Suite',
    'Intel VTune Amplifier XE 2011',
    'TotalView',
    'Allinea DDT',
    'Intel Math Kernel Library',
    'ACML',
    'CUDA',
    'ScaLAPACK',
    'ATLAS',
    'AMCL',
    'BLAS',
    'LAPACK',
    'FFTW'
  ]
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
     'Отладка параллельных приложений'
  ]
  PRECISIONS = [
    'Принципиально важна двойная точность',
    'Достаточно одинарной точности',
    'Операции с плавающей точкой не являются принципиальными для моих приложений'
  ]
  COMPUTING = [
    'Используются графические процессоры (графическая часть суперкомпьютера "Ломоносов")',
    'Планируется использование графических процессоров в будущем',
    'Используются только классические многоядерные процессоры (разделы с процессорами Intel на суперкомпьютере "Ломоносов"и/или "Чебышев")',
    'Используются (или планируется использование) суперкомпьютеров на основе FPGA'
  ]
  attr_accessible :software, :technologies, :compilators, :learning,
    :other_technology, :other_compilator, :other_learning, :request_technology,
    :computing, :comment, :precision


  serialize :software, Array
  serialize :technologies, Array
  serialize :compilators, Array
  serialize :computing, Array
  serialize :learning, Array

  %w(software technologies compilators learning computing).each do |attr|
    define_method attr do
      Array(self[attr]).find_all(&:present?)
    end
  end
end
