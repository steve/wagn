def approve
  @was_new_card = self.new_card?
  @action = case
    when trash     ; :delete
    when new_card? ; :create
    else             :update
  end
  run_callbacks :approve
  errors.empty?
rescue Exception=>e
  rescue_event e
end


def store
  run_callbacks :store do
    yield
    @virtual = false
  end
rescue Exception=>e
  rescue_event e
ensure
  @from_trash = nil
end


def extend
#    puts "extend called"
  run_callbacks :extend
rescue Exception=>e
  rescue_event e
ensure
  @action = nil
end


def rescue_event e
  @action = nil
  expire_pieces
  if @subcards
    @subcards.each { |card| card.expire_pieces }
  end
  raise e
end

def event_applies? opts
  if !opts[:on] or Array.wrap( opts[:on] ).member? @action
    if opts[:when]
      opts[:when].call self
    else
      true
    end
  end
end
