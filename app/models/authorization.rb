class Authorization < ActiveRecord::Base
  belongs_to :user, inverse_of: :authorizations
  validates :provider, :uid, :auth_token, presence: true

  scope :with_valid_token, ->(provider) { where("(expires_at is null or expires_at > NOW()) AND provider = ?", provider) }
  scope :for_user, ->(user) { where("user_id = ?", user) }

  def self.find_or_create(auth_hash, user)
    unless auth = find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      unless user then
        raw_info = auth_hash["info"]
        user = User.create name: raw_info["name"], email: raw_info["email"], image: raw_info["image"], nickname: raw_info["nickname"]
      end
      auth = user.add_provider auth_hash
    else
      auth.update_attributes(
          expires_at: Time.at(auth_hash["credentials"]["expires_at"]).to_datetime,
          auth_token: auth_hash["credentials"]["token"]
      )
    end

    auth
  end
end
