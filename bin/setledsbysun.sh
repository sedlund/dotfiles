#!/bin/sh

#set -x

# setledsbysun v1

###############################################################################

# Copyright 2019 Scott Edlund
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###############################################################################

# Usage:

# This is meant to be run periodically.  Every 5 minutes for instance to check
# the current state of the leds and set them according to the sun.  Checking
# evey 5 minutes allows the device to be rebooted after sunset and the lights to
# come on as a connection verification, before the script is ran to turn them
# off again.

# This will not refresh the cache file that stores the sunrise/set times.  I run
# this on a router that gets rebooted often enough that it will refresh the cache
# before the sun times change meaningfully for me.  If you need to refresh it,
# make a cron entry that removes the cache file every week or so, this script
# will then recache fresh data.

# For every 5 minutes, put this file in /root/setledsbysun.sh and use
# this cron line (without the beginning # symbol).

# */5 * * * * /root/setledsbysun.sh

# To remove the Sun data cache weekly add this entry

# 34 4 * * 7 rm /tmp/suntimes.tmp

###############################################################################

readonly SUN_FILE="/tmp/suntimes.tmp"

# append to message to log
alog () {
    MSG="${MSG} $1."
}

# Write out final log
wlog () {
    logger -s "$0:${MSG}"
}

# log and exit on fatal errors
elog () {
    logger -s "$0: ERROR: $1"
    exit 1
}

check_requirements () {
    test -x "$(which curl)" || elog "curl not found and it is required.  Please install."
}

get_sun_times_from_net () {
    alog "Getting Sun data from network"

    # Use default interface incase we have a VPN running to get true location
    INTERFACE=$(ip route | grep default | awk '{print $5}')
    IP_INFO=$(curl --stderr /dev/null --interface "${INTERFACE}" ipinfo.io) \
        || elog "Could not check IP from network"
    LOCATION=$(echo "${IP_INFO}" | grep loc | cut -d \" -f 4 | awk -F "," '{print "lat=" $1 "&lng=" $2}')

    # Returns are in UTC time
    SUN=$(curl --stderr /dev/null --interface "${INTERFACE}" \
        "https://api.sunrise-sunset.org/json?${LOCATION}&formatted=0") \
            || elog "Could not get Sun data from network"

    SUNRISE=$(echo "${SUN}" | cut -d \" -f 6)
    SUNRISE_TIME=$(echo "${SUNRISE}" | cut -d T -f 2 | cut -d + -f 1 | cut -d : -f 1-2)
    SUNRISE_HOUR=$(echo "${SUNRISE_TIME}" | cut -d : -f 1 | sed s/^0//)
    SUNRISE_MIN=$(echo "${SUNRISE_TIME}" | cut -d : -f 2 | sed s/^0//)

    SUNSET=$(echo "${SUN}" | cut -d \" -f 10)
    SUNSET_TIME=$(echo "${SUNSET}" | cut -d T -f 2 | cut -d + -f 1 | cut -d : -f 1-2)
    SUNSET_HOUR=$(echo "${SUNSET_TIME}" | cut -d : -f 1 | sed s/^0//)
    SUNSET_MIN=$(echo "${SUNSET_TIME}" | cut -d : -f 2 | sed s/^0//)
}

store_sun_times () {
    get_sun_times_from_net

    cat > "${SUN_FILE}" << _EOF_
SUNRISE_HOUR="${SUNRISE_HOUR}"
SUNRISE_MIN="${SUNRISE_MIN}"
SUNSET_HOUR="${SUNSET_HOUR}"
SUNSET_MIN="${SUNSET_MIN}"
_EOF_

#    echo "${SUN}" > /tmp/sun.tmp
}

check_sun () {
    if [ -r "${SUN_FILE}" ]; then
        alog "Using local Sun cache data"
        # shellcheck source=/dev/null
        . "${SUN_FILE}"
    else
        alog "Local cache of Sun data NOT found"
        store_sun_times
    fi
}

check_led_state () {
    # turning off usb led also turns off usb port
    # the wlan led flashes with activity. not always on
    LED_STATE="$( find /sys/devices/platform/leds-gpio/leds ! -path '*usb*' ! -path '*wlan*' -name brightness -exec cat {} \; )"
    if echo "${LED_STATE}" grep 255 > /dev/null && ! echo "${LED_STATE}" | grep 0 > /dev/null; then
        alog "LEDs are on"
        LEDS=on
    elif ! echo "${LED_STATE}" | grep 255 > /dev/null && echo "${LED_STATE}" | grep 0 > /dev/null; then
        alog "LEDs are off"
        LEDS=off
    else
        alog "LEDs need reset"
        LEDS=reset
    fi

    readonly LEDS
}

set_led_state () {
    CUR_HOUR="$(date -u +%H | sed s/^0//)" || elog "Cannot run date"
    CUR_MIN="$(date -u +%M | sed s/^0//)" || elog "Cannot run date "
    CUR_MINS="$(( CUR_HOUR * 60 + CUR_MIN ))" || elog "Cannot sum current minute"

    SUNRISE_MINS=$(( SUNRISE_HOUR * 60 + SUNRISE_MIN ))
    SUNSET_MINS=$(( SUNSET_HOUR * 60 + SUNSET_MIN ))

    check_led_state

    if [ $CUR_MINS -ge $SUNRISE_MINS ] && [ $CUR_MINS -lt $SUNSET_MINS ]; then
        alog "Sun is up"
        if [ "${LEDS}" = "off" ] || [ "${LEDS}" = "reset" ]; then
            alog "Turning LEDs on"
            find /sys/devices/platform/leds-gpio/leds \
                ! -path '*usb*' \
                -name brightness \
                -exec sh -c 'i="$1"; echo 255 > "${i}"' _ {} \;
            /etc/init.d/led start
        fi
    else
        alog "Sun has set"
        if [ "${LEDS}" = "on" ] || [ "${LEDS}" = "reset" ]; then
            alog "Turning LEDs off"
            find /sys/devices/platform/leds-gpio/leds \
                ! -path '*usb*' \
                -name brightness \
                -exec sh -c 'i="$1"; echo 0 > "${i}"' _ {} \;
        fi
    fi
}

###############################################################################

main () {
    check_requirements
    check_sun
    set_led_state
    wlog
}

###############################################################################

main
