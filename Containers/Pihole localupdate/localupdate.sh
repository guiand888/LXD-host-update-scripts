#!/bin/bash

set -x

cloudflared update
pihole -up
pihole status
