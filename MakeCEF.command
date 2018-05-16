PATH_DEBUG_IN=$(dirname $0)/CEFZip/Debug/
PATH_DEBUG_OUT=$(dirname $0)/Debug/"Chromium Embedded Framework.framework"/
cat "$PATH_DEBUG_IN"cefDebug.zip* > "$PATH_DEBUG_IN"CEFDebug.zip
unzip -a "$PATH_DEBUG_IN"CEFDebug.zip -d "$PATH_DEBUG_OUT"
rm "$PATH_DEBUG_IN"CEFDebug.zip

PATH_RELEASE_IN=$(dirname $0)/CEFZip/Release/
PATH_RELEASE_OUT=$(dirname $0)/Release/"Chromium Embedded Framework.framework"/
cat "$PATH_RELEASE_IN"CEFRelease.zip* > "$PATH_RELEASE_IN"cefRelease.zip
unzip -a "$PATH_RELEASE_IN"cefRelease.zip -d "$PATH_RELEASE_OUT"
rm "$PATH_RELEASE_IN"cefRelease.zip