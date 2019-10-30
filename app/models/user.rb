class User < ApplicationRecord
  attr_accessor   :remember_token, :activation_token, :reset_token
  before_save     :downcase_email
  before_create   :create_activation_digest
  validates       :username, presence: true#, length: {maximum 50},
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates       :email, presence: true,# length: {maximum 250},
                            format: { with: VALID_EMAIL_REGEX },
                            uniqueness: {case_sensitive: false }
  has_secure_password
  validates       :password, presence: true, length: {minimum: 6}, allow_nil: true
  has_many        :microposts, dependent: :destroy
  has_many        :active_relationships, class_name: "Relationship",
                                         foreign_key: "follower_id",
                                         dependent: :destroy
  has_many        :passsive_relationships, class_name: "Relationship",
                                         foreign_key: "followed_id",
                                         dependent: :destroy
  has_many        :following, through: :active_relationships, source: :followed
  has_many        :followers, through: :passsive_relationships, source: :follower

#  class << self

    def User.digest(string)
      cost= ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
                                                  BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
      SecureRandom.urlsafe_base64
    end

    def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end

    def forget
      update_attribute(:remember_digest, nil)
    end

    def activate
      update_attribute(:activated, true)
      update_attribute(:activated_at, Time.zone.now)
    end

    def send_activation_email
      UserMailer.account_activation(self).deliver_now
    end

    def create_reset_digest
      self.reset_token = User.new_token
      update_attribute(:reset_digest, User.digest(reset_token))
      update_attribute(:reset_sent_at, Time.zone.now)
    end

    def send_password_reset_email
      UserMailer.password_reset(self).deliver_now
    end

    def password_reset_expired?
      reset_sent_at < 2.hours.ago
    end

    def feed
      following_ids = "SELECT followed_id FROM relationships
                       WHERE  follower_id = :user_id"
      Micropost.where("user_id IN (#{following_ids})
                       OR user_id = :user_id", user_id: id)
    end

    def follow(other_user)
      following << other_user
    end

    def unfollow(other_user)
      following.delete(other_user)
    end

    def following?(other_user)
      following.include?(other_user)
    end


    def get_queens
      index_url = "https://rupaulsdragrace.fandom.com/wiki/Category:Queens"
      index_doc = Nokogiri::HTML(open(index_url))
      queen_list = index_doc.css('.tabber').last.css('.thumbimage')
      queen_index = queen_list.select.with_index {|_, i| i.even?}
      queen_index[1..185].each do |queen|
        I18n.enforce_available_locales = false
        queen_text = "https://rupaulsdragrace.fandom.com/wiki/#{queen.attr("title")}"
        queen_url = I18n.transliterate(queen_text).split(' ').join('_').gsub(/\(.+/, '')
        queen_doc = Nokogiri::HTML(open(queen_url))
        queen_real_name = queen_doc.css("#mw-content-text > aside > section:nth-child(3) > div:nth-child(3) > div").text.split(' ')
        queen_first_name = queen_real_name[0] || "Ryan"
        queen_last_name = queen_real_name[1] || "Taylor"
        queen_username = queen_doc.css("#mw-content-text > aside > section:nth-child(3) > div:nth-child(2) > div").text.gsub(/[^0-9a-z%&!\n\/(). ]/i, '').split(' ').join('_')
        #queen_username = "#{queen_first_name}#{queen_last_name}"
        queen_primary_image = queen_doc.css('#mw-content-text > aside > figure > a').attribute('href') || queen_doc.css('#pi-tab-0 > figure > a > img').attribute('src')
        queen_email = Faker::Internet.unique.safe_email
        User.create!(username: queen_username,
                    image: queen_primary_image,
                    first_name: queen_first_name,
                    last_name: queen_last_name,
                    email: queen_email,
                    password: "#{queen_first_name}1234",
                    password_confirmation: "#{queen_first_name}1234",
                    admin: false,
                    queen: true,
                    activated: true,
                    activated_at: Time.zone.now)
      end
    end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
