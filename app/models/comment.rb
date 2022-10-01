class Comment < ApplicationRecord
  include Visible

  belongs_to :article
  def user_email
    user.email
end
end
