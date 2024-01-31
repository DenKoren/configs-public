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

if [ "$( id -u )" -ne 0 ]; then
    echo "Script requires super-user privileges. Run with sudo."
    exit 1
fi

function progress_bar() {
  local _msg="${1}"
  local _cur="${2}"
  local _total="${3}"

  (( _progress = ( "${_cur}" * 100 / "${_total}" ) ))
  (( _done = ( "${_progress}" * 4 ) / 10 ))
  (( _left = 40 - "${_done}" ))

  _h='#' # just to not make some shell syntax highliters crazy
  _fill=$(printf "%${_done}s")
  _empty=$(printf "%${_left}s")
  printf "\r${_msg} (${_cur}/${_total}): [${_fill// /$_h}${_empty// /-}] ${_progress}%% "
}

function wait_routing()
{
    local _test_route="10.18.81.01/32"
    local _gw="10.110.011.01"

    # First ensure the route is not in the table
    route -q delete "${_test_route}" >/dev/null 2>/dev/null || true

    while route add -net "${_test_route}" "${_gw}" 2>&1 | 
        grep -q 'Network is unreachable'; do
        sleep 1
    done

    route -q delete "${_test_route}" >/dev/null 2>/dev/null || true
    sleep 3
}

function reference ()
{
        cat <<EndOfReference

        ${script_name} requires ${required_params} parameters
            ${script_name} interface_name [set|cleanup]

        Say, ${script_name} en1
        To get interface name you use for internet access, use 'networksetup -listnetworkserviceorder'

EndOfReference
}

function cleanup_routes() {
    local _interface="${1}"
    local _routes_count_all=0
    local _routes_count_current=0

    # Flush route table
    echo "Flush route table (down interface '${_interface}')..."
    ifconfig "${_interface}" down
    route -nq flush

    echo "Getting the list of old custom routes..."
    netstat -nr -f inet |
        grep 'UCSc' |
        awk -v "iface=${_interface}" '$4 == iface{print $1}' \
            > "${file_custom_routes}"

    _routes_count_all=$( wc -l <"${file_custom_routes}" | awk '{print $1}' )
    _routes_count_current=0

    if [ "${_routes_count_all}" -eq 0 ]; then
        echo "No old routes found for '${_interface}'"
    else
        while read -r route; do
            route -n delete -net "${route}" >/dev/null

            (( _routes_count_current += 1 ))
            progress_bar "Removing old routes" "${_routes_count_current}" "${_routes_count_all}"

        done <"${file_custom_routes}"
        echo ""
    fi

    echo "Bring interface '${_interface}' back..."
    ifconfig "${_interface}" up

    echo "Waiting for routing control working"
    wait_routing
}

function get_rus_network_list() {
    local _destination="${1}"

    # Get addresses RU segment
    echo "Download RU subnets..."
    curl \
        --progress-bar \
        "https://stat.ripe.net/data/country-resource-list/data.json?resource=ru" | 
        jq -r ".data.resources.ipv4[]" > "${file_raw}"

    echo "Deaggregate subnets..."
    grep "-" "${file_raw}" > "${file_for_calc}"
    grep -v "-" "${file_raw}" >> "${_destination}"

    while read -r route; do
        ipcalc "${route}" |
            grep -v "deaggregate" >> "${_destination}"
    done < "${file_for_calc}"

    if [ -f "${file_user}"  ]; then 
        echo "Add user subnets..."; 
        grep -v "#" "${file_user}" >> "${_destination}"
    fi
}

function add_routes() {
    local _routes="${1}"
    local _interface="${2}"

    local _routes_count_all=0
    local _routes_count_current=0
    local _default_gateway

    _default_gateway=$(
        netstat -nr -f inet |
        awk '/default/ { print $2 }'
    )

    _routes_count_all=$( wc -l <"${_routes}" | awk '{print $1}' )
    _routes_count_current=0
    while read -r route; do
        route -n add -net "${route}" "${_default_gateway}" >/dev/null

        (( _routes_count_current += 1 ))
        progress_bar "Adding new routes" "${_routes_count_current}" "${_routes_count_all}"

    done <"${_routes}"
    echo ""
}

if [ "$#" -lt "${required_params}" ]; then
        reference
        exit 64
fi

# Checking the environment
cd "${script_dir}"
mkdir -p "${cache_dir}"

# Call parameters
interface="${1}"
action="${2:-}" # 'cleanup' or 'set'. Empty value == both

if [ -z "${action}" ] || [ "${action}" = "cleanup" ]; then

    cleanup_routes "${interface}"

fi

if [ -z "${action}" ] || [ "${action}" = "set" ]; then

    : > "${file_processed}"

    get_rus_network_list "${file_processed}"
    add_routes "${file_processed}" "${interface}"

fi

echo "Removing temp files..."
rm -r "${cache_dir}"

routes_count=$( netstat -nr -f inet | wc -l )
echo "Routes in routing table: $routes_count"
