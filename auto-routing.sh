#!/bin/bash

# If error occurs, exit
set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Domains from `domain` file
DOMAINS=($(cat "$SCRIPT_DIR/domain"))

# Table ID
# TABLE_ID=200

# VPN interface
VPN_IFACE="tun0"

# Flush routing table
# sudo ip route flush table $TABLE_ID

# Check if default route exists for VPN_IFACE and delete it if found
if ip route show default dev "$VPN_IFACE" &> /dev/null && ip link show "$VPN_IFACE" &> /dev/null; then
    echo "Deleting default route for $VPN_IFACE"
    sudo ip route del default dev "$VPN_IFACE" || true
fi

# resolve_domain: recursive resolve domain until get A or AAAA record
resolve_domain() {
    local DOMAIN=$1
    local IP_ADDRESSES=()
    
    # Recursive resolve CNAME records
    while true; do
        IPS=$(dig +short A $DOMAIN; dig +short AAAA $DOMAIN)
        
        if [[ -n "$IPS" ]]; then
            IP_ADDRESSES+=($IPS)
            break
        fi
        
        CNAME=$(dig +short CNAME $DOMAIN)
        if [[ -z "$CNAME" ]]; then
            break
        fi
        DOMAIN=$CNAME
    done
    
    echo "${IP_ADDRESSES[@]}"
}

is_valid_ip() {
    local IP=$1
    if [[ $IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] || [[ $IP =~ ^[0-9a-fA-F:]+$ ]]; then
        return 0
    else
        return 1
    fi
}

for DOMAIN in "${DOMAINS[@]}"; do
    IPS=$(resolve_domain $DOMAIN)
    
    for IP in $IPS; do
        if is_valid_ip $IP; then
            echo "Adding route for $IP"
            # Add IP address to routing table
            # sudo ip route add $IP dev $VPN_IFACE table $TABLE_ID || true
            sudo ip route add $IP dev $VPN_IFACE || true
            
            # Use mangle table to mark traffic
            # sudo iptables -t mangle -A PREROUTING -d $IP -j MARK --set-mark 1 || true
            # Flush: sudo iptables -t mangle -F PREROUTING; Show: sudo iptables -t mangle -L PREROUTING
            # sudo nft add rule ip mangle PREROUTING ip daddr $IP mark set 1
        fi
    done
done

# Config ip rule to match marked traffic
# sudo ip rule add fwmark 1 table $TABLE_ID

echo "Updated routing table for domains: ${DOMAINS[@]}"
