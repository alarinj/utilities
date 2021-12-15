#!/bin/bash
ifconfig eth0 | grep inet | awk '{print $2}' | head -n 1
ifconfig tun0 | grep inet | awk '{print $2}' | head -n 1
