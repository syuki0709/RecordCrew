class AdminUser < ApplicationRecord
	belongs_to :studio

  has_secure_password
end
