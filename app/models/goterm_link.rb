class GotermLink < ActiveRecord::Base
	self.primary_keys = "header","id"
	self.table_name = "goterm_link"
	belongs_to :Sequence, foreign_key: :header
	belongs_to :Goterm, foreign_key: :id
end
