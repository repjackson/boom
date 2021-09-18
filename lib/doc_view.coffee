if Meteor.isClient
    Template.comments.onRendered ->
        # Meteor.setTimeout ->
        #     $('.accordion').accordion()
        # , 1000
    Template.comments.onCreated ->
        console.log 'subbing for comments'
        # parent = Docs.findOne Template.parentData()._id
        # parent = Docs.findOne @_id
        @autorun => Meteor.subscribe 'doc_comments', @_id, ->
        # if parent
    Template.comments.helpers
        doc_comments: ->
            parent = Docs.findOne @_id
            # parent = Docs.findOne Template.parentData()._id
            Docs.find
                parent_id:@_id
                model:'comment'
    Template.comments.events
        'keyup .add_comment': (e,t)->
            if e.which is 13
                # parent = Docs.findOne Template.parentData()._id
                parent = Docs.findOne @_id
                comment = t.$('.add_comment').val()
                Docs.insert
                    parent_id: @_id
                    model:'comment'
                    _timestamp:Date.now()
                    # parent_model:parent.model
                    body:comment
                t.$('.add_comment').val('')
    
        'click .remove_comment': ->
            if confirm 'Confirm remove comment'
                Docs.remove @_id

