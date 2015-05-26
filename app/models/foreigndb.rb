class Foreigndb < ActiveRecord::Base
	self.primary_key = "id"
	self.table_name = "foreigndb"
	has_many :ForeignLink, primary_key: :id
	has_many :Sequence, through: :ForeignLink
end
