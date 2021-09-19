if Meteor.isClient
    Router.route '/store/', (->
        @layout 'layout'
        @render 'store'
        ), name:'store'

    Template.store.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'alert'
    Template.store.onRendered ->
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

    Template.store.helpers
        my_store: ->
            Docs.find
                model:'alert'
                target_username: Meteor.user().username
        store: ->
            Docs.find
                model:'alert'



    Template.store.events
        'click .submit_message': ->
            message = $('.message').val()
            console.log message
            Docs.insert
                model:'store'
                message:message