command -v carthage >/dev/null 2>&1 || { missingCommand "carthage" "https://github.com/Carthage/Carthage/releases"; }

xcodesdk=`xcodebuild -scheme Debug  -showBuildSettings  | grep -i 'SDK_VERSION =' | sed 's/[ ]*SDK_VERSION = //' | colrm 3`
echo Xcode SDK: "$xcodesdk"
if [[ "$xcodesdk" != "13" ]]; then
  echo XCode 12 version detected! ••• Please ensure this is correct. •••
fi

carthage bootstrap $CARTHAGE_VERBOSE --platform ios --color auto --cache-builds --no-use-binaries
