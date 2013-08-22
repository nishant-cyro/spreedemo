# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  config.allow_ssl_in_production=false
  # Example:
  # Uncomment to override the default site name.
  # config.site_name = "Spree Demo Site"
    config.shipstation_username = "jainabhishek16@hotmail.com"
    config.shipstation_password = "vinsol123"
  # else
  #   config.shipstation_username = "jody"
  #   config.shipstation_password = "hull"
  # end

  config.shipstation_weight_units = "Grams" # Grams, Ounces or Pounds

  # choose which number to send shipstation, use :shipment or :order, default is :shipment
  config.shipstation_number = :shipment

  # if you prefer to send notifications via shipstation
  config.send_shipped_email = false

end

Spree.user_class = "Spree::User"
