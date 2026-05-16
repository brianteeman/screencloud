#!/bin/bash
if [ -n "$SNAP" ]; then
	#Set PYTHONHOME if running as a snap
	export PYTHONHOME=$SNAP/usr
	echo "Setting PYTHONHOME=$PYTHONHOME"
	if ! ls $PYTHONHOME/lib/python* 1> /dev/null 2>&1; then
		echo "Warning, there seems to be no python directories under PYTHONHOME/lib"
	fi
	export PYTHONPATH=$SNAP/share/screencloud/modules
	echo "Setting PYTHONPATH=$PYTHONPATH"
	#Set autostart location
	export SC_AUTOSTART_EXEC=screencloud
	#Set TMPDIR to outside the snap to allow using Gnome DBus screenshot API
	export TMPDIR=$SNAP_USER_COMMON
	exec screencloud "$@"
else
	#Do the same, but for AppImage
	HERE="$(dirname "$(readlink -f "${0}")")"
	export PYTHONHOME="${HERE}/.."
	export PYTHONPATH="${HERE}/../lib/python3.10:${HERE}/../share/screencloud/modules"
	export SC_AUTOSTART_EXEC=${APPIMAGE}
	exec "${HERE}/screencloud" "$@"
fi
