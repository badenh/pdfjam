#!/bin/bash

set -e # exit with nonzero exit code if anything fails

if [[ $TRAVIS_BRANCH == "devel" && $TRAVIS_PULL_REQUEST == "false" ]]; then

echo "Starting to update latest_build\n"



#copy data we're interested in to other place
mkdir -p $HOME/temp
echo "directory made"
cp -R ./pdfjam.conf $HOME/temp
echo "copying done"

#go to home and setup git
cd $HOME
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis"

#using token clone latest_build branch
git clone --quiet --branch=latest_build https://${GH_TOKEN}@github.com/${GH_USER}/${GH_REPO}.git latest_build > /dev/null

#go into directory and copy data we're interested in to that directory
cd latest_build
cp -Rf $HOME/temp/* .

#add, commit and push files
git add -f .
git commit -m "Travis build $TRAVIS_BUILD_NUMBER"
git push -f origin latest_build #  > /dev/null
echo "Done updating latest_build\n"

else
 echo "Skipped updating gh-pages, because build is not triggered from the devel branch."
fi;
