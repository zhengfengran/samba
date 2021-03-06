#!/bin/sh

. "${TEST_SCRIPTS_DIR}/unit.sh"

define_test "3 nodes, all ok, IPs all unassigned, IPREALLOCATED error"

setup_ctdbd <<EOF
NODEMAP
0       192.168.20.41   0x0     CURRENT RECMASTER
1       192.168.20.42   0x0
2       192.168.20.43   0x0

IFACES
:Name:LinkStatus:References:
:eth2:1:2:
:eth1:1:4:

PUBLICIPS
10.0.0.31  -1
10.0.0.32  -1
10.0.0.33  -1

CONTROLFAILS
137	1	ERROR	CTDB_CONTROL_IPREALLOCATED fake failure
EOF

required_result 255 <<EOF
IPREALLOCATED failed on node 1, ret=-1
Assigning banning credits to node 1
takeover run failed, ret=-1
EOF
test_takeover_helper

required_result 0 <<EOF
Public IPs on ALL nodes
10.0.0.31 2
10.0.0.32 1
10.0.0.33 0
EOF
test_ctdb_ip_all
