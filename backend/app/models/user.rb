class User < ApplicationRecord
    has_many :posts, dependent: :destroy

    # followingを管轄するactive_relationship
    has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

    # followedを管轄するpassive_relationship
    has_many :passive_relationships, class_name: "Relationship",
                                    foreign_key: "followed_id", dependent: :destroy

    has_many :likes, dependent: :destroy

    # has_many_throughの中間テーブルを定義する
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    has_many :liked_posts, through: :likes, source: :post

    attr_accessor :activation_token, :reset_token
    before_save { self.email.downcase! }
    before_create :create_activation_digest

    validates(:name, presence: true, length: { maximum: 50 })
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates(:email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false })
    validates(:password, presence: true, length: { minimum: 6 }, allow_nil: true)
    #security code
    has_secure_password

    # 渡された文字列のハッシュ値を返す
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # 渡したTokenが保存されているdigestと等しいかを検証
    def authenticated?(attribute, token)
        digest = self.send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    # アカウントを有効にする
    def activate
        update_columns(activated: true, activated_at: Time.zone.now)
    end

    # 有効化用のメールを送信する
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    #activation_tokenを再設定する
    def reset_activation_digest
        self.activation_token = User.new_token
        update_column(:activation_digest, User.digest(activation_token))
    end

    # パスワード再設定の属性を設定する
    def create_reset_digest
        self.reset_token = User.new_token
        update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    end

    # パスワード再設定のメールを送信する
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    # ユーザーのステータスフィードを返す
    def feed(offset, limit)
        following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
        if limit > 0
        Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id).with_attached_image.includes(:user).limit(limit).offset(offset)
        else
        Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id).with_attached_image.includes(:user).offset(offset)
        end
    end

    # ユーザーをフォローする
    def follow(other_user)
        following.push(other_user)
    end

    #ユーザーをフォロー解除する
    def unfollow(other_user)
        active_relationships.find_by(followed_id: other_user.id).destroy
    end

    # 現在のユーザーがフォローしてたらtrueを返す
    def following?(other_user)
        following.include?(other_user)
    end

    # 現在のユーザーがフォローされていたらtrueを返す
    def followed?(other_user)
        followers.include?(other_user)
    end

    private

    # ランダムなトークンを返す
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    # 有効化トークンとダイジェストを作成および代入する user.create前に実行される
    def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
    end
end
