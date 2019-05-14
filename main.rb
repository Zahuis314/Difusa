require 'rubygems'
require 'gnuplot'
require './operators'
require './plot'
require './rule'
require './linguisticVariables.rb'
require './logic'
# x = (0..50).collect { |v| v.to_f }
# y = x.collect { |v| v ** 2 }
#
# Plot.plot(x,y,minX:-10,maxX:60)


l = Logic.new(ZadehOperator)
# l.plot
l.fuzzification(Cantidad: 4600, Suciedad: 3.3, Calidad: 8)
a = l.get_values

rule1 = l.rules
# l.variables.each do |variable|
# 	variable.terms.each_value do |val|
# 		p val.value
# 	end
# end
# p evaluation
# biseccion
# maximos
# centroide
rule1= RuleTerm.new(seco,27)
rule2= RuleTerm.new(mojado,27)
result1 = rule1+rule2
result2 = rule1^rule2
p result1
p result2