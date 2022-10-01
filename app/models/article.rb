class Article < ApplicationRecord
    include Visible
    has_many :comments, dependent: :destroy
    belongs_to :user
    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 10 }

    def user_email
        user.email
    end


    after_create_commit :broadcast_new_article
    after_update_commit :broadcast_updated_article
      
      
    after_destroy_commit do
      broadcast_destroy_article
    end
    
    def broadcast_new_article
      current_user = user
        broadcast_prepend_later_to 'public_articles',
                                    target: 'public_articles',
                                    partial: 'articles/card_view',
                                    locals: { article: self, join_status: false,current_user: current_user }
        broadcast_prepend_later_to 'private_articles',
                                    target: 'private_articles',
                                    partial: 'articles/card_view',
                                    locals: { article: self, join_status: false,current_user: current_user }
      end
    
      def broadcast_updated_article
        current_user = user
        shared_target_article = "article_#{id}"
        private_target_channel = "#{@user_gid} private_joins"
        broadcast_replace_later_to 'public_articles',
                                    target: shared_target_article,
                                    partial: 'articles/card_view',
                                    locals: { article: self,join_status: false, current_user: current_user }
        broadcast_replace_later_to "private_articles",
                                    target: shared_target_article,
                                    partial: 'articles/card_view',
                                    locals: { article: self, join_status: false, current_user: current_user }
      end
  
    
      def broadcast_destroy_article
        
        broadcast_remove_to 'public_articles',
                            target: "article_#{id}"
        broadcast_remove_to 'private_articles',
                            target: "article_#{id}"
      end
end
