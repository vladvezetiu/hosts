
#!/bin/bash

# Verificarea adreselor IP din /etc/hosts

while IFS= read -r line; do
    # Ignora liniile goale si comentariile
    line="${line%%#*}"
    [[ -z "${line//[[:space:]]/}" ]] && continue

    ip=$(echo "$line" | awk '{print $1}')

    # Verifica formatul IPv4
    if [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        valid=true

        IFS='.' read -ra octets <<< "$ip"

        for octet in "${octets[@]}"; do
            if (( octet < 0 || octet > 255 )); then
                valid=false
                break
            fi
        done

        if $valid; then
            echo "IP valid: $ip"
        else
            echo "IP invalid: $ip"
        fi
    else
        echo "IP invalid: $ip"
    fi

done < /etc/hosts
