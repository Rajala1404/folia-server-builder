#!/bin/bash

echo "Folia Server Builder by Rajala1404"
echo "Version: 1.0.1"

current_directory=$(pwd)

echo "Starting Build of Folia..."

branches_and_tags=$(git ls-remote --refs --tags --heads https://github.com/PaperMC/Folia.git | cut -f2 | cut -d'/' -f3- | sort -u)

echo "Available branches and tags:"
PS3="Please select a branch or tag (enter the number): "
select branch_or_tag in $branches_and_tags; do
    if [ -n "$branch_or_tag" ]; then
        break
    else
        echo "Invalid selection. Please choose a branch or tag."
    fi
done

clone_directory="/tmp/foliamc-build-temp"
mkdir -p "$clone_directory"
git clone --single-branch --branch "$branch_or_tag" https://github.com/PaperMC/Folia.git "$clone_directory"

cd "$clone_directory"

read -p "Please Type your git username: " gitUsername
read -p "Please Type your git Email: " gitEmail

git config user.name "$gitUsername"
git config user.email "$gitEmail"

./gradlew applyPatches
./gradlew createReobfBundlerJar

mv build/libs/*folia-bundler*SNAPSHOT-reobf.jar server.jar
cp server.jar "$current_directory"

echo "eula=true" > "$current_directory/eula.txt"

# RAM-Einstellungen abfragen
read -p "Min Ram ex. 256M: " minRam
read -p "Max Ram ex. 4G: " maxRam

echo "java -jar -Xms$minRam -Xmx$maxRam server.jar" > "$current_directory/run.sh"
chmod +x "$current_directory/run.sh"

rm -rf "$clone_directory"

echo "Build completed."

