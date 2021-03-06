#!/bin/bash -xe
HUB="2.2.0"

# 認証情報を設定する
mkdir -p "$HOME/.config"
set +x
echo "https://${GH_TOKEN}:@github.com" > "$HOME/.config/git-credential"
echo "github.com:
- oauth_token: $GH_TOKEN
  user: $GH_USER" > "$HOME/.config/hub"
unset GH_TOKEN
set -x

# Gitを設定する
git config --global user.name  "${GH_USER}"
git config --global user.email "${GH_USER}@users.noreply.github.com"
git config --global core.autocrlf "input"
git config --global hub.protocol "https"
git config --global credential.helper "store --file=$HOME/.config/git-credential"

# hubをインストールする
curl -LO "https://github.com/github/hub/releases/download/v$HUB/hub-linux-amd64-$HUB.tar.gz"
tar -C "$HOME" -zxf "hub-linux-amd64-$HUB.tar.gz"
export PATH="$PATH:$HOME/hub-linux-amd64-$HUB"

# リポジトリに変更をコミットする
hub clone "TravisCI" _
cd _
#hub checkout "master"
#### ファイルを変更する ##
#hub add .
#hub commit -m "コミットメッセージ"

# Pull Requestを送る
hub pull-request -m "Pull Requestメッセージ" -b Travis:develop -h Travis:master
cd ..
