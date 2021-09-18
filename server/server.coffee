Cloudinary.config
    cloud_name: 'facet'
    api_key: Meteor.settings.private.cloudinary_key
    api_secret: Meteor.settings.private.cloudinary_secret

Docs.allow
    # insert: (userId, doc) -> doc._author_id is userId
    insert: (userId, doc) -> true
    update: (userId, doc) ->
        true
        # if userId then true
        # if doc.model in ['calculator_doc','simulated_rental_item','healthclub_session']
        #     true
        # else if Meteor.user() and Meteor.user().roles and 'admin' in Meteor.user().roles
        #     true
        # else
        #     doc._author_id is userId
    # update: (userId, doc) -> doc._author_id is userId or 'admin' in Meteor.user().roles
    remove: (userId, doc) -> 
        true
        # doc._author_id is userId or 'admin' in Meteor.user().roles
# Meteor.users.allow
#     # insert: (userId, doc) -> doc._author_id is userId
#     insert: (userId, doc) -> true
#     update: (userId, doc) ->
#         true
#         # if userId then true
#         # if doc.model in ['calculator_doc','simulated_rental_item','healthclub_session']
#         #     true
#         # else if Meteor.user() and Meteor.user().roles and 'admin' in Meteor.user().roles
#         #     true
#         # else
#         #     doc._author_id is userId
#     # update: (userId, doc) -> doc._author_id is userId or 'admin' in Meteor.user().roles
#     remove: (userId, doc) -> 
#         userId
#         # doc._author_id is userId or 'admin' in Meteor.user().roles





# Meteor.publish 'wiki_docs', (
#     picked_tags=[]
#     )->
#         Docs.find 
#             model:'wikipedia'
#             title:$in:picked_tags
# Meteor.publish 'ref_doc', (tag)->
#     match = {app:'bc'}
#     match.model = 'post'
#     match.title = tag.title
#     found = 
#         Docs.findOne match
#     if found
#         Docs.find match
#     else 
#         match.title = null
#         match.tags = $in:[tag.title]
#         Docs.find match,
#             sort:views:1
            
# Meteor.publish 'flat_ref_doc', (title)->
#     # console.log title
#     if title
#         Docs.find({
#             model:'post'
#             app:'bc'
#             title:title
#         }, 
#             fields:
#                 title:1
#                 model:1
#                 app:1
#                 # metadata:1
#                 image_id:1
#                 image_url:1
#             limit:1
#         )
#     else 
#         Docs.find {
#             model:'post'
#             tags:$in:[title]
#             app:'bc'
#         },
#             sort:
#                 views:1
#             fields:
#                 title:1
#                 model:1
#                 app:1
#                 # metadata:1
#                 image_id:1
#                 image_url:1
#             limit:1
            
            
# Meteor.publish 'post_docs', (
#     picked_tags=[]
#     title_filter
#     )->

#     self = @
#     # match = {}
#     match = {app:'bc'}
#     match.model = 'post'
#     # match.group_id = Meteor.user().current_group_id
#     if title_filter and title_filter.length > 1
#         match.title = {$regex:title_filter, $options:'i'}
    
#     # if picked_tags.length > 0 then match.tags = $all:picked_tags 
#     if picked_tags.length > 0 then match.tags = $all:picked_tags 
#     Docs.find match, 
#         limit:10
#         fields:
#             title:1
#             model:1
#             tags:1
#             app:1
#             image_id:1
#             image_url:1
#             body:1
#         sort:
#             views:-1
            
            


# Meteor.publish 'transfers', (
#     username
#     direction
#     picked_tags
#     picked_authors
#     picked_targets
#     picked_timestamp_tags
#     picked_location_tags
#     filter=null
#     sort_key='_timestamp'
#     sort_direction=-1
#     )->
        
#     match = {model:'transfer'}
    
#     if filter is 'now'
#         now = Date.now()
#         gap = 60*60*1000
#         hour_ago = now-gap
#         match._timestamp = $gte:hour_ago
#     else if filter is 'today'
#         now = Date.now()
#         gap = 60*60*1000*24
#         day_ago = now-gap
#         match._timestamp = $gte:day_ago
    
