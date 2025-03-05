class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
	validates :email, presence: true, uniqueness: true
  validates :account_number, presence: true, uniqueness: true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }

  #associations
  has_many :transactions
  has_many :books, through: :transactions

  before_create :generate_authentication_token

  def regenerate_authentication_token
    self.authentication_token = SecureRandom.hex(20)
    save!
  end

  def update_balance(fee)
    self.update(balance: balance - fee)
  end

  private

  def generate_authentication_token
    self.authentication_token = SecureRandom.hex(20)
  end
end
