class Authorization < ActiveRecord::Base
  belongs_to :user, inverse_of: :authorizations
  validates :provider, :uid, :presence => true

  def self.find_or_create(auth_hash, user)
    unless auth = find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      unless user then
        raw_info = auth_hash["info"]
        user = User.create name: raw_info["name"], email: raw_info["email"], image: raw_info["image"], nickname: raw_info["nickname"]
      end
      auth = user.add_provider auth_hash
    end

    auth
  end
end
