class Sequence < ActiveRecord::Base
	self.primary_key = "header"
	has_many :ForeignLink, foreign_key: :header
	has_many :Foreigndb, through: :ForeignLink
	has_one :Taxa, foreign_key: :id, primary_key: :taxa_id
	has_many :GotermLink, foreign_key: :header
	has_many :Goterm, through: :GotermLink
end

