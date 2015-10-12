#!/bin/sh

cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

/bin/echo -n "Configuring karabiner:	"
$cli set remap.pc_application2commandLspace 1
/bin/echo -n .
$cli set remap.fnletter_to_ctrlletter 1
/bin/echo -n .
/bin/echo
