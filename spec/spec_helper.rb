require 'active_record'
require 'active_support'
require 'resque'
require 'resque-queueable'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  # config.filter_run :focus
end


## Manually setup the Active Record DB stuff and a test model

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "#{File.expand_path(File.join(File.dirname(__FILE__), '..'))}/spec/db/test.sqlite3"
)

ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'pies'")
ActiveRecord::Base.connection.create_table(:pies) do |t|
  t.string :kind
end

class Pie < ActiveRecord::Base
  resqueueable

  def is(adj)
    "This pie ##{self.id} is #{adj}"
  end
end
