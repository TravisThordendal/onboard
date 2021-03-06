# As you may see,
# the Menu hierarchy and the URL/Ruby classes hierarchy are different!
#
# The former reflects the user's perspective, so CoovaChilli, hotspotlogin,
# and RADIUS server management will fall under the same category.
#
# The latter reflects a more technical perspective: everything under
# /network/ may change IP adresses, network interfaces, routing table,
# packet filtering etc...
#
# Instead, /services/ are various daemons/servers operating at the 
# application layer only.

class OnBoard

  MENU_ROOT.add_path('/network/access-control/radius', {
    #:href => '/services/radius', # nil
    :name => 'RADIUS server',
    :desc => 'Authentication, Authorization and Accounting',
    :n    => 0
  })

  MENU_ROOT.add_path('/network/access-control/radius/config', {
    :href => '/services/radius/config', 
    :name => 'Configuration',
    #:desc => '',
    :n    => 0
  })

  MENU_ROOT.add_path('/network/access-control/radius/accounting', {
    :href => '/services/radius/accounting', 
    :name => 'Accounting',
    :desc => 'Track users consumption of network resources',
    :n    => 10
  })

end

