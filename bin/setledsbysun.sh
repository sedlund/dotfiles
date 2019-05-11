#!/bin/sh

#set -x

# This is meant to be run periodically.   Every 5 minutes for instance to check
# the current state of the leds and set them according to the sun.  Checking
# evey 5 minutes allows the device to be rebooted after sunset and the lights to
# come on as a connection verification, before the script is ran to turn them
# off again.

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
    logger -s "$0: $1"
    exit 1
}

check_requirements () {
    test -x "$(which curl)" || elog "curl not found and it is required.  Please install."
}

get_sun_times_from_net () {
    alog "Getting Sun data from network"

    # Use default interface incase we have a VPN running to get true location
    INTERFACE=$(ip route | grep default | awk '{print $5}')
    IP_INFO=$(curl --stderr /dev/null --interface "${INTERFACE}" ipinfo.io) || elog "Could not check IP from network"
    LOCATION=$(echo "${IP_INFO}" | grep loc | cut -d \" -f 4 | awk -F "," '{print "lat=" $1 "&lng=" $2}')

    # Returns are in UTC time
    SUN=$(curl --stderr /dev/null --interface "${INTERFACE}"  "https://api.sunrise-sunset.org/json?${LOCATION}&formatted=0") || elog "Could not get Sun data from network"

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

get_sun_times () {
    if [ -r "${SUN_FILE}" ]; then
        alog "Using local sunset cache data"
        # shellcheck source=/dev/null
        . "${SUN_FILE}"
    else
        alog "Local cache of sunset data NOT found"
        store_sun_times
    fi
}

check_led_state () {
    # turning off usb led, also turns off usb port
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

leds_on () {
    check_led_state
    if [ "${LEDS}" != "on" ] || [ "${LEDS}" = "reset" ]; then
        alog "Turning LEDs on"
        find /sys/devices/platform/leds-gpio/leds ! -path '*usb*' -name brightness -exec sh -c 'i="$1"; echo 255 > "${i}"' _ {} \;
        /etc/init.d/led start
    fi
}

leds_off () {
    check_led_state
    if [ "${LEDS}" != "off" ] || [ "${LEDS}" = "reset" ]; then
        alog "Turning LEDs off"
        find /sys/devices/platform/leds-gpio/leds ! -path '*usb*' -name brightness -exec sh -c 'i="$1"; echo 0 > "${i}"' _ {} \;
    fi
}

set_led_state () {
    CUR_HOUR="$(date -u +%H | sed s/^0//)" || elog "Cannot run date"
    CUR_MIN="$(date -u +%M | sed s/^0//)" || elog "Cannot run date "
    CUR_MINS="$(( CUR_HOUR * 60 + CUR_MIN ))" || elog "Cannot sum current minute"

    SUNRISE_MINS=$(( SUNRISE_HOUR * 60 + SUNRISE_MIN ))
    SUNSET_MINS=$(( SUNSET_HOUR * 60 + SUNSET_MIN ))

    if [ $CUR_MINS -ge $SUNRISE_MINS ] || [ $CUR_MINS -lt $SUNSET_MINS ]; then
        alog "Sun is up"
        leds_on
    else
        alog "Sun has set"
        leds_off
    fi
}

###############################################################################

main () {
    check_requirements
    get_sun_times
    set_led_state
    wlog
}

###############################################################################

main