#     if picked_tags.length > 0 then match.tags = $all:picked_tags 
#     if picked_location_tags.length > 0 then match.location_tags = $all:picked_location_tags 
#     if picked_timestamp_tags.length > 0 then match._timestamp_tags = $all:picked_timestamp_tags 
#     if picked_authors.length > 0 then match._author_username = $all:picked_authors 
#     if picked_targets.length > 0 then match.target_username = $all:picked_targets 
    
#     if username
#         if direction is 'sent'
#             match._author_id = user._id
#         if direction is 'received'
#             match.target_id = user._id

    
#     Docs.find match,
#         limit:20  
#         sort:
#             "#{sort_key}":sort_direction
        


            
    
Meteor.publish 'tags', (
    query=''
    picked_tags=[]
    # picked_authors
    # picked_targets
    # picked_timestamp_tags
    # picked_location_tags
    # # title_filter=null
    # filter=null
    # sort_key='_timestamp'
    # sort_direction=-1
    )->
    self = @
    
    
    # match = {}
    match = {}
    # match.model = 'transfer'
    
    # if filter is 'now'
    #     now = Date.now()
    #     gap = 60*60*1000
    #     hour_ago = now-gap
    #     match._timestamp = $gte:hour_ago
    # else if filter is 'today'
    #     now = Date.now()
    #     gap = 60*60*24*1000
    #     day_ago = now-gap
    #     match._timestamp = $gte:day_ago

    
    if query.length > 0
        match.title = {$regex:query, $options:'i'}

    
    if picked_tags.length > 0 then match.tags = $all:picked_tags 

    # if picked_location_tags.length > 0 then match.location_tags = $all:picked_location_tags 
    # if picked_timestamp_tags.length > 0 then match._timestamp_tags = $all:picked_timestamp_tags 
    # if picked_authors.length > 0 then match._author_username = $all:picked_authors 
    # if picked_targets.length > 0 then match.target_username = $all:picked_targets 



    # if title_filter and title_filter.length > 1
    #     match.title = {$regex:title_filter, $options:'i'}

    result_count = Docs.find(match).count()

    tag_cloud = Docs.aggregate [
        { $match: match }
        { $project: "tags": 1 }
        { $unwind: "$tags" }
        { $group: _id: "$tags", count: $sum: 1 }
        { $match: _id: $nin: picked_tags }
        { $match: count: $lt: result_count }
        # { $match: _id: {$regex:"#{product_query}", $options: 'i'} }
        { $sort: count: -1, _id: 1 }
        { $limit: 20 }
        { $project: _id: 0, title: '$_id', count: 1 }
    ], {
        allowDiskUse: true
    }
    
    tag_cloud.forEach (tag, i) =>
        self.added 'results', Random.id(),
            title: tag.title
            count: tag.count
            model:'tag'
            # index: i
            
            
    # location_cloud = Docs.aggregate [
    #     { $match: match }
    #     { $project: "location_tags": 1 }
    #     { $unwind: "$location_tags" }
    #     { $group: _id: "$location_tags", count: $sum: 1 }
    #     { $match: _id: $nin: picked_location_tags }
    #     { $match: count: $lt: result_count }
    #     # { $match: _id: {$regex:"#{product_query}", $options: 'i'} }
    #     { $sort: count: -1, _id: 1 }
    #     { $limit: 10 }
    #     { $project: _id: 0, title: '$_id', count: 1 }
    # ], {
    #     allowDiskUse: true
    # }
    
    # location_cloud.forEach (tag, i) =>
    #     self.added 'results', Random.id(),
    #         title: tag.title
    #         count: tag.count
    #         model:'location_tag'
    #         # index: i
            
    # target_cloud = Docs.aggregate [
    #     { $match: match }
    #     { $project: "target_username": 1 }
    #     { $unwind: "$target_username" }
    #     { $group: _id: "$target_username", count: $sum: 1 }
    #     { $match: _id: $nin: picked_targets }
    #     { $match: count: $lt: result_count }
    #     # { $match: _id: {$regex:"#{product_query}", $options: 'i'} }
    #     { $sort: count: -1, _id: 1 }
    #     { $limit: 10 }
    #     { $project: _id: 0, title: '$_id', count: 1 }
    # ], {
    #     allowDiskUse: true
    # }
    
    # target_cloud.forEach (tag, i) =>
    #     self.added 'results', Random.id(),
    #         title: tag.title
    #         count: tag.count
    #         model:'target_tag'
    #         # index: i
            
            
    # author_cloud = Docs.aggregate [
    #     { $match: match }
    #     { $project: "_author_username": 1 }
    #     { $unwind: "$_author_username" }
    #     { $group: _id: "$_author_username", count: $sum: 1 }
    #     { $match: _id: $nin: picked_authors }
    #     { $match: count: $lt: result_count }
    #     # { $match: _id: {$regex:"#{product_query}", $options: 'i'} }
    #     { $sort: count: -1, _id: 1 }
    #     { $limit: 10 }
    #     { $project: _id: 0, title: '$_id', count: 1 }
    # ], {
    #     allowDiskUse: true
    # }
    
    # author_cloud.forEach (tag, i) =>
    #     self.added 'results', Random.id(),
    #         title: tag.title
    #         count: tag.count
    #         model:'author_tag'
    #         # index: i
            
    # from_cloud = Docs.aggregate [
    #     { $match: match }
    #     { $project: "_author_username": 1 }
    #     { $unwind: "$_author_username" }
    #     { $group: _id: "$_author_username", count: $sum: 1 }
    #     { $match: _id: $nin: picked_authors }
    #     { $match: count: $lt: result_count }
    #     # { $match: _id: {$regex:"#{product_query}", $options: 'i'} }
    #     { $sort: count: -1, _id: 1 }
    #     { $limit: 10 }
    #     { $project: _id: 0, title: '$_id', count: 1 }
    # ], {
    #     allowDiskUse: true
    # }
    
    # tag_cloud.forEach (tag, i) =>
    #     self.added 'results', Random.id(),
    #         title: tag.title
    #         count: tag.count
    #         model:'from'
    #         # index: i

    self.ready()
    
        
        
        
        
        
