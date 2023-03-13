#! /bin/zsh -f
cd $0:h/..

# Uncompress any Ableton Live set(s)
git diff --cached --name-only --diff-filter=ACM | grep .als |
while read
do zcat -qf < $REPLY > .tmp && mv .tmp $REPLY && git add $_
done

# Overwrite old dependencies.md
rm dependencies.md
echo "# Dependencies" > dependencies.md

# Print the name of the als file
ALS=$(grep -lr -E --include='*.als' --exclude-dir='*/Backup' .)
echo Path: $ALS

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
