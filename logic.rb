class Logic
  attr_reader :variables,:operator
  # @param [Operator] operator
  # @param [Aggregation] aggregation
  # # @param [Defuzzification] defuzzification
  def initialize(operator=ZadehOperator,aggregation=MamdaniMin,defuzzification=Centroide)
    @cantidadPoca       = LinguisticTerm.new('Poca',      Function.GenerateFunction('L', 0,1500,4500))
    @cantidadNormal     = LinguisticTerm.new('Normal',    Function.GenerateFunction('Triangle', 1000,3500,6500))
    @cantidadMucha      = LinguisticTerm.new('Mucha',     Function.GenerateFunction('Triangle', 3500,5500,8000))
    @cantidadDemasiada  = LinguisticTerm.new('Demasiada', Function.GenerateFunction('Gamma', 4500,7000,9000))
    @cantidad = LinguisticVariable.new('CantidadDeRopa',@cantidadPoca,@cantidadNormal,@cantidadMucha,@cantidadDemasiada)

    @suciedadSucia    = LinguisticTerm.new('Sucia',   Function.GenerateFunction('L', 0,2,3.5))
    @suciedadRegular  = LinguisticTerm.new('Regular', Function.GenerateFunction('Trapezoidal', 2.5,4,6,7.5))
    @suciedadLimpia   = LinguisticTerm.new('Limpia',  Function.GenerateFunction('Gamma', 6.5,8,10))
    @suciedad = LinguisticVariable.new('SuciedadDeRopa',@suciedadSucia,@suciedadRegular,@suciedadLimpia)

    @calidadMala    = LinguisticTerm.new('Mala',    Function.GenerateFunction('L', 0,0,4))
    @calidadRegular = LinguisticTerm.new('Regular', Function.GenerateFunction('Trapezoidal', 0,3,7,10))
    @calidadBuena   = LinguisticTerm.new('Buena',   Function.GenerateFunction('Gamma', 6,10,10))
    @calidad = LinguisticVariable.new('CalidadDeDetergente',@calidadMala,@calidadRegular,@calidadBuena)

    @detergentePoca  = LinguisticTerm.new('Poca',  Function.GenerateFunction('L', 0,40,80))
    @detergenteMedia = LinguisticTerm.new('Media', Function.GenerateFunction('Trapezoidal', 40,80,120,160))
    @detergenteMucha = LinguisticTerm.new('Mucha', Function.GenerateFunction('Gamma', 120,160,200))
    @detergente = LinguisticVariable.new('CantidadDeDetergente',@detergentePoca,@detergenteMedia,@detergenteMucha)

    @variables = [@cantidad,@suciedad,@calidad]
    @operator = operator
    @aggregation = aggregation
    @defuzzification = defuzzification
    @variables.each { |variable| variable.logic = self }
  end

  # @param [Hash] dict
  def fuzzification(dict)
    @variables.each do |variable|
      value = dict.fetch(variable.name.to_sym,nil)
      unless value.nil?
        variable.evaluate value
      end
    end
  end
  def plot
    @variables.each do |variable|
      variable.plot
    end
    @detergente.plot
  end
  def get_values
    Hash[
      @variables.map do |variable|
        [variable.name,variable.get_values]
      end
    ]
  end
  def rules
    poca,media,mucha = [],[],[]

    regla1 = @suciedadLimpia
    poca << regla1

    regla2 = @cantidadPoca & @suciedadSucia & (@calidadMala | @calidadRegular)
    media << regla2
    regla3 = @cantidadPoca & @suciedadRegular & (@calidadMala | @calidadRegular)
    poca << regla3
    regla4 = @cantidadPoca  & @calidadBuena
    poca << regla4

    regla5 = (@cantidadNormal | @cantidadDemasiada) & @suciedadSucia
    mucha << regla5
    regla6 = @cantidadNormal & @suciedadRegular
    media << regla6

    regla7 = @cantidadMucha & (@suciedadSucia | @suciedadRegular) & @calidadMala
    mucha << regla7
    regla8 = @cantidadMucha & @suciedadSucia & @calidadRegular
    mucha << regla8
    regla9 = @cantidadMucha & @suciedadSucia & @calidadBuena
    media << regla9
    regla10 = @cantidadMucha & @suciedadRegular & (@calidadRegular | @calidadBuena)
    media << regla10

    regla11 = @cantidadDemasiada & @suciedadRegular & (@calidadMala | @calidadRegular)
    mucha << regla11
    regla12 = @cantidadDemasiada & @suciedadRegular & @calidadBuena
    media << regla12

    poca.map! {|val| val.value}
    media.map! {|val| val.value}
    mucha.map! {|val| val.value}
    implicationFunctions = @aggregation.implication( @detergente,Poca: poca, Media: media, Mucha: mucha)
    # implicationFunctions.plot
    aggregationFunction = @aggregation.aggregation(implicationFunctions)
    # aggregationFunction.plot "Aggregation - #{@operator}-#{@aggregation}-#{@defuzzification} "
    aggregationFunction
  end

  def defuzzification(func)
    @defuzzification.defuzzification(func)
  end

  def simulate(dict)
    self.fuzzification(dict)
    self.plot
    a = self.get_values
    func = self.rules

    self.defuzzification func
  end
end