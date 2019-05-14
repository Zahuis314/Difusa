class Operator
    def self.and;end
    def self.or(x,y);end
    def self.not(x);end
end

class ZadehOperator < Operator
    def self.and(x, y)
        [x, y].min
    end
    def self.or(x, y)
        [x, y].max
    end
    def self.not(x)
        1 - x
    end
end

class ProbabilisticOperator < Operator
    def self.and(x, y)
        x * y
    end
    def self.or(x, y)
        x+y - x*y
    end
    def self.not(x)
        1 - x
    end
end