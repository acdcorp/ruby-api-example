class Operation
  class Validator
    include Hanami::Validations::Form
    predicates FormPredicates
  end

  class Result
    attr_reader :value, :errors

    def initialize(value: nil, errors: {})
      @value, @errors = value, errors
    end

    def succesfull?
      @errors.empty?
    end

    def failure?
      !succesful?
    end
  end

  class Responder
    def self.respond(response, &bl)
      new(response, &bl).respond
    end

    def initialize(response, &bl)
      instance_eval(&bl)
      @response, @context = response, bl.binding.receiver
    end

    def ok(&bl)
      @ok = bl
    end

    def fail(&bl)
      @fail = bl
    end

    def respond
      if @response.succesfull?
        @context.instance_exec(@response.value, &@ok)
      else
        @context.instance_exec(@response.errors, &@fail)
      end
    end
  end

  def self.call(*args, params, &bl)
    result = new(*args).call(params)
    block_given? ? Responder.respond(result, &bl) : result
  end

  def success(value)
    Result.new(value: value)
  end

  def failure(errors)
    Result.new(errors: errors)
  end
end
