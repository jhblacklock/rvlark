class ActiveSupport::HashWithIndifferentAccess
  def to_datetime(name)
    units = select { |k, _v| k.match /#{name}\(..\)/ }.map { |_k, v| v.to_i }
    DateTime.new(*units)
  end
end
