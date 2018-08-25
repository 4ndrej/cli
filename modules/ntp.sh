#!/bin/bash

function ntp {
  status="$1"

  if [ "$status" = "on" ]; then
    rm -rf /boot/time &> /dev/null
    sed -i "s/server 127\.127\.1\.0//" /etc/ntp.conf
    sed -i "s/fudge 127\.127\.1\.0 stratum 10//" /etc/ntp.conf
    sed -i "s/restrict 192\.168\.0\.0 mask 255\.255\.0\.0 nomodify notrap//" /etc/ntp.conf

    echo "Success: please reboot you rpi to apply changes."
  elif [ "$status" = "off" ]; then
    service ntp restart
    date > /boot/time
    hwclock -w
    hwclock -r >> /boot/time
    hwclock -s
    date >> /boot/time
    {
      echo "server 127.127.1.0"
      echo "fudge 127.127.1.0 stratum 10"
      echo "restrict 192.168.0.0 mask 255.255.0.0 nomodify notrap"
    } >> /etc/ntp.conf
    echo "Success: please reboot you rpi to apply changes."
  else
    echo "Error: only on, off options are supported"
    exit 0
  fi
}

function ntp_help {
  echo ""
  echo "Usage: $(basename "$0") ntp <on|off>"
  echo ""
  echo "Enables or disables time through ntp servers"
  echo ""
  echo "Example:"
  echo "  $(basename "$0") ntp on"
  echo "      Enables the ntp service."
  echo ""
  echo "  $(basename "$0") ntp off"
  echo "      Disables the ntp service."
}