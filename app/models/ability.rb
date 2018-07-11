class Ability
  include CanCan::Ability

  def initialize(user, controller_namespace)
    can :home, Page
    can :manage, UserSession

    return unless user.present?
    if controller_namespace != 'Admin'
      can :manage, Page
      can :manage, Client
      can :manage, Project
      can :manage, ProjectGroup
      can :manage, UserMember
      can :manage, ProjectFile
      can :manage, Member
      can :manage, Bill

      can :read, ProjectFileGroup
      can :create, ProjectFileGroup

      can :read, Partner
      can :create, Partner
      can :update, Partner

      can :read, User

      can :cd, ProjectCd
      can :search_result, Bill
      can :download, Bill
      can :download, Xlsx
      can :download, Pdf
    end

    can :manage, :all if user.role.admin?
  end
end
