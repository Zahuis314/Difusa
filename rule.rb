class Rule
	def initialize(terms,cons)
		@terms = terms
		@cons = cons
	end
end

class RuleTerm
	# @param [LinguisticTerm] term
	# @param [Operator] op
	attr_reader :value

	def initialize(term, value, op=ZadehOperator)
		@term = term
		@value = term.evaluate value
		@op = op
	end
	def and(anotherRule)
		@op.and @value, anotherRule.value
	end
	def or(anotherRule)
		@op.or @value, anotherRule.value
	end
	def not
		@op.not @value
	end
	def +(anotherRule)
		self.or anotherRule
	end
	def ^(anotherRule)
		self.and anotherRule
	end
	def !
		self.not
	end
end