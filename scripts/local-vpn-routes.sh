#!/bin/bash

set -o nounset
set -o errexit

script_name="$(basename "${0}")"
script_dir="$(dirname "${0}")"
required_params=1

# Script settings
cache_dir="/tmp/vpn-routing"
file_raw="${cache_dir}/russian_subnets_list_raw.txt"
file_custom_routes="${cache_dir}/old_custom_routes.txt"
file_user="${HOME}/.config/local-routing-rules.txt"
file_for_calc="${cache_dir}/russian_subnets_list_raw_for_calc.txt"
file_processed="${cache_dir}/russian_subnets_list_processed.txt"

function ProgressBar() {
  local _msg="${1}"
  local _cur="${2}"
  local _total="${3}"

  (( _progress = ( "${_cur}" * 100 / "${_total}" ) ))
  (( _done = ( "${_progress}" * 4 ) / 10 ))
  (( _left = 40 - "${_done}" ))

  _fill=$(printf "%${_done}s")
  _empty=$(printf "%${_left}s")
  printf "\r${_msg} (${_cur}/${_total}): [${_fill// /#}${_empty// /-}] ${_progress}%%"
}

function wait_network() 
{
    while ! route -q get default 2>/dev/null; do 
        sleep 1
    done
}

function wait_routing()
{
    local _test_route="10.18.81.01/32"
    local _gw="10.110.011.01"

    # First ensure the route is not in the table
    route delete "${_test_route}" >/dev/null 2>/dev/null || true

    while route add -net "${_test_route}" "${_gw}" 2>&1 | 
            grep -q 'Network is unreachable'; do
        sleep 1
    done

    route delete "${_test_route}" >/dev/null 2>/dev/null || true
}

function reference ()
{
        cat <<EndOfReference

        ${script_name} requires ${required_params} parameters
            ${script_name} interface_name

        Say, ${script_name} en1
        To get interface name you use for internet access, use 'networksetup -listnetworkserviceorder'

EndOfReference
}

if [ "$#" -ne "${required_params}" ]; then
        reference
        exit 64
fi

# Checking the environment
cd "${script_dir}"
mkdir -p "${cache_dir}"

if [ "$( id -u )" -ne 0 ]; then
    echo "Script requires super-user privileges. Run with sudo."
    exit 1
fi

# Call parameters
interface="${1}"

default_gateway=$( 
    netstat -nr -f inet | 
        awk '/default/ { print $2 }'
)

# Get addresses RU segment
echo "Download RU subnets..."
curl \
    --progress-bar \
    "https://stat.ripe.net/data/country-resource-list/data.json?resource=ru" | 
    jq -r ".data.resources.ipv4[]" > "${file_raw}"

# Flush route table
echo "Flush route table (down interface '${interface}')..."
ifconfig "${interface}" down

echo "Getting the list of old custom routes..."
netstat -nr -f inet | awk -v "iface=${interface}" '$4 == iface{print $1}' > "${file_custom_routes}"

echo "Bring interface '${interface}' back..."
ifconfig "${interface}" up

echo "Deaggregate subnets..."
grep "-" "${file_raw}" > "${file_for_calc}"
grep -v "-" "${file_raw}" > "${file_processed}"

while read -r line; do
    ipcalc "${line}" |
        grep -v "deaggregate" >> "${file_processed}"
done < "${file_for_calc}"

if [ -f "${file_user}"  ]; then 
    echo "Add user subnets..."; 
    grep -v "#" "${file_user}" >> "${file_processed}"
fi

routes_count_all=$( wc -l <"${file_custom_routes}" | awk '{print $1}' )
routes_count_current=0
echo "Old routes count: ${routes_count_all}"
while read -r route; do
    route -n delete "${route}" >/dev/null
    
    (( routes_count_current += 1 ))
    ProgressBar "Removing old routes" "${routes_count_current}" "${routes_count_all}"

done <"${file_custom_routes}"
echo ""

echo "Waiting for network connection to appear to get 'route' control working"
wait_network
wait_routing

routes_count_all=$( wc -l <"${file_processed}" | awk '{print $1}' )
routes_count_current=0
while read -r line; do
    route -n add -net "${line}" "${default_gateway}" >/dev/null

    (( routes_count_current += 1 ))
    ProgressBar "Adding new routes" "${routes_count_current}" "${routes_count_all}"

done <"${file_processed}"
echo ""

echo "Removing temp files..."
rm -r "${cache_dir}"

routes_count=$( netstat -nr -f inet | wc -l )
echo "Routes in routing table: $routes_count"
