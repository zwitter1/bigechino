class ForeignLink < ActiveRecord::Base 
	self.table_name = "foreigndb_link"
	self.primary_keys = "id","header"
	belongs_to :Sequence
	belongs_to :Foreigndb, foreign_key: :id
	
end
