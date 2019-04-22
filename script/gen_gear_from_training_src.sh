#!/usr/bin/env bash
set -euo pipefail

cwd=$(dirname "${0}")
path=$1
gear_name_snakecase=${path##*/}
gear_name_camelcase=$(echo "$gear_name_snakecase" | perl -pe 's/(^|_)./uc($&)/ge;s/_//g')
app_id=$2
group_id=$3

cp -r "${cwd}"/../ "$path"
cd "${path}"

sh script/override_by_training_src.sh

git add .
git commit -m "tmp commit"

rm -r -f ./_build
rm -r -f ./deps
rm -r -f ./training_src

git grep -l stackoverflow_clone_l | xargs sed -i "" -e "s/stackoverflow_clone_l/${gear_name_snakecase}/g"
git grep -l StackoverflowCloneL | xargs sed -i "" -e "s/StackoverflowCloneL/${gear_name_camelcase}/g"

git grep -l a_BvqzN73e | xargs sed -i "" -e "s/a_BvqzN73e/${app_id}/g"
git grep -l g_YnXGcHXR | xargs sed -i "" -e "s/g_YnXGcHXR/${group_id}/g"

rename_command="mv {} \`echo '{}' | sed \"s/stackoverflow_clone_l/${gear_name_snakecase}/g\"\`"
find . -name "*stackoverflow*" -exec bash -c "${rename_command}" \;

rm -r -f ./.git

echo "${gear_name_camelcase} has been creaed."
