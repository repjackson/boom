if Meteor.isClient
    Router.route '/library/', (->
        @layout 'layout'
        @render 'library'
        ), name:'library'

    Template.library.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'alert'
    Template.library.onRendered ->
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

    Template.library.helpers
        my_library: ->
            Docs.find
                model:'alert'
                target_username: Meteor.user().username
        library: ->
            Docs.find
                model:'alert'



    Template.library.events
        'click .submit_message': ->
            message = $('.message').val()
            console.log message
            Docs.insert
                model:'library'
                message:message