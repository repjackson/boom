Template.registerHelper 'from_now', (input)-> moment(input).fromNow()
Template.registerHelper 'cal_time', (input)-> moment(input).calendar()

Template.registerHelper 'parent', () -> Template.parentData()
Template.registerHelper 'parent_doc', () ->
    Docs.findOne @parent_id
    # Template.parentData()
Template.registerHelper 'rental', () ->
    Docs.findOne @rental_id
    # Template.parentData()
Template.registerHelper 'group_modules', () ->
    console.log @module_slugs
    Docs.find 
        model:'group_module'
        slug:$in:@module_slugs
    
Template.registerHelper 'included_ingredients', () ->
    Docs.find
        model:'ingredient'
        _id: $in:@ingredient_ids
        
        
        
Template.registerHelper 'model_docs_helper', (model) ->
    # console.log model
    Docs.find 
        model:model
        # app:'bc'
        
        
        
        
Template.registerHelper 'can_access', () ->
    # console.log 'accessing ', @
    # if @price and @price is 0
    #     true
    # else 
    found_order = 
        Docs.findOne 
            model:'order'
            post_id:@_id
    if found_order
        true
    else 
        false
    
        
Template.registerHelper 'is_admin', () ->
    true
        



Template.registerHelper 'ingredient_products', () ->
    Docs.find   
        model:'product'
        ingredient_ids:$in:[@_id]
Template.registerHelper 'choice_docs', () ->
    Docs.find 
        model:'question_choice'
        parent_id:Router.current().params.doc_id


Template.registerHelper 'is_editing_this', (input)-> 
    Session.equals('editing_id', @_id)

Template.registerHelper 'lowered', (input)-> input.toLowerCase()

Template.registerHelper 'pathname_root', () ->
    window.location.pathname.split('/')[1]
Template.registerHelper 'current_route', () ->
    Router.current().location.get().path
    
Template.registerHelper '_target', () ->
    # console.log 'found target', found, Template.parentData()
    found
    
    
    
Template.registerHelper 'active_path', (metric) ->
    false

Template.registerHelper 'kve', (key,value) ->
    @["#{key}"] is value
Template.registerHelper 'display_mode', () -> Session.get('display_mode',true)
Template.registerHelper 'is_loading', () -> Session.get 'loading'
Template.registerHelper 'dev', () -> Meteor.isDevelopment
Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()
Template.registerHelper 'long_time', (input) -> moment(input).format("h:mm a")
Template.registerHelper 'long_date', (input) -> moment(input).format("dd, MMMM Do h:mm a")
Template.registerHelper 'short_date', (input) -> moment(input).format("dddd, MMMM Do")
Template.registerHelper 'med_date', (input) -> moment(input).format("MMM D 'YY")
Template.registerHelper 'medium_date', (input) -> moment(input).format("MMMM Do YYYY")
# Template.registerHelper 'medium_date', (input) -> moment(input).format("dddd, MMMM Do YYYY")
Template.registerHelper 'today', () -> moment(Date.now()).format("dddd, MMMM Do a")
Template.registerHelper 'fixed', (input) ->
    if input
        input.toFixed(2)
Template.registerHelper 'int', (input) -> 
    if input
        input.toFixed(0)
Template.registerHelper 'when', () -> moment(@_timestamp).fromNow()
Template.registerHelper 'cal_time', (input) -> moment(input).calendar()

Template.registerHelper 'current_doc', (input) -> 
    Docs.findOne Router.current().params.doc_id
    # moment(input).calendar()


Template.registerHelper 'logging_out', () -> Session.get 'logging_out'

Template.registerHelper 'current_month', () -> moment(Date.now()).format("MMMM")
Template.registerHelper 'current_day', () -> moment(Date.now()).format("DD")


Template.registerHelper 'current_delta', () -> Docs.findOne model:'delta'


Template.registerHelper 'session_is', (key, value)->
    Session.equals(key, value)

Template.registerHelper 'key_value_is', (key, value)->
    @["#{key}"] is value




Template.registerHelper 'is', (key, value)->
    key is value

Template.registerHelper 'parent_key_value_is', (key, value)->
    @["#{key}"] is value



# Template.registerHelper 'parent_template', () -> Template.parentData()
    # Session.get 'displaying_profile'

# Template.registerHelper 'checking_in_doc', () ->
#     Docs.findOne
#         model:'healthclub_session'
#         current:true
#      # Session.get('session_document')

# Template.registerHelper 'current_session_doc', () ->
#         Docs.findOne
#             model:'healthclub_session'
#             current:true



# Template.registerHelper 'checkin_guest_docs', () ->
#     Docs.findOne Router.current().params.doc_id
#     session_document = Docs.findOne Router.current().params.doc_id
#     Docs.find
#         _id:$in:session_document.guest_ids


Template.registerHelper 'is_text', () ->
    @field_type is 'text'

Template.registerHelper 'template_parent', () ->
    Template.parentData()

Template.registerHelper 'fields', () ->
    model = Docs.findOne
        model:'model'
        slug:Router.current().params.model_slug
    if model
        match = {}
        match.model = 'field'
        match.parent_id = model._id
        cur = Docs.find match,
            sort:rank:1
        cur
Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)


Template.registerHelper 'loading_class', () ->
    if Session.get 'loading' then 'disabled' else ''


# Template.registerHelper 'in_list', (key) ->

#             true
#         else
#                 true
#             else
#                 false
#     else 
#         false



            
Template.registerHelper 'view_template', -> "#{@field_type}_view"
Template.registerHelper 'edit_template', -> "#{@field_type}_edit"
Template.registerHelper 'is_model', -> @model is 'model'


# Template.body.events
#     'click .toggle_sidebar': -> $('.ui.sidebar').sidebar('toggle')

Template.registerHelper 'is_editing', () -> Session.equals 'editing_id', @_id
Template.registerHelper 'editing_doc', () ->
    Docs.findOne Session.get('editing_id')


Template.registerHelper 'in_role', (role)->


Template.registerHelper 'can_edit', () ->
    # if @_author_id is null 
    #     true

Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()


Template.registerHelper 'field_value', () ->
    parent = Template.parentData()
    parent5 = Template.parentData(5)
    parent6 = Template.parentData(6)


    if @direct
        parent = Template.parentData()
    else if parent5
        if parent5._id
            parent = Template.parentData(5)
    else if parent6
        if parent6._id
            parent = Template.parentData(6)
    if parent
        # console.log parent["#{@key}"]
        parent["#{@key}"]


Template.registerHelper 'sorted_field_values', () ->
    parent = Template.parentData()
    parent5 = Template.parentData(5)
    parent6 = Template.parentData(6)


    if @direct
        parent = Template.parentData()
    else if parent5._id
        parent = Template.parentData(5)
    else if parent6._id
        parent = Template.parentData(6)
    if parent
        _.sortBy parent["#{@key}"], 'number'


Template.registerHelper 'in_dev', () -> Meteor.isDevelopment

Template.registerHelper 'calculated_size', (metric) ->
    whole = parseInt(@["#{metric}"]*10)

    if whole is 2 then 'f2'
    else if whole is 3 then 'f3'
    else if whole is 4 then 'f4'
    else if whole is 5 then 'f5'
    else if whole is 6 then 'f6'
    else if whole is 7 then 'f7'
    else if whole is 8 then 'f8'
    else if whole is 9 then 'f9'
    else if whole is 10 then 'f10'



Template.registerHelper 'in_dev', () -> Meteor.isDevelopment


Template.registerHelper 'model_docs_helper', (model) ->
    Docs.find 
        model:model
        
Template.registerHelper 'connected', () -> 
    if Meteor.status().status is 'connected' then true else false

Template.registerHelper 'subs_ready', () -> 
    Template.instance().subscriptionsReady()

Template.registerHelper 'order_things',-> 
    Docs.find 
        model:'thing'
        order_id:@_id


Template.registerHelper 'soup_of_the_day',->
    Docs.findOne 
        model:'food'
        soup_of_the_day:true


Template.registerHelper 'specials',->
    Docs.findOne 
        model:'food'
        special:true
    
    
Template.registerHelper 'product_doc',-> 
    Docs.findOne
        model:'product'
        _id:@product_id

# Template.registerHelper 'order_count',-> Counts.get('order_count')
# Template.registerHelper 'product_count',-> Counts.get('product_count')
# Template.registerHelper 'ingredient_count',-> Counts.get('ingredient_count')
# Template.registerHelper 'subscription_count',-> Counts.get('subscription_count')
# Template.registerHelper 'source_count',-> Counts.get('source_count')
# Template.registerHelper 'giftcard_count',-> Counts.get('giftcard_count')
# Template.registerHelper 'staff_count',-> Counts.get('staff_count')
# Template.registerHelper 'customer_count',-> Counts.get('customer_count')


# Template.registerHelper 'cart_subtotal', () -> 
#     store_session_document = 
#         Docs.findOne 
#             model:'store_session'
#     if store_session_document.cart_product_ids
#         subtotal = 0
#         for product in Docs.find(_id:$in:store_session_document.cart_product_ids).fetch()
#             if product.price_usd
#                 subtotal += product.price_usd
#         subtotal
Template.registerHelper 'commafy', (num)-> if num then num.toLocaleString()

    
Template.registerHelper 'trunc', (input) ->
    if input
        input[0..300]
   
   
Template.registerHelper 'emotion_avg', (metric) -> Results.findOne(model:'emotion_avg')
Template.registerHelper 'skve', (key,val) -> 
    Session.equals(key,val)

Template.registerHelper 'calculated_size', (metric) ->
    # whole = parseInt(@["#{metric}"]*10)
    whole = parseInt(metric*10)
    switch whole
        when 0 then 'f5'
        when 1 then 'f6'
        when 2 then 'f7'
        when 3 then 'f8'
        when 4 then 'f9'
        when 5 then 'f10'
        when 6 then 'f11'
        when 7 then 'f12'
        when 8 then 'f13'
        when 9 then 'f14'
        when 10 then 'f15'
        
        
        
        
Template.registerHelper 'abs_percent', (num) -> 
    # console.l/og Math.abs(num*100)
    parseInt(Math.abs(num*100))