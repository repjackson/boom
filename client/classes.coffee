if Meteor.isClient
    Router.route '/classes/', (->
        @layout 'layout'
        @render 'classes'
        ), name:'classes'

    Template.classes.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'alert'
    Template.classes.onRendered ->
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

    Template.classes.helpers
        my_classes: ->
            Docs.find
                model:'alert'
                target_username: Meteor.user().username
        classes: ->
            Docs.find
                model:'alert'



    Template.classes.events
        'click .submit_message': ->
            message = $('.message').val()
            console.log message
            Docs.insert
                model:'classes'
                message:message