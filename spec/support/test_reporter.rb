module TestReporter
  
  class Called < Exception
    attr_accessor :middleware, :env
    def initialize(middleware:, env:)
      @middleware = middleware
      @env = env
    end
  end

  module Notify
    def self.included(base)
      base.send :include, Enableable
    end

    def after(env)
      return unless middleware = enabled_middleware(TestReporter, env)
      raise Called, middleware: middleware, env: env
    end
  end

  module Middleware
    module Query
      module Exec ;                     include Notify ; end
      module Tables ;                   include Notify ; end
      module Indexes ;                  include Notify ; end
    end

    module Migration
      module Column ;                   include Notify ; end
      module ColumnOptionsSql ;         include Notify ; end
      module Index ;                    include Notify ; end
      module IndexComponentsSql ;       include Notify ; end
    end

    module Model
      module Columns ;                  include Notify ; end
      module ResetColumnInformation ;   include Notify ; end
    end

    module Dumper
      module Extensions ;               include Notify ; end
      module Tables ;                   include Notify ; end
      module Table ;                    include Notify ; end
      module Indexes ;                  include Notify ; end
    end
  end
end

SchemaMonkey.register(TestReporter)