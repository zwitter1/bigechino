class Taxa < ActiveRecord::Base
	self.table_name = "taxa"
	self.primary_key = "id"
	belongs_to :Sequence, foreign_key: :taxa_id, :class_name => "Sequence", primary_key: :tax_id
end
