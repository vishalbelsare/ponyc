#! /bin/bash

REPO_TYPE=$1        # e.g., rpm | debian | source
PACKAGE_VERSION=$2  # e.g., 0.2.1-234.master.abcdefa
PACKAGE_NAME=$3     # e.g., ponyc

# TODO: cut "ponyc" out of the repo names
BINTRAY_REPO_NAME="ponyc-$REPO_TYPE"
OUTPUT_TARGET="bintray_${REPO_TYPE}.json"

DATE="$(date +%Y-%m-%d)"

case "$REPO_TYPE" in
  "debian")
    FILES="\"files\":
        [
          {
            \"includePattern\": \"/home/travis/build/ponylang/ponyc/build/bin/(.*.deb)\", \"uploadPattern\": \"\$1\",
            \"matrixParams\": {
            \"deb_distribution\": \"pony-language\",
            \"deb_component\": \"main\",
            \"deb_architecture\": \"amd64\"}
         }
       ],
       \"publish\": true" 
    ;;
  "rpm")
    FILES="\"files\":
      [
        {\"includePattern\": \"/home/travis/build/ponylang/ponyc/build/bin/(.*.rpm)\", \"uploadPattern\": \"\$1\"}
      ],
    \"publish\": true" 
    ;;
  "source")
    FILES="\"files\":
      [
        {\"includePattern\": \"/home/travis/build/ponylang/ponyc/build/bin/(.*.tar.bz2)\", \"uploadPattern\": \"\$1\"}
      ],
    \"publish\": true"
    ;;
  "appimage")
    FILES="\"files\":
      [
        {\"includePattern\": \"/home/travis/build/ponylang/ponyc/(.*.AppImage)\", \"uploadPattern\": \"\$1\"}
      ],
    \"publish\": true"
    ;;
esac

JSON="{
  \"package\": {
    \"repo\": \"$BINTRAY_REPO_NAME\",
    \"name\": \"$PACKAGE_NAME\",
    \"subject\": \"pony-language\"
  },
  \"version\": {
    \"name\": \"$PACKAGE_VERSION\",
    \"desc\": \"ponyc release $PACKAGE_VERSION\",
    \"released\": \"$DATE\",
    \"vcs_tag\": \"$PACKAGE_VERSION\",
    \"gpgSign\": false
  },"

JSON="$JSON$FILES}"

echo "Writing JSON to file: $OUTPUT_TARGET, from within $(pwd) ..."
echo "$JSON" >> "$OUTPUT_TARGET"

echo "=== WRITTEN FILE =========================="
cat -v "$OUTPUT_TARGET"
echo "==========================================="

