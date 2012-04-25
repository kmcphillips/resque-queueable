module ResqueQueueable

  class InvalidQueue < StandardError ; end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def resqueable(queue)
      @queue = queue

      include InstanceMethods
      extend SingletonMethods
      true
    end
  end

  module InstanceMethods
    def queue
      raise InvalidQueue, "Cannot access a queue for an unsaved record" unless self.id
      Queue.new(self.class, self.id)
    end
  end

  module SingletonMethods
    def perform(id, method, *args)
      # Idle workers lose their DB connection sometimes. This makes sure we have a good connection for each run.
      ActiveRecord::Base.reconnect! if ActiveRecord::Base.respond_to? :reconnect!
      find(id).send(method, *args)
    end
  end

  class Queue
    attr_accessor :klass, :id

    def initialize(klass, id)
      @klass = klass
      @id = id
    end

    def method_missing(method, *args)
      Resque.enqueue(klass, id, method, *args)
      true
    end
  end
end

ActiveRecord::Base.send :include, ResqueQueueable
