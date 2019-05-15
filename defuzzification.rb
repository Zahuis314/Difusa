class Defuzzification
	def self.defuzzification(func);end
end

class Centroide < Defuzzification
	def self.defuzzification(func)
		numerator=0.0
		denominator=0.0
		x = (func.min..func.max).step((func.max-func.min)/1000.0)
		y = x.map { |i| func.call(i)}
		x.each_with_index do |i,index|
			numerator   += i*y[index]
			denominator += y[index]
		end
		numerator/denominator
	end
end