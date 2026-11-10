

#!/bin/bash

# Functie care verifica asocierea dintre hostname si IP
# folosind un server DNS primit ca parametru.

check_ip_host() {
    local hostname="$1"
    local ip="$2"
    local dns_server="$3"

    if [[ -z "$hostname" || -z "$ip" || -z "$dns_server" ]]; then
        echo "Parametri insuficienti!"
        return 1
    fi

    result=$(dig @"$dns_server" "$hostname" A +short)

    if echo "$result" | grep -Fxq "$ip"; then
        echo "Asociere valida: $hostname -> $ip"
        return 0
    else
        echo "Asociere invalida: $hostname -> $ip"
        return 1
    fi
}

# Serverul DNS este primit ca argument la rularea scriptului
DNS_SERVER="${1:?Utilizare: $0 SERVER_DNS}"

# Verifica toate intrarile din /etc/hosts
while IFS= read -r line; do
    line="${line%%#*}"
    [[ -z "${line//[[:space:]]/}" ]] && continue

    read -r ip hosts <<< "$line"

    for hostname in $hosts; do
        check_ip_host "$hostname" "$ip" "$DNS_SERVER"
    done

done < /etc/hosts
