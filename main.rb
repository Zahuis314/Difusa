# require 'rubygems'
require 'gnuplot'
require './operators'
require './plot'
require './rule'
require './linguisticVariables.rb'
require './logic'
require './aggregation'
require './defuzzification'
# x = (0..50).collect { |v| v.to_f }
# y = x.collect { |v| v ** 2 }
#
# Plot.plot(x,y,minX:-10,maxX:60)
def simulate
	operators = [ZadehOperator,ProbabilisticOperator]
	aggegations = [MamdaniMin, LarsenMamdaniProduct]
	defuzzifications = [Centroide,Bisection,BiggestMax,AverageMax,SmallestMax]
	values=[
	  {
		CantidadDeRopa: 4600,
		SuciedadDeRopa: 3.3,
		CalidadDeDetergente: 4
	  },
	  {
		CantidadDeRopa: 8600,
		SuciedadDeRopa: 8.1,
		CalidadDeDetergente: 8
	  },
	]
	2.times do |i|
		p i
		operators.each do |operator|
			aggegations.each do |aggregation|
				defuzzifications.each do |defuzzification|
					l1 = Logic.new(operator,aggregation,defuzzification)
					value1 = l1.simulate(CantidadDeRopa: values[i][:CantidadDeRopa], SuciedadDeRopa: values[i][:SuciedadDeRopa], CalidadDeDetergente: values[i][:CalidadDeDetergente])
					p "#{operator},#{aggregation},#{defuzzification},#{value1}"
				end
			end
		end
	end
end
# simulate
l1 = Logic.new(ZadehOperator,MamdaniMin,SmallestMax)
value1 = l1.simulate(CantidadDeRopa: 4600, SuciedadDeRopa: 3.3, CalidadDeDetergente: 8)
p value1
# l2 = Logic.new(ProbabilisticOperator,LarsenMamdaniProduct,AverageMax)
# value2 = l2.simulate(Cantidad: 4600, Suciedad: 3.3, Calidad: 8)
# p value2
# l3 = Logic.new(ZadehOperator,MamdaniMin,BiggestMax)
# value3 = l3.simulate(Cantidad: 4600, Suciedad: 3.3, Calidad: 8)
# p value3
# l4 = Logic.new(ProbabilisticOperator,LarsenMamdaniProduct,Bisection)
# value4 = l4.simulate(Cantidad: 4600, Suciedad: 3.3, Calidad: 8)
# p value4
# l5 = Logic.new(ZadehOperator,MamdaniMin,Centroide)
# value5 = l5.simulate(Cantidad: 4600, Suciedad: 3.3, Calidad: 8)
# p value5
