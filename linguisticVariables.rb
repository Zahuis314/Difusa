class LinguisticVariable

	# @param [string] name
	# @param [Method] term
	attr_reader :name, :terms
	attr_accessor :logic
	def initialize(name,*terms)
		terms.each {|term| term.parent = self}

		@name = name
		@terms = Hash[terms.map { |term| [term.name,term] }]
		@min = terms.min { |a, b| a.min<=>b.min }.min
		@max = terms.min { |a, b| b.max<=>a.max }.max
	end
	def get_evaluation(x)
		Hash[@terms.values {|term| [term.name,term.call(x)]}]
	end
	def evaluate(x)
		@terms.each_value do |term|
			term.evaluate(x)
		end
	end
	def get_values
		result = Hash.new
		@terms.each_value do |term|
			result[term.name] = term.value
		end
		result
	end
	def plot
		# x = (@min..@max).step(0.1).to_a
		# y = @terms.map {|term| term.call(x)}
		# title = @terms.map {|term| term.name}
		data=[]
		@terms.each_value do |term|
			x = (@min..@max).step((@max-@min)/100.0).to_a
			data << { 	x: x,
			  			y: term.call(x),
						title: term.name
			}
		end
		Plot.plot_array data, @name
	end
	def ==(other)
		@name==other.name
	end
end
class LinguisticTerm
	# @param [string] name
	# @param [Function] func
	attr_reader :name, :func
	attr_accessor :parent, :value, :op
	def initialize(name, func)
		@name = name
		@func = func
	end
	def evaluate(x)
		@value = @func.call x
	end
	def call(x)
		if x.is_a? Array
			x.map { |i| @func.call i }
		else
			@func.call x
		end
	end
	def min
		@func.min
	end
	def max
		@func.max
	end
	def &(another)
		result = LinguisticTerm.new("#{@name}And#{another.name.capitalize}",Proc.new {|value| @parent.logic.operator.and(@value,another.value) })
		result.parent = @parent
		result.value = @parent.logic.operator.and(@value,another.value)
		result
	end
	def |(another)
		result = LinguisticTerm.new("#{@name}And#{another.name.capitalize}",Proc.new {|value| @parent.logic.operator.or(@value,another.value) })
		result.parent = @parent
		result.value = @parent.logic.operator.or(@value,another.value)
		result
	end
	def !()
		p 'caca'
		true
	end
	def not
		@parent.logic.operator.not @value
	end
	def to_s
		"#{@name}: #{@value}"
	end
end
class Function

	attr_reader :min,:max,:proc
	# @param [Proc] proc
	# @param [Number] min
	def initialize(proc,min,max)
		@proc = proc
		@min = min
		@max = max
	end
	def call(x)
		@proc.call x
	end
	def plot(title)
		x = (@min..@max).step((@max-@min)/100.0).to_a
		y = x.map{|v|@proc.call(v)}

		Plot.plot x,y,title
	end
	def self.Triangle(a,b,c,x)
		o1 = x - a
		o2 = b - a
		o3 = c - x
		o4 = c - b
		[[o1.to_f / o2, o3.to_f / o4].min, 0].max
	end
	def self.Trapezoidal(a,b,c,d,x)
		o1 = x - a
		o2 = b - a
		o3 = d - x
		o4 = d - c
		[[o1.to_f / o2, [1, o3.to_f / o4].min].min, 0].max
	end
	def self.Gamma(a,b,c,x)
		[[(x - a).to_f / (b - a),1].min, 0].max
	end
	def self.L(a,b,c,x)
		1- [[(x - b).to_f / (c - b).to_f,1].min, 0].max
	end
	def self.GenerateFunction(name,*params)
		method = self.method(name.to_sym)
		unless method.arity == (params.length + 1)
			raise "Non matching arity"
		end
		proc = method.curry
		Function.new proc.call(*params), params.min, params.max
	end
end
