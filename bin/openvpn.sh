#!/bin/sh

cd ~/.openvpn

openvpn --config openvpn_client.ovpn --ca CA.cert.pem --cert openvpnclient.cert.pem --key openvpnclient.pkey.pem --auth-nocache
