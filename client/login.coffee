Router.route '/register', (->
    @layout 'layout'
    @render 'register'
    ), name:'register'
Router.route '/login', (->
    @layout 'layout'
    @render 'login'
    ), name:'login'



Template.register.onCreated ->
    Session.setDefault 'email', null
    Session.setDefault 'email_status', 'invalid'
    
Template.register.events
    'keyup .first_name': ->
        first_name = $('.first_name').val()
        Session.set 'first_name', first_name
    'keyup .last_name': ->
        last_name = $('.last_name').val()
        Session.set 'last_name', last_name
    'keyup .email_field': ->
        email = $('.email_field').val()
        Session.set 'email', email
        Meteor.call 'validate_email', email, (err,res)->
            if res is true
                Session.set 'email_status', 'valid'
            else
                Session.set 'email_status', 'invalid'

    'keyup .username': ->
        username = $('.username').val()
        Session.set 'username', username
        Meteor.call 'find_username', username, (err,res)->
            if res
                Session.set 'enter_mode', 'login'
            else
                Session.set 'enter_mode', 'register'

    'blur .username': ->
        username = $('.username').val()
        Session.set 'username', username
        Meteor.call 'find_username', username, (err,res)->
            if res
                Session.set 'enter_mode', 'login'
            else
                Session.set 'enter_mode', 'register'
    
    'blur .password': ->
        password = $('.password').val()
        Session.set 'password', password

    'click .register': (e,t)->
        username = $('.username').val()
        # email = $('.email_field').val()
        password = $('.password').val()
        # if Session.equals 'enter_mode', 'register'
        # if confirm "register #{username}?"
        # Meteor.call 'validate_email', email, (err,res)->
        # options = {
        #     username:username
        #     password:password
        # }
        options = {
            # email:email
            username:username
            password:password
            }
        Meteor.call 'create_user', options, (err,res)=>
            if err
                alert err
            else
                # unless username
                #     username = "#{Session.get('first_name').toLowerCase()}_#{Session.get('last_name').toLowerCase()}"
                Meteor.users.update res,
                    $addToSet: 
                        roles: 'customer'
                        # levels: 'customer'
                    $set:
                        # first_name: Session.get('first_name')
                        # last_name: Session.get('last_name')
                        # app:'nf'
                        username:username
                Router.go "/user/#{username}"
                # Meteor.loginWithPassword username, password, (err,res)=>
                #     if err
                #         alert err.reason
                #         # if err.error is 403
                #         #     Session.set 'message', "#{username} not found"
                #         #     Session.set 'enter_mode', 'register'
                #         #     Session.set 'username', "#{username}"
                #     else
                #         Router.go '/'
            # else
            #     Meteor.loginWithPassword username, password, (err,res)=>
            #         if err
            #             if err.error is 403
            #                 Session.set 'message', "#{username} not found"
            #                 Session.set 'enter_mode', 'register'
            #                 Session.set 'username', "#{username}"
            #         else
            #             Router.go '/'


Template.register.helpers
    can_register: ->
        # Session.get('first_name') and Session.get('last_name') and Session.get('email_status', 'valid') and Session.get('password').length>3
        Session.get('username') and Session.get('password').length>3

        # Session.get('username')

    # email: -> Session.get 'email'
    username: -> Session.get 'username'
    # first_name: -> Session.get 'first_name'
    # last_name: -> Session.get 'last_name'
    registering: -> Session.equals 'enter_mode', 'register'
    enter_class: -> if Meteor.loggingIn() then 'loading disabled' else ''
    # email_valid: ->
    #     Session.equals 'email_status', 'valid'
    # email_invalid: ->
    #     Session.equals 'email_status', 'invalid'

Template.login.onCreated ->
    Session.set 'username', null

Template.login.events
    'keyup .username': ->
        username = $('.username').val()
        Session.set 'username', username
        Meteor.call 'find_username', username, (err,res)->
            if res
                Session.set('enter_mode', 'login')

    'blur .username': ->
        username = $('.username').val()
        Session.set 'username', username
        Meteor.call 'find_username', username, (err,res)->
            if res
                Session.set('enter_mode', 'login')

    'click .enter': (e,t)->
        e.preventDefault()
        username = $('.username').val()
        password = $('.password').val()
        options = {
            username:username
            password:password
            }
        Meteor.loginWithPassword username, password, (err,res)=>
            if err
                $('body').toast({
                    message: err.reason
                })
            else
                $('body').toast({
                    message: 'login successful'
                    position: "bottom right"
                    icon:'checkmark'
                    class: 'success'
                })
                $(e.currentTarget).closest('.grid').transition('fly right', 1000)
                
                # Router.go "/"
                Router.go "/user/#{username}"

    'keyup .password, keyup .username': (e,t)->
        if e.which is 13
            e.preventDefault()
            username = $('.username').val()
            password = $('.password').val()
            if username and username.length > 0 and password and password.length > 0
                options = {
                    username:username
                    password:password
                    }
                Meteor.loginWithPassword username, password, (err,res)=>
                    if err
                        $('body').toast({
                            message: err.reason
                        })
                    else
                        # Router.go "/user/#{username}"
                        Router.go "/"


Template.login.helpers
    username: -> Session.get 'username'
    logging_in: -> Session.equals 'enter_mode', 'login'
    enter_class: ->
        if Session.get('username').length
            if Meteor.loggingIn() then 'loading disabled' else ''
        else
            'disabled'
    is_logging_in: -> Meteor.loggingIn()            