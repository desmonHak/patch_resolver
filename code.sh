git add .
git config advice.addIgnoredFile false
git add -f .gitignore
echo "code.sh" >> .gitignore

git add -f code.sh
git rm --cached "./code.sh"

OLD_EMAIL="tu_correo@gmail.com"
NEW_EMAIL="aaa@gmail.com"
NEW_NAME="Desmon"

git status
git config --global user.name "$NEW_NAME"
git config --global user.email "$NEW_EMAIL"
git commit -m "confirmacion"

git filter-branch --index-filter 'git rm --cached --ignore-unmatch code.sh' HEAD

git filter-branch -f --env-filter '
  if test "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL"
  then
    GIT_AUTHOR_EMAIL=$NEW_EMAIL
    GIT_AUTHOR_NAME=$NEW_NAME
  fi

  if test "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL"
  then
    GIT_COMMITTER_EMAIL=$NEW_EMAIL
    GIT_COMMITTER_NAME=$NEW_NAME
  fi
' -- --all

echo "subiendo cambios"
git config --global credential.helper cache

git push --force --all
git push --force --tags
git log