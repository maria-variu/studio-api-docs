#! /bin/sh
set -e

echo "Build the documentation site" 

SOURCE_DIR=$PWD
TEMP_REPO_DIR=$PWD/../docs-gh-pages
remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/sdl/studio-api-docs.git"
echo "Remote repo is "
echo "Removing temporary doc directory $TEMP_REPO_DIR"
rm -rf $TEMP_REPO_DIR
mkdir $TEMP_REPO_DIR

echo "Cloning the repo with the gh-pages branch"
git clone ${remote_repo} --branch gh-pages $TEMP_REPO_DIR

echo "Clear repo directory"
cd $TEMP_REPO_DIR
git rm -r *

echo "Copy documentation into the repo"
cp -r $SOURCE_DIR/articles/* .

echo "Push the new docs to the remote branch"
git config --local user.email "cromica@gmail.com"
git config --local user.name "Romulus Crisan"
git add . -A
git commit -m "Update generated documentation"
git push origin gh-pages