class Ability
  include CanCan::Ability

  def initialize(user)
    can :home, Page
    can :manage, UserSession

    return unless user.present?

    case user.role
    when 'general', 'superior'
      defaultcan
    when 'admin', 'backoffice'
      admincan
    end
  end

private

  def defaultcan
    can :manage, Page
    can :manage, Client
    can :manage, Project
    can :manage, ProjectGroup
    can :manage, UserMember
    can :manage, ProjectFile
    can :manage, Member
    can :manage, Bill
    can :manage, Approval
    can :manage, ApprovalUser
    can :manage, ApprovalFile

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

    cannot :allread, Approval
  end

  def admincan
    can :manage, :all
    can :allread, Approval
  end
end
