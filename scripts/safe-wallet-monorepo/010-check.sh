user_agent="FricBot/0.1 (https://github.com/jenkin/fric;me@jenkin.dev) curl/7.88.1"

if [ ! -d "repos/safe-wallet-monorepo/apps/web/out" ]; then
  echo "Wrong directory!"
  exit 1
fi

cd repos/safe-wallet-monorepo/apps/web/out

for html in $(find . -type f -name '*.html'); do
  if [ -f "$html" ]; then
    remote_path=$(echo $html | cut -c 3-)
    remote_status=$(curl -A "$user_agent" -sIL https://app.safe.global/$remote_path | head -n 1 | cut -d$' ' -f2)

    if [ "$remote_status" != "200" ]; then
      echo "File $html not found on remote server."
      continue
    fi

    remote_resource=$(curl -A "$user_agent" -sL https://app.safe.global/$remote_path | yarn dlx -q -p prettier prettier --parser html --ignore-path .prettierignore --stdin-filepath $(basename "$html"))
    remote_shasum=$(echo $remote_resource | shasum -a 384 | cut -d' ' -f1)

    local_resource=$(yarn dlx -q -p prettier prettier --parser html --ignore-path .prettierignore $html)
    local_shasum=$(echo $local_resource | shasum -a 384 | cut -d' ' -f1)

    if [ "$local_shasum" == "$remote_shasum" ]; then
      echo "No differences found in $html (sha384-$local_shasum)"
    else
      echo "Differences found in $html:"
      wdiff -3 <(echo $remote_resource) <(echo $local_resource) | colordiff
      echo
    fi
  fi
done

for js in $(find . -type f -name '*.js'); do
  if [ -f "$js" ]; then
    remote_path=$(echo $js | cut -c 3-)
    remote_status=$(curl -A "$user_agent" -sIL https://app.safe.global/$remote_path | head -n 1 | cut -d$' ' -f2)

    if [ "$remote_status" != "200" ]; then
      echo "File $js not found on remote server."
      continue
    fi

    remote_resource=$(curl -A "$user_agent" -sL https://app.safe.global/$remote_path | yarn dlx -q -p prettier prettier --parser babel --ignore-path .prettierignore --stdin-filepath $(basename "$js"))
    remote_shasum=$(echo $remote_resource | shasum -a 384 | cut -d' ' -f1)
    
    local_resource=$(yarn dlx -q -p prettier prettier --parser babel --ignore-path .prettierignore $js)
    local_shasum=$(echo $local_resource | shasum -a 384 | cut -d' ' -f1)
    
    if [ "$local_shasum" == "$remote_shasum" ]; then
      echo "No differences found in $js (sha384-$local_shasum)"
    else
      echo "Differences found in $js:"
      wdiff -3 <(echo $remote_resource) <(echo $local_resource) | colordiff
      echo
    fi
  fi
done
