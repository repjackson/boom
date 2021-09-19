if Meteor.isClient
    Router.route '/decks', (->
        @render 'decks'
        ), name:'decks
        '

    Template.library.onCreated ->
        Session.setDefault('deck_sort','views')
        @autorun -> Meteor.subscribe 'deck',
            Session.get('deck_title_filter')
            Session.get('deck_view_filter')
            Session.get('deck_sort')
            Session.get('deck_sort_direction')
            
        # @autorun -> Meteor.subscribe 'model_docs', 'deck', 20
        # @autorun -> Meteor.subscribe 'model_docs', 'thing', 100

    Template.library.helpers
        deck_docs: ->
            match = {model:'deck'}
            # if Session.get('deck_status_filter')
            #     match.status = Session.get('deck_status_filter')
            # if Session.get('deck_delivery_filter')
            #     match.delivery_method = Session.get('deck_sort_filter')
            # if Session.get('deck_sort_filter')
            #     match.delivery_method = Session.get('order_sort_filter')
            Docs.find match,
                sort: 
                    "#{Session.get('deck_sort')}":Session.get('deck_sort_direction')

    Template.library.events
        'click .add_deck': ->
            console.log 'hi'
            new_id = 
                Docs.insert 
                    model:'deck'
                    _author_id:Meteor.userId()
                    _author_username:Meteor.user().username
                    _timestamp:Date.now()

            Router.go "/deck/#{new_id}/edit"
            

    Router.route '/deck/:doc_id', (->
        @layout 'layout'
        @render 'deck_view'
        ), name:'deck_view'

    Template.deck_view.onRendered ->
        Meteor.call 'log_view', Router.current().params.doc_id, ->
    Template.deck_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id, ->
    Template.deck_view.events
        'click .mark_arrived': ->
            # if confirm 'mark arrived?'
            Docs.update Router.current().params.doc_id, 
                $set:
                    arrived: true
                    arrived_timestamp: Date.now()
                    status: 'arrived' 
        
        'click .mark_delivering': ->
            # if confirm 'mark delivering?'
            Docs.update Router.current().params.doc_id, 
                $set:
                    delivering: true
                    delivering_timestamp: Date.now()
                    status: 'delivering' 
      
        'click .mark_delivered': ->
            # if confirm 'mark delivered?'
            Docs.update Router.current().params.doc_id, 
                $set:
                    delivered: true
                    delivered_timestamp: Date.now()
                    status: 'delivered' 
      
        'click .delete_deck': ->
            thing_count = Docs.find(model:'thing').count()
            if confirm "delete? #{thing_count} things still"
                Docs.remove @_id
                Router.go "/deck"
    
        'click .mark_ready': ->
            if confirm 'mark ready?'
                Docs.insert 
                    model:'deck_event'
                    deck_id: Router.current().params.doc_id
                    deck_status:'ready'

        'click .add_review': ->
            Docs.insert 
                model:'deck_review'
                deck_id: Router.current().params.doc_id
                
                
        'click .review_positive': ->
            Docs.update @_id,
                $set:
                    rating:1
        'click .review_negative': ->
            Docs.update @_id,
                $set:
                    rating:-1

        'click .order_deck': ->
            deck = Docs.findOne Router.current().params.doc_id
            new_order_id = 
                Docs.insert 
                    model:'order'
                    parent_id:deck._id
                    deck_id:deck._id
                    purchase_amount:deck.price_dollars*100
                    deck_title:deck.title
            Router.go "/order/#{new_order_id}/edit"


    Template.deck_view.helpers
        deck_review: ->
            Docs.findOne 
                model:'deck_review'
                deck_id:Router.current().params.doc_id
    
        can_deck: ->
            # if StripeCheckout
            unless @_author_id is Meteor.userId()
                deck_count =
                    Docs.find(
                        model:'deck'
                        deck_id:@_id
                    ).count()
                if deck_count is @servings_amount
                    false
                else
                    true
            # else
            #     false




if Meteor.isServer
    Meteor.publish 'deck', (
        title_filter
        section
        sort_key
        sort_direction=-1
        )->
        # deck = Docs.findOne deck_id
        match = {model:'deck'}
        # match.app = 'bc'
        if section 
            match.section = section
        if title_filter and title_filter.length > 1
            match.title = {$regex:title_filter, $options:'i'}

        Docs.find match,
            sort:"#{sort_key}":sort_direction
            limit:42
        
    Meteor.publish 'review_from_deck_id', (deck_id)->
        # deck = Docs.findOne deck_id
        # match = {model:'deck'}
        Docs.find 
            model:'deck_review'
            shop_id:shop_id
        
    Meteor.publish 'deck_by_shop_id', (shop_id)->
        shop = Docs.findOne shop_id
        Docs.find
            _id: shop.deck_id
    Meteor.publish 'shop_things', (shop_id)->
        shop = Docs.findOne shop_id
        Docs.find
            model:'thing'
            shop_id: shop_id

    # Meteor.methods
        # shop_shop: (shop_id)->
        #     shop = Docs.findOne shop_id
        #     Docs.insert
        #         model:'shop'
        #         shop_id: shop._id
        #         shop_price: shop.price_per_serving
        #         buyer_id: Meteor.userId()
        #     Meteor.users.update Meteor.userId(),
        #         $inc:credit:-shop.price_per_serving
        #     Meteor.users.update shop._author_id,
        #         $inc:credit:shop.price_per_serving
        #     Meteor.call 'calc_shop_data', shop_id, ->



# if Meteor.isClient
#     Template.user_shop_item.onCreated ->
#         # @autorun => Meteor.subscribe 'deck_from_shop_id', @data._id
#     Template.user_shop.onCreated ->
#         @autorun => Meteor.subscribe 'user_shop', Router.current().params.username
#         @autorun => Meteor.subscribe 'model_docs', 'deck'
#     Template.user_shop.helpers
#         shop: ->
#             current_user = Meteor.users.findOne username:Router.current().params.username
#             Docs.find {
#                 model:'shop'
#             }, sort:_timestamp:-1

if Meteor.isServer
    # Meteor.publish 'user_shop', (username)->
    #     # user = Meteor.users.findOne username:username
    #     Docs.find 
    #         model:'shop'
    #         _author_username:username
            
    
    Meteor.publish 'user_shop', (username)->
        user = Meteor.users.findOne username:username
        Docs.find {
            model:'shop'
            _author_id: user._id
        }, 
            limit:42
            sort:_timestamp:-1
            
    Meteor.publish 'deck_from_shop_id', (shop_id)->
        shop = Docs.findOne shop_id
        Docs.find
            model:'deck'
            _id: shop.deck_id


if Meteor.isClient
    Router.route '/deck/:doc_id/edit', (->
        @layout 'layout'
        @render 'deck_edit'
        ), name:'deck_edit'



    Template.deck_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc_by_id', Router.current().params.doc_id
        # @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
        # @autorun => Meteor.subscribe 'model_docs', 'source'

    Template.deck_edit.onRendered ->
        # Meteor.setTimeout ->
        #     today = new Date()
        #     $('#availability')
        #         .calendar({
        #             inline:true
        #             # minDate: new Date(today.getFullYear(), today.getMonth(), today.getDate() - 5),
        #             # maxDate: new Date(today.getFullYear(), today.getMonth(), today.getDate() + 5)
        #         })
        # , 2000

    Template.deck_edit.helpers
        balance_after_purchase: ->
            Meteor.user().points - @purchase_amount
        percent_difference: ->
            balance_after_purchase = 
                Meteor.user().points - @purchase_amount
            # difference
            @purchase_amount/Meteor.user().points
    Template.deck_edit.events
        'click .complete_shop': (e,t)->
            console.log @
            Session.set('shoping',true)
            if @purchase_amount
                if Meteor.user().points and @purchase_amount < Meteor.user().points
                    Meteor.call 'complete_shop', @_id, =>
                        Router.go "/deck/#{@deck_id}"
                        Session.set('shoping',false)
                else 
                    alert "not enough points"
                    Router.go "/user/#{Meteor.user().username}/points"
                    Session.set('shoping',false)
            else 
                alert 'no purchase amount'
            
            
        'click .delete_shop': ->
            if confirm "delete #{@title}?"
                Docs.remove @_id
                Router.go "/shop"


    # Template.linked_deck.onCreated ->
    #     # console.log @data
    #     @autorun => Meteor.subscribe 'doc_by_id', @data.deck_id, ->

    # Template.linked_deck.helpers
    #     linked_deck_doc: ->
    #         console.log @
    #         Docs.findOne @deck_id
            
            
if Meteor.isServer
    Meteor.methods  
        complete_shop: (shop_id)->
            console.log 'completing shop', shop_id
            current_shop = Docs.findOne shop_id            
            Docs.update shop_id, 
                $set:
                    status:'purchased'
                    purchased:true
                    purchase_timestamp: Date.now()
            console.log 'marked complete'
            Meteor.call 'calc_user_points', @_author_id, ->