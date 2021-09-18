Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)

Template.registerHelper 'fixed', (input) ->
    if input
        input.toFixed(2)
        
        
Template.registerHelper 'is_loading', () ->
    Session.get('loading')

Template.home.onCreated ->
    @autorun -> Meteor.subscribe 'query', 
        Session.get('query')
        picked_tags.array()
        , ->
    @autorun -> Meteor.subscribe 'tags', 
        Session.get('query')
        picked_tags.array()
        , ->

Template.home.helpers
    one_doc: ->
        count = Docs.find({}).count()
        count is 1
        
    card_class: ->
        count = Docs.find({}).count()
        # console.log 'count', count
        if count is 1
            'ui fluid card'
        else 
            'ui card'
    query: -> Session.get('query')
    results: ->
        match = {}
        # if Session.get('query').length > 0
        #     match.title = {$regex:Session.get('query'), $options:'i'}
        Docs.find match
            
    result_tags: ->
        Results.find {} 
            # title: {$regex:Session.get('query'), $options:'i'}

    picked_tags: -> picked_tags.array()

Template.home.events
    'click .clear_query': ->
        # console.log @
        Session.set('query', null)
    
    # 'click .page_up': (e,t)->
    #     delta = Docs.findOne model:'delta'
    #     Docs.update delta._id,
    #         $inc: current_page:1
    #     Session.set 'is_calculating', true
    #     Meteor.call 'fo', (err,res)->
    #         if err then console.log err
    #         else
    #             Session.set 'is_calculating', false
    #
    # 'click .page_down': (e,t)->
    #     delta = Docs.findOne model:'delta'
    #     Docs.update delta._id,
    #         $inc: current_page:-1
    #     Session.set 'is_calculating', true
    #     Meteor.call 'fo', (err,res)->
    #         if err then console.log err
    #         else
    #             Session.set 'is_calculating', false

    # 'click .select_tag': -> picked_tags.push @name
    # 'click .unselect_tag': -> picked_tags.remove @valueOf()
    # 'click #clear_tags': -> picked_tags.clear()
    #
    # 'keyup #search': (e)->
        # switch e.which
        #     when 13
        #         if e.target.value is 'clear'
        #             picked_tags.clear()
        #             $('#search').val('')
        #         else
        #             picked_tags.push e.target.value.toLowerCase().trim()
        #             $('#search').val('')
        #     when 8
        #         if e.target.value is ''
        #             picked_tags.pop()
    'keyup #search': _.throttle((e,t)->
        query = $('#search').val()
        Session.set('query', query)
        # delta = Docs.findOne model:'delta'
        # Docs.update delta._id,
        #     $set:search_query:query
        # Session.set 'loading', true
        # Meteor.call 'fum', delta._id, ->
        #     Session.set 'loading', false

        # console.log Session.get('current_query')
        if e.which is 13
            search = $('#search').val().trim().toLowerCase()
            if search.length > 0
                picked_tags.push search
                console.log 'search', search
                # Meteor.call 'log_term', search, ->
                $('#search').val('')
                Session.set('current_query', null)
                # # $('#search').val('').blur()
                # # $( "p" ).blur();
                # Meteor.setTimeout ->
                #     Session.set('dummy', !Session.get('dummy'))
                # , 10000
    , 1000)






# Template.facet.onCreated ->
#     @viewing_facet = new ReactiveVar true

# Template.facet.onRendered ->
#     Meteor.setTimeout ->
#         $('.accordion').accordion()
#     , 1500

# Template.facet.events
#     # 'click .ui.accordion': ->
#     #     $('.accordion').accordion()
#     'click .toggle_view_facet': (e,t)->
#         t.viewing_facet.set !t.viewing_facet.get()

#     'click .toggle_selection': ->
#         delta = Docs.findOne model:'delta'
#         facet = Template.currentData()

#         Session.set 'loading', true
#         if facet.filters and @name in facet.filters
#             Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
#                 Session.set 'loading', false
#         else
#             Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
#                 Session.set 'loading', false

#     'keyup .add_filter': (e,t)->
#         # console.log @
#         if e.which is 13
#             delta = Docs.findOne model:'delta'
#             facet = Template.currentData()
#             if @field_type is 'number'
#                 filter = parseInt t.$('.add_filter').val()
#             else
#                 filter = t.$('.add_filter').val()
#             Session.set 'loading', true
#             Meteor.call 'add_facet_filter', delta._id, facet.key, filter, ->
#                 Session.set 'loading', false
#             t.$('.add_filter').val('')




# Template.facet.helpers
#     viewing_results: ->
#         Template.instance().viewing_facet.get()
#     filtering_res: ->
#         delta = Docs.findOne model:'delta'
#         filtering_res = []
#         if @key is '_keys'
#             @res
#         else
#             for filter in @res
#                 if filter.count < delta.total
#                     filtering_res.push filter
#                 else if filter.name in @filters
#                     filtering_res.push filter
#             filtering_res
#     toggle_value_class: ->
#         facet = Template.parentData()
#         delta = Docs.findOne model:'delta'
#         if Session.equals 'loading', true
#              'disabled basic'
#         else if facet.filters.length > 0 and @name in facet.filters
#             'active'
#         else ''

@picked_emotions = new ReactiveArray []
@picked_tags = new ReactiveArray []


Template.print_this.events
    'click .print_this': ->
        console.log @
        
        
Template.home.events
    'click .pick_tag': ->
        picked_tags.push @title
    'click .unpick_tag': ->
        picked_tags.remove @valueOf()
        
Template.home.helpers
    picked_tags: ->
        picked_tags.array()
    ten_tags: ->
        @tags[..10]
        
        

Template.remove_button.events
    'click .remove_this': ->
        if confirm "delete #{@title}?"
            console.log @
            Docs.remove @_id


$.cloudinary.config
    cloud_name:"facet"

        