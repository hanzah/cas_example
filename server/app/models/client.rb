class Client < ActiveRecord::Base
  def self.authorize(id, secret)
    where('client_id = ? AND client_secret = ?', id, secret).first
  end
end