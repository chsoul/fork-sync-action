#!/bin/bash

# 确保脚本遇到错误时退出
set -e

# 获取仓库列表并进行同步
echo "Fetching the list of repositories..."
repos=$(gh repo list "$OWNER" --limit 200 --json nameWithOwner,isFork)

for repo in $(echo "$repos" | jq -c '.[]'); do
  nameWithOwner=$(echo "$repo" | jq -r '.nameWithOwner')
  isFork=$(echo "$repo" | jq -r '.isFork')
  
  if [ "$isFork" = "true" ]; then
    echo "Syncing forked repository: $nameWithOwner"
    gh repo sync "$nameWithOwner"
  else
    echo "Skipping non-fork repository: $nameWithOwner"
  fi
done