# Meteor.publish 'user_transfers', (username)->
#     Docs.find {
#         model:'transfer'
#         _author_id: user._id
#     }, 
#         limit:20
#         sort:_timestamp:-1
        
        
Meteor.publish 'doc_comments', (doc_id)->
    # console.log 'hi pubbing'
    Docs.find   
        model:'comment'
        parent_id:doc_id  
        
        
Meteor.publish 'doc_by_id', (doc_id)->
    Docs.find doc_id
# Meteor.publish 'target_from_transfer_id', (transfer_id)->
#     transfer = 
#         Docs.findOne transfer_id
    
Meteor.publish 'related_wiki_article', (doc_id)->
    post = Docs.findOne doc_id
    Docs.find 
        model:'wikipedia'
        title:post.title
Meteor.publish 'doc', (doc_id)->
    Docs.find doc_id
    

Meteor.publish 'query', (
    query=''
    picked_tags=[]
    )->
        
    match = {}
    if picked_tags.length > 0
        match.tags = $all:picked_tags
    if query.length > 0
        match.title = {$regex:query, $options:'i'}
    Docs.find match, { limit:20, sort:points:-1}
    
# Meteor.publish 'comments', (doc_id)->
#     # doc = Docs.findOne doc_id
#     Docs.find 
#         model:'comment'
#         parent_id:doc_id
    
    
# Meteor.publish 'me', ()->

# Meteor.publish 'user_from_username', (username)->


# Meteor.publish 'ref_doc', (tag)->
#     match = {}
#     match.model = 'transfer'
#     match.title = tag.title
#     found = 
#         Docs.findOne match
#     if found
#         Docs.find match
#     else 
#         match.title = null
#         match.tags = $in:[tag.title]
#         Docs.find match,
#             sort:views:1
            
# Meteor.publish 'flat_ref_doc', (title)->
#     # if title
#     Docs.find({
#         model:'transfer'
#         tags:$in:[title]
#         # title:title
#     }, 
#         fields:
#             title:1
#             model:1
#             # metadata:1
#             image_id:1
#             image_url:1
#         limit:1
#     )
#     # else 
#     #     Docs.find {
#     #         model:'transfer'
#     #         tags:$in:[title]
#     #     },
#     #         sort:views:1
#     #         limit:1
