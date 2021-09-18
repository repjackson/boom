@Docs = new Meteor.Collection 'docs'
@Results = new Meteor.Collection 'results'

# Docs.before.insert (userId, doc)->




Router.configure
    layoutTemplate: 'layout'
    notFoundTemplate: 'not_found'
    loadingTemplate: 'splash'
    trackPageView: true



Router.route '/', -> @render 'home'
Router.route '*', -> @render 'home'


if Meteor.isClient
    # console.log $
    $.cloudinary.config
        cloud_name:"facet"

if Meteor.isServer
    Cloudinary.config
        cloud_name: 'facet'
        api_key: Meteor.settings.cloudinary_key
        api_secret: Meteor.settings.cloudinary_secret



# force_loggedin =  ()->
#     if !Meteor.userId()
#         @render 'login'
#     else
#         @next()

# Router.onBeforeAction(force_loggedin, {
#   # only: ['admin']
#   # except: ['register', 'forgot_password','reset_password','front','delta','doc_view','verify-email']
#   except: [
#     'login'
#     'register'
#     # 'users'
#     # 'services'
#     # 'service_view'
#     # 'products'
#     # 'product_view'
#     # 'rentals'
#     # 'rental_view'
#     # 'home'
#     # 'forgot_password'
#     # 'reset_password'
#     # 'user_orders'
#     # 'user_food'
#     # 'user_finance'
#     # 'user_dashboard'
#     # 'verify-email'
#     # 'food_view'
#   ]
# });


# Router.route('enroll', {
#     path: '/enroll-account/:token'
#     template: 'reset_password'
#     onBeforeAction: ()=>
#         Meteor.logout()
#         Session.set('_resetPasswordToken', this.params.token)
#         @subscribe('enrolledUser', this.params.token).wait()
# })


# Docs.after.insert (userId, doc)->
#     console.log doc.tags
#     return

# Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
#     doc.tag_count = doc.tags?.length
#     # Meteor.call 'generate_authored_cloud'
# ), fetchPrevious: true


Meteor.methods
    check_url: (str)->
        # console.log 'testing', str
        pattern = new RegExp('^(https?:\\/\\/)?'+ # protocol
        '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+ # domain name
        '((\\d{1,3}\\.){3}\\d{1,3}))'+ # OR ip (v4) address
        '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ # port and path
        '(\\?[;&a-z\\d%_.~+=-]*)?'+ # query string
        '(\\#[-a-z\\d_]*)?$','i') # fragment locator
        return !!pattern.test(str)
