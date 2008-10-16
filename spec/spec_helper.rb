require 'rubygems'
gem 'rspec', '>=1.1.8'
require 'spec'
require 'pathname'

SPEC_ROOT = Pathname(__FILE__).dirname.expand_path
require SPEC_ROOT.parent + 'lib/dm-core'
require File.join(SPEC_ROOT, "/lib/adapter_helpers")

# These environment variables will override the default connection string:
#   MYSQL_SPEC_URI
#   POSTGRES_SPEC_URI
#   SQLITE3_SPEC_URI
#
# For example, in the bash shell, you might use:
#   export MYSQL_SPEC_URI="mysql://localhost/dm_core_test?socket=/opt/local/var/run/mysql5/mysqld.sock"

ENV['ADAPTERS'] ||= 'sqlite3'
# ENV['ADAPTERS'] ||= 'sqlite3_fs'

HAS_DO   = DataMapper::Adapters.const_defined?("DataObjectsAdapter")
ADAPTERS = {
  "sqlite3"    => 'sqlite3::memory:',
  "sqlite3_fs" => "sqlite3://#{SPEC_ROOT}/db/primary.db",
  "mysql"      => 'mysql://localhost/dm_core_test',
  "postgres"   => 'postgres://postgres@localhost/dm_core_test'
}
ALTERNATE = {
  # "sqlite3"  => 'sqlite3::memory:',
  "sqlite3_fs" => "sqlite3://#{SPEC_ROOT}/db/secondary.db",
  "mysql"      => 'mysql://localhost/dm_core_test2',
  "postgres"   => 'postgres://postgres@localhost/dm_core_test2'
}

ADAPTERS.each do |adapter, default|
  connection_string = ENV["#{adapter.to_s.upcase}_SPEC_URI"] || default
  begin
    DataMapper.setup(adapter.to_sym, connection_string)
  rescue Exception => e
    ADAPTERS.delete(adapter)
  end
end

# DataMapper.setup(:default, ADAPTERS[ENV['ADAPTERS']])

DataMapper::Logger.new(nil, :debug)

Spec::Runner.configure do |config|
  config.include(DataMapper::Spec)
  config.after(:each) do
    DataMapper::Resource.descendants.clear
  end
end
