{ pkgs, ... }: {
  networking.wg-quick.interfaces = let
    server_ip = "216.151.180.8";
  in {
     # "wg0" is the network interface name. You can name the interface arbitrarily
    wg0 = {
    # Determines the IP/IPv6 address and subnet of the client's end of the tunnel interface
    # IP address of this machine in the *tunnel network*
      address = [ "192.168.250.1/24" ];
    # The port that WireGuard listens to - recommended that this be changed from default
    # To match firewall allowedUDPPorts (without this wg
    # uses random port numbers).
      listenPort = 51820;

      # Path to the private key file.
      privateKeyFile = "/home/nikos/github/ngeran/nx-cfg/hosts/common/optional/wireguard/ipvanish/nyc-c26.conf";

       # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      postUp = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 192.168.250.1/24 -o wlp11s0 -j MASQUERADE
      '';

      # Undo the above
      preDown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 192.168.250.1/24 -o wlp11s0 -j MASQUERADE
      '';


      peers = [{
        # [Peer 0] section -> PublicKey
        publicKey = "TziUEMu9VjazhEA7Y6zgqszPnCgr88rcjb+8SEhdDyM=";
        # [Peer 0] section -> AllowedIPs
        allowedIPs = [ "0.0.0.0/0" ];
        # [Peer 0] section -> Endpoint:port
        endpoint = "${server_ip}:51820";
        persistentKeepalive = 25;
      }];
    };
  };
}
