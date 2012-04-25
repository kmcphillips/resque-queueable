module ResqueQueueable

  class InvalidQueue < StandardError ; end

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def resqueable
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
    end
  end
end

ActiveRecord::Base.send :include, ResqueQueueable
