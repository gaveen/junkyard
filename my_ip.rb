#!/usr/bin/env ruby
#
# my_ip - get the IP address of the NIC with the default gateway set
#

require 'socket'

class MyIP
  def show_address
    sock_no_reverse_lookup = Socket.do_not_reverse_lookup
    Socket.do_not_reverse_lookup = true

    UDPSocket.open do |s|
      s.connect('8.8.8.8', 1)
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = sock_no_reverse_lookup
  end
end

puts MyIP.new.show_address
