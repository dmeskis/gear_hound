module Permissions
  extend ActiveSupport::Concern
  included do
    # There are two types of permission implementations on this server: Plural Based and Singular Based
    #
    # Plural Based Permissions -------------------------------------------------------------------------
    #
    # Permissions for lists of data. Policy context will be compiled to a string list based on their relations
    # with actual models. Those string lists can be matched against using rapid word matching algos to give us
    # an easy way to filter lists based on user permission levels with those actual records.
    #
    # Record.policy: "u3h:0 u3h:1 u3hg2b:2"
    #
    # The above policy string describes in simple words the relational ties and the states of those relations.
    # For instance, the above string reads in english as:
    # User of id 3h can read, User of id 3h can write, User of id 3h in group of id 2b can write.
    # Basically these policy "words" allow us to quickly filter based on the scope of the question to the API.
    # So if a used asked for "All reports I can edit" then the server would query for "u3h:1" on reports.
    #
    # Singular Based Permissions -----------------------------------------------------------------------
    #
    # Permissions for singular models. Policy context can be directly accessed via normalized relational data.
    # There are helpers on the user model to answer these questions. Those helpers look at a users relation
    # to groups and networks. The API would grab a group id from an object and send it to the user like:
    #
    # @current_user.can_read_group?(group_id)
    #
    # If an object has a relation to a group, and a user it in that group, then this will return true.

    # def action_policy_match?(args)
    #   if args[:resource].class.in?[Group, Network]
    #     return args[:accessor].can_read_resource?(args[:resource]) if args[:action] == :read
    #     return args[:accessor].can_write_resource?(args[:resource]) if args[:action] == :write
    #     return args[:accessor].can_admin_resource?(args[:resource]) if args[:action] == :admin
    #   end
    #   ac = ["ac-g6b1", "ac-nzg1"]
    #   words = ["u2n:0", "gu8:0", "nJ2:0"]
    #   nap = "ac-nzg uO3:0 uq7:0 u2n:0 uZE:0 gAj:0 gDG:0 g6b:0".split
    #   gap = "ac-g6b uO3:0 uO3:1 uO3:2 uq7:0 uq7:1 uq7:2 u2n:0 u2n:1 u2n:2 uZE:0 uZE:1 uZE:2 nzg:0".split
    #   p "#{ac.length} | #{words.length} | #{nap.length} | #{gap.length} | #{(nap - ac).length < nap.length} | #{(gap - ac).length < gap.length}"
    # end

    def can_perform_read?
      return true
      # Come back and perform cleanup here 
      # if @BATCH_QUERY
      #   @batch_models.each do |model_cache|
      #     return error([:read_denied]) if @PERMISSIONS && !can_perform_action?({resource: model_cache[:model], action: :read})
      #   end
      # else
      #   return error([:read_denied]) if @PERMISSIONS && !can_perform_action?({resource: @model, action: :read})
      # end
    end

    def can_perform_write?
      return true
      # if @BATCH_QUERY
      #   @batch_models.each do |model_cache|
      #     return error([:write_denied]) if @PERMISSIONS && !can_perform_action?({resource: model_cache[:model], action: :write})
      #   end
      # else
      #   return error([:write_denied]) if @PERMISSIONS && !can_perform_action?({resource: @model, action: :write})
      # end
    end

    def can_perform_create?
      return true 
      # if @BATCH_QUERY
      #   @model_payload.each do |payload|
      #     return error([:write_denied]) if @PERMISSIONS && !can_perform_action?(payload: payload, action: :create)
      #   end
      # else
      #   return error([:write_denied]) if @PERMISSIONS && !can_perform_action?(payload: @model_payload, action: :create)
      # end
    end

    def can_perform_action?(args)
      return true
      # return false if (args[:resource].blank? || args[:action].blank?) && args[:action] != :create
      # return args[:resource].can_share_token_perform_action?(share_token: @share_token, action: args[:action]) if @share_token
      # return @MODEL.can_user_perform_create?(user: @current_user, payload: args[:payload], action: args[:action]) if args[:action] == :create

      # # Gather together the resources needed to determine access privelages.
      # policy_action = args[:resource].determine_action(args[:action])
      # ac, words = session_policy_words(policy_action)
      # access_policy = args[:resource].access_policy.split
      # policy_match = word_match?(ac, access_policy) && word_match?(words, access_policy)
      # return policy_match if policy_match
      # # If there isn't a policy match then check additional policy scope
      # return args[:resource].can_user_perform_action?({user: @current_user, action: args[:action]})
    end

    # def session_policy_words(action = :read)
    #   s = @current_session
    #   a = [:read, :write, :admin].index(action)

    #   # Access Context: The parent context of a model which can broadly be thought of as a `channel`. Policy `words` can be matched against
    #   # to determine access privelages, but without a matching access context which matches a users session there will be no match found.
    #   # Basically both an access context AND a matching policy word must be found in order for a successful match to be determined.
    #   ac = ["ac-g#{s[:group_id]}", "ac-n#{s[:network_id]}"]

    #   # Policy Words: Accessors on a policy are compiled into the access_policy of any given resource. These accessors are denormalized
    #   # as `words` in a single string which can be matched against at read time to determine data access privelages. There must be
    #   # both an access context AND word match in order for a policy match to be successful.
    #   words = ["u#{s[:user_id]}:#{a}", "g#{s[:group_id]}:#{a}", "n#{s[:network_id]}:#{a}"]

    #   return ac, words
    # end

    # def session_policy_words_query(action = :read)
    #   ac, words = session_policy_words(action)
    #   ac = ac + @current_session[:max_policy_set] if @META[:admin]
    #   return ac + words
    # end

    # def word_match?(words, policy)
    #   (policy - words).length < policy.length
    # end
  end
end
