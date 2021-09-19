Router.route '/u/:username', (->
    @layout 'user_layout'
    @render 'user_dashboard'
    ), name:'user_profile_small'
Router.route '/user/:username', (->
    @layout 'user_layout'
    @render 'user_dashboard'
    ), name:'user_dashboard'
# Router.route '/user/:username/points', (->
#     @layout 'user_layout'
#     @render 'points'
#     ), name:'points'
Router.route '/user/:username/topups', (->
    @layout 'user_layout'
    @render 'user_topups'
    ), name:'user_topups'
Router.route '/user/:username/received', (->
    @layout 'user_layout'
    @render 'user_received'
    ), name:'user_received'
Router.route '/user/:username/sent', (->
    @layout 'user_layout'
    @render 'user_sent'
    ), name:'user_sent'
Router.route '/user/:username/posts', (->
    @layout 'user_layout'
    @render 'user_posts'
    ), name:'user_posts'
Router.route '/user/:username/orders', (->
    @layout 'user_layout'
    @render 'user_orders'
    ), name:'user_orders'
Router.route '/user/:username/subscriptions', (->
    @layout 'user_layout'
    @render 'user_subscriptions'
    ), name:'user_subscriptions'


Template.user_subscriptions.onCreated ->
    @autorun -> Meteor.subscribe 'user_subscribed_to', Router.current().params.username, ->
    @autorun -> Meteor.subscribe 'user_subscribed_by', Router.current().params.username, ->
        

Template.user_subscriptions.helpers
    subscribed_by: ->
        user = Meteor.users.findOne username:Router.current().params.username
        Meteor.users.find 
            _id:$in:user.subscribed_user_ids
        
    subscribed_to: ->
        user = Meteor.users.findOne username:Router.current().params.username
        Meteor.users.find 
            subscribed_user_ids:$in:[user._id]
    

Template.user_layout.onCreated ->
    @autorun -> Meteor.subscribe 'user_from_username', Router.current().params.username, ->
    @autorun -> Meteor.subscribe 'user_topups', Router.current().params.username, ->

Template.user_layout.onRendered ->
    Meteor.call 'calc_user_points', Router.current().params.username, ->
    Meteor.call 'log_profile_view', Router.current().params.username, ->
    # Meteor.call 'calc_user_tags', Router.current().params.username, ->
    # Meteor.setTimeout ->
    #     $('.button').popup()
    # , 2000


Template.user_layout.helpers
    user_from_username_param: -> Meteor.users.findOne username:Router.current().params.username
    user: -> Meteor.users.findOne username:Router.current().params.username
Template.user_topups.helpers
    topups: ->
        Docs.find 
            model:'topup'


# Template.user_orders.onCreated ->
#     @autorun -> Meteor.subscribe 'user_orders', Router.current().params.username, ->
# Template.user_orders.helpers
#     order_docs: ->
#         Docs.find 
#             model:'order'
#             _author_username:Router.current().params.username

# Template.user_topups.events
#     'click .topup': ->
#         Meteor.call 'topup', Router.current().params.username, ->

Template.user_layout.events
    'click .refresh_user_stats': ->
    'click .logout_other_clients': -> Meteor.logoutOtherClients()

    'click .logout': (e,t)->
        $(e.currentTarget).closest('.grid').transition('fly right', 1000)
        Meteor.logout()
        Router.go '/login'

        
Router.route '/user/:username/edit', -> @render 'user_edit'

Template.user_edit.onCreated ->
    @autorun -> Meteor.subscribe 'user_from_username', Router.current().params.username

Template.user_edit.onRendered ->
    # Meteor.setTimeout ->
    #     $('.button').popup()
    # , 2000
    
            


Template.user_sent.onCreated ->
    @autorun => Meteor.subscribe 'transfers', 
        Router.current().params.username
        'sent'
        []
        []
        []
        []
        []
        ,->
    @autorun -> Meteor.subscribe 'transfer_tags', 
        Router.current().params.username
        'sent'
        []
        []
        []
        []
        []
        , ->
        
Template.user_received.onCreated ->
    @autorun => Meteor.subscribe 'transfers', 
        Router.current().params.username
        'received'
        []
        []
        []
        []
        []
        ,->
    @autorun -> Meteor.subscribe 'transfer_tags', 
        Router.current().params.username
        'received'
        []
        []
        []
        []
        []
        , ->
        
        
                
Template.user_sent.helpers
    sent_tags: ->
        Results.find(direction:'sent')
    user_sent_docs: ->
        user = Meteor.users.findOne username:Router.current().params.username
    
        Docs.find 
            model:'transfer'
            _author_username: user.username
            
    sent_items: ->
        current_user = Meteor.users.findOne(username:Router.current().params.username)
        Docs.find {
            model:'transfer'
            _author_id: current_user._id
            # target_id: target_user._id
        },
            sort:_timestamp:-1
        
# Template.user_sent.events
#     'keyup .new_debit': (e,t)->
#         if e.which is 13
#             val = $('.new_debit').val()
#             console.log val
#             target_user = Meteor.users.findOne(username:Router.current().params.username)
#             Docs.insert
#                 model:'transfer'
#                 body: val
#                 target_id: target_user._id




Template.profile_picker.onCreated ->
    @autorun => @subscribe 'ref_doc', @data, ->


Template.profile_picker.events
    'click .pick_tag': (e,t)->
        picked_tags.clear()
        picked_tags.push @title
        $(e.currentTarget).closest('.grid').transition('fly right', 500)
        
        Router.go '/'

Template.user_received.helpers
    received_tags: ->
        Results.find(direction:'received')

    received_transfers: ->
        current_user = Meteor.users.findOne(username:Router.current().params.username)
        Docs.find {
            model:'transfer'
            target_id: current_user._id
            # target_id: target_user._id
        },
            sort:_timestamp:-1


