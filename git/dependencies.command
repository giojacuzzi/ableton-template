#! /bin/zsh -f
cd $0:h/..

if ! [ -x "$(command -v xml)" ]; then
  echo 'ERROR: xmlstarlet is not installed' >&2
  echo "Run `git/dependencies.command` to generate this file" > dependencies.md
  exit 0
fi

# Uncompress any Ableton Live set(s)
git diff --cached --name-only --diff-filter=ACM | grep .als |
while read
do zcat -qf < $REPLY > .tmp && mv .tmp $REPLY && git add $_
done

# Remove old dependencies.md
rm dependencies.md

# Print the name of the als file
ALS=$(grep -lr -E --include='*.als' --exclude-dir='*/Backup' .)
if [ -z "$var" ]
then
  echo 'ERROR: no .als file found' >&2
  echo "Run `git/dependencies.command` to generate this file" > dependencies.md
  exit 0
else
  echo Path: $ALS
  echo "# Dependencies" > dependencies.md
fi

VERSION=$(xml sel -t -v '/Ableton/@Creator' "$ALS")
echo Version: $VERSION
echo "$VERSION" >> dependencies.md

PLUGINS=$(xml sel -t -v "//PluginDesc//Name/@Value" "$ALS")
echo -e "Plugins:\n$PLUGINS"

MANUFACTURERS=$(xml sel -t -v "//PluginDesc//Manufacturer/@Value" "$ALS")
echo -e "Manufacturers:\n$MANUFACTURERS"

plugin=()
while IFS= read -r line; do plugin+=("$line"); done <<<"$PLUGINS"
manufacturer=()
while IFS= read -r line; do manufacturer+=("$line"); done <<<"$MANUFACTURERS"

echo "|Plugin|Manufacturer|" >> dependencies.md
echo "|-|-|" >> dependencies.md
for ((i=1; i<=${#plugin[@]}; i++)); do
    if [ "${plugin[$i]}" != "Default" ]; then
        echo -n "|${plugin[$i]}|${manufacturer[$i]}" >> dependencies.md
        echo "|" >> dependencies.md
    fi
done

exit
