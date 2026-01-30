# frozen_string_literal: true

class ApplicationService
  Response = Struct.new(:success?, :payload, :error) do
    def failure?
      !success?
    end
  end

  def self.call(*args, **kwargs)
    service = new
    kwargs.any? ? service.call(**kwargs) : service.call(*args)
  end

  def success(payload = nil)
    Response.new(true, payload)
  end

  def failure(exception, options = {})
    Response.new(false, nil, exception)
  end
end
