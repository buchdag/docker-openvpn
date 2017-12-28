#!/bin/bash
set -e

SERV_IP=$(ip -4 -o addr show scope global  | awk '{print $4}' | sed -e 's:/.*::' | head -n1)

#
# Generate a simple configuration, returns nonzero on error
#
ovpn_genconfig -u udp://$SERV_IP 

if [[ $ARCH = 'arm32v6' ]]; then
  RSA_KEY_SIZE='512'
elif [[ $ARCH = 'aarch64' ]]; then
  RSA_KEY_SIZE='1024'
else
  RSA_KEY_SIZE='2048'
fi

export EASYRSA_KEY_SIZE=$RSA_KEY_SIZE
export EASYRSA_BATCH=1
export EASYRSA_REQ_CN="Travis-CI Test CA"

#
# Initialize the certificate PKI state, returns nonzero on error
#
ovpn_initpki nopass 

#
# Test back-up
#
ovpn_copy_server_files
