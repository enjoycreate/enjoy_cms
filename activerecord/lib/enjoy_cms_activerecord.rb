require 'awesome_nested_set'
require 'paper_trail'
require 'friendly_id'
require 'validates_lengths_from_database'
require 'activerecord-session_store'

module Enjoy
  def self.orm
    :active_record
  end
end

require 'enjoy_cms'
