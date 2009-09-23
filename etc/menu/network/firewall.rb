class OnBoard
  # to the average user, the internet is IPv4, and the firewall too :-(
  MENU_ROOT.add_path('/network/firewall', {
    :href => '/network/firewall/ipv4',
    :name => 'Linux Firewall',
    :desc => 'Filter Internet traffic (IPv4)',
    :n    => -3
  })
end
