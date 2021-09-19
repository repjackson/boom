if Meteor.isClient
    Template.groups.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'group'
    Template.groups.onRendered ->
        Meteor.setTimeout ->
            # $('.dropdown').dropdown(
            #     on:'click'
            # )
            $('.ui.dropdown').dropdown(
                clearable:true
                action: 'activate'
                onChange: (text,value,$selectedItem)->
                    )
        , 1000

    Template.groups.helpers
        my_groups: ->
            Docs.find
                model:'group'
                target_username: Meteor.user().username
        groups: ->
            Docs.find
                model:'group'



    Template.groups.events
        'click .add_group': ->
            new_id = 
                Docs.insert 
                    model:'group'
                    _timestamp:Date.now()
                    _author_id:Meteor.userId()
                    
            Router.go "/group/#{new_id}/edit"
            
            
            
        'click .submit_message': ->
            message = $('.message').val()
            console.log message
            Docs.insert
                model:'groups'
                message:message