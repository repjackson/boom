if Meteor.isClient
    Router.route '/users', -> @render 'users'

    Template.users.onCreated ->
        @autorun -> Meteor.subscribe('users')
        # @autorun => Meteor.subscribe 'user_search', Session.get('username_query')
        Session.setDefault('view_limit', 20)
    Template.users.helpers
        user_docs: ->
            # username_query = Session.get('username_query')
            # if username_query
            #     Meteor.users.find({
            #         username: {$regex:"#{username_query}", $options: 'i'}
            #         # roles:$in:['resident','owner']
            #         },{ limit:parseInt(Session.get('view_limit')) }).fetch()
            # else
            #     # Meteor.users.find({
            #     #     },{ limit:parseInt(Session.get('view_limit')) }).fetch()
            Meteor.users.find(
                app:'bc'
                )
    Template.users.events
        'click .add_user': ->
            new_username = prompt('username')
            options = {
                username:new_username
                password:new_username
                }
            Meteor.call 'add_user', options, (err,res)=>
                if err 
                    console.log err
                else
                    console.log "RES",res
                    # if res is 1
                    new_user = 
                        Meteor.users.findOne 
                            username:new_username
                        # new_user = Meteor.users.findOne res
                    # Meteor.users.update res,
                    #     $set:app:'bc'
                    Router.go "/user/#{new_username}"
        'keyup .username_search': (e,t)->
            username_query = $('.username_search').val()
            if e.which is 8
                if username_query.length is 0
                    Session.set 'username_query',null
                    Session.set 'checking_in',false
                else
                    Session.set 'username_query',username_query
            else
                Session.set 'username_query',username_query




if Meteor.isServer
    Meteor.methods
        add_user: (options)->
            console.log options
            found_user = 
                Meteor.users.findOne 
                    username:options.username
            if found_user
                Meteor.users.update found_user._id,
                    $set:app:'bc'
            else
                new_id = Accounts.createUser(options)
                Meteor.users.update new_id,
                    $set:app:'bc'
                new_id

    # Meteor.publish 'users', (limit)->
    #     match = {membership_group_ids:$in:[Meteor.user().current_group_id]}
    #     # match.station = $exists:true
    #     limit = if limit then limit else 20
    #     Meteor.users.find(match,limit:limit)
    Meteor.publish 'users', ()->
        Meteor.users.find({app:'bc'},
            limit:42)


    Meteor.publish 'user_search', (username, role)->
        if role
            if username
                Meteor.users.find({
                    app:'bc'
                    username: {$regex:"#{username}", $options: 'i'}
                    # roles:$in:[role]
                },{ limit:42})
            else
                Meteor.users.find({
                    app:'bc'
                    # roles:$in:[role]
                },{ limit:42})
        else
            if username
                Meteor.users.find({
                    username: {$regex:"#{username}", $options: 'i'}
                    app:'bc'
                    # roles:$in:[role]
                },{ limit:42})
            else
                Meteor.users.find({
                    app:'bc'
                    # roles:$in:[role]
                },{ limit:42})
            Meteor.users.find({
                app:'bc'
                username: {$regex:"#{username}", $options: 'i'}
            },{ limit:42})