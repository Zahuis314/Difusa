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
class Bisection < Defuzzification
	def self.defuzzification(func)
		x = (func.min..func.max).step((func.max-func.min)/1000.0).to_a
		y = x.map{|x| func.(x)}
		value = 0
		result = (0...x.length).bsearch do |i|
			value = i
			left = y[0...i].sum
			right = y[i..-1].sum
			right <=> left
		end
		x[result.nil? ? value : result]
		# if result.nil? then value else result end
	end
end
class SmallestMax < Defuzzification
	def self.defuzzification(func)
		result = (func.min..func.max).step((func.max-func.min)/1000.0).inject([func.min,0]) do |(x,y),current|
			result = func.(current)
			if result>y
				[current,result]
			else
				[x,y]
			end
		end
		result[0]
	end
end
class AverageMax < Defuzzification
	def self.defuzzification(func)
		result = (func.min..func.max).step((func.max-func.min)/1000.0).inject([func.min,0,[]]) do |(x,y,l),current|
			result = func.(current)
			if result>y
				[current,result,[]]
			elsif result==y
				[x,y,l<<current]
			else
				[x,y,l]
			end
		end
		result[2].sum/result[2].length.to_f
	end
end
class BiggestMax < Defuzzification
	def self.defuzzification(func)
		result = (func.min..func.max).step((func.max-func.min)/1000.0).reverse_each.inject([func.min,0]) do |(x,y),current|
			result = func.(current)
			if result>y
				[current,result]
			else
				[x,y]
			end
		end
		result[0]
	end
end