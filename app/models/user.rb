class User < ActiveRecord::Base
  has_many :authorizations, dependent: :destroy, inverse_of: :user
  validates :name, :email, :presence => true

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def add_provider(auth_hash)
    # Check if the provider already exists, so we don't add it twice
    unless auth = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      auth = self.authorizations.create provider: auth_hash["provider"], uid: auth_hash["uid"],
                                        expires_at: Time.at(auth_hash["credentials"]["expires_at"]).to_datetime,
                                        auth_token: auth_hash["credentials"]["token"]
    end

    auth
  end

  def not_expired_token?(provider)
    Authorization.with_valid_token(provider).for_user(self).first != nil
  end
end
