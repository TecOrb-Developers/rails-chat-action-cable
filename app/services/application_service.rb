# A service to add syntactic sugar, so we can call any service that inherits
# from this service without having to do .new and .call,
# e.g. InheritingService.call(1, 2, 3) instead of InheritingService.new(1, 2, 3).call
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
