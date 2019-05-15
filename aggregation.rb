class Aggregation
	def self.implication(**argv);end
	def self.aggregation(*funcs);end
end

class MamdaniTruncate < Aggregation
	def self.implication(obj,**argv)
		argv.transform_values! {|v| v.max }
		# p argv
		result = []
		minProc = Proc.new {|x,y| [x,y].min}
		obj.terms.each_pair do |k,v|
			p v.func
			f = v.func.proc
			g = minProc.curry.call argv[v.name.to_sym]
			result << LinguisticTerm.new(v.name+"Truncated",Function.new(Proc.new{|x| g.call(f.call(x))}, v.func.min, v.func.max))
		end
		LinguisticVariable.new(obj.name+"Truncated",*result)
	end

	# @param [LinguisticVariable] var
	def self.aggregation(var)
		newVar =var.terms.transform_values do |term|
			term.func
		end
		values = newVar.values
		max = (values.map {|val| val.max}).max
		min = (values.map {|val| val.min}).min
		Function.new(Proc.new{|x| values.map{|value| value.call(x)}.max},min,max)
	end
end

class MamdaniReduce < Aggregation
	def self.implication(obj,**argv)
		argv.transform_values! {|v| v.max }
		# p argv
		result = []
		obj.terms.each_pair do |k,v|
			p v.func
			f = v.func.proc
			result << LinguisticTerm.new(v.name+"Truncated",Function.new(Proc.new{|x| f.call(x)*argv[v.name.to_sym]}, v.func.min, v.func.max))
		end
		LinguisticVariable.new(obj.name+"Truncated",*result)
	end

	# @param [LinguisticVariable] var
	def self.aggregation(var)
		newVar =var.terms.transform_values do |term|
			term.func
		end
		values = newVar.values
		max = (values.map {|val| val.max}).max
		min = (values.map {|val| val.min}).min
		Function.new(Proc.new{|x| values.map{|value| value.call(x)}.max},min,max)
	end
end

# f<<g
# f(g(x))
#
# f>>g
# g(f(x))