require 'pp'
require 'debugger'

class Employee
  attr_accessor :name, :title, :salary, :boss
  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    salary * multiplier
  end

end

class Manager < Employee
  attr_accessor :employees, :subsalaries
  def initialize(n,t,s,b)
    super(n,t,s,b)
    @subsalaries = 0
    @employees = []
  end

  def assign_underling(name)
    @employees << name
  end

  def bonus(multiplier)
    subsalaries * multiplier
  end

  def subsalaries
    # debugger
    subsalaries = 0
    employees.each do |emp|
      if emp.class == Manager
        emp.subsalaries
        subsalaries += emp.subsalaries
      else
        subsalaries += emp.salary
      end
    end

    subsalaries + self.salary
  end


end


cj = Employee.new("cj", "TA", 1_000_000, "Ned")

ned = Manager.new("ned", "teacher", 50, "kush")

kush = Manager.new("kush", "office_guy", 5, nil)

ned.assign_underling(cj)

kush.assign_underling(ned)


pp kush.bonus(2)



