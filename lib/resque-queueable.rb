module ResqueQueueable

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def queueable
      include InstanceMethods
      extend SingletonMethods
      true
    end
  end

  module InstanceMethods
    def queue
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
      Resque.enque(klass, id, method, *args)
    end
  end
end

ActiveRecord::Base.send :include, ResqueQueueable
