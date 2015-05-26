class Goterm < ActiveRecord::Base
	self.primary_key = "id"
	self.table_name = "goterm"
	has_many :GotermLink, primary_key: :id
	has_many :Sequence, through: :GotermLink
end
