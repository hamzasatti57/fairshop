class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :create, User
      can :manage, User, ["role = ?", 1] do |u|
        u.is_vendor?
      end
    elsif user.vendor?
      can :create, Project
      can :manage, Project, ["company_id IN (?)", user.companies.pluck(:id)] do |project|
        user.companies.pluck(:id).include? project.company_id
        end
      can :create, Product
      can :manage, Product, ["company_id IN (?)", user.companies.pluck(:id)] do |product|
        user.companies.pluck(:id).include? product.company_id
        end
      can [:update, :read], Profile, ["user_id = ?", user.id] do |profile|
        profile.user_id == user.id
      end
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
end