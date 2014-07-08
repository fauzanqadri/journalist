class User < ActiveRecord::Base
  ROLE = ["DEFAULT", "ADMIN"]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates_presence_of :full_name

  def is_admin?
    self.role == "ADMIN"
  end
end
