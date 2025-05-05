if [ ! -d "repos/safe-wallet-monorepo" ]; then
  echo "Wrong directory!"
  exit 1
fi

cp configs/safe-wallet-monorepo/.env repos/safe-wallet-monorepo/apps/web/

cd repos/safe-wallet-monorepo

git checkout dev
git fetch --tags
git pull

latest_tag=$(git describe --tags --abbrev=0)
latest_release=$(curl -s https://api.github.com/repos/safe-global/safe-wallet-monorepo/releases | jq -r 'map(select(.draft == false)) | .[0].name')
latest_deploy=$(curl -s https://app.safe.global/welcome | pup ':parent-of([data-testid=GitHubIcon]) text{}' | tr -d '[:space:]')

if [ "$latest_release" != "$latest_tag" ]; then
  echo "Latest tag ($latest_tag) is not released yet ($latest_release)."
fi

if [ "$latest_deploy" != "$latest_release" ]; then
  echo "Latest release ($latest_release) is not deployed yet ($latest_deploy)."
fi

git checkout $latest_deploy

yarn

missing_envars=$(comm -23 <(grep -E '^\s+NEXT_PUBLIC_' .github/actions/build/action.yml | sed -E 's/^\s+([^:]+):.*/\1/' | cat - <(echo -e "NEXT_PUBLIC_INFURA_TOKEN\nNEXT_PUBLIC_SAFE_APPS_INFURA_TOKEN") | sort -u) <(grep -vE '^#|^$' apps/web/.env 2>/dev/null | sed -E 's/=.*//' | sort -u))

if [ ! -z "$missing_envars" ]; then
  echo "Missing environment variables in .env file:"
  echo $missing_envars | tr -s '[:space:]' '\n'
  exit 1
fi

yarn workspace @safe-global/web build
yarn workspace @safe-global/web integrity
