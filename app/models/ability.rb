# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # Get abilities from the JSON file.
  # Cache them.
  #
  # Result::
  # * Hash<String, Array<String> >: The list of market IDs per user name
  def self.abilities
    @abilities = JSON.parse(File.read("#{Rails.root}/#{Rails.env.test? ? 'spec' : 'config'}/#{Rails.configuration.x.abilities_file}"))['abilities'] unless @abilities
    @abilities
  end
  @abilities = nil

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    user ||= User.new
    (Ability.abilities[user.user_name] || []).each do |allowed_market_id|
      if allowed_market_id == '*'
        can :read, :all
      else
        can :read, allowed_market_id
      end
    end
  end

end
