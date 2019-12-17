環境構築手順
1. homebrewのインストール
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
2. postgresのインストール(https://qiita.com/gooddoog/items/1f986c1a6c0f253bd4e2)
3. phantomjs(featureテストを実行するために必要)
brew install phantomjs
4. node/bowerのインストール(bower-railsを使うために必要)
brew install nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH
nodebrew install-binary stable
nodebrew use stable
npm install bower -g
5. git clone
git clone git@bitbucket.org:bitbucketcuon/nebill.git
6. install
bundle install --path=vendor/bundle
bundle exec rake bower:install
rm vendor/assets/bower_components/toastr/toastr.scss #エラーの原因になるためtoastr.scssを削除
7. DBの作成
createdb nebill_development #DBの作成
psql nebill_development #postgresのnebill_developmentにログイン
nebill_development=# CREATE USER nebill; #postgresの中でnebillというユーザを作成
nebill_development=# ALTER ROLE nebill WITH SUPERUSER; #nebillの権限をSUPERUSに変更
nebill_development=# ALTER DATABASE nebill_development OWNER TO nebill; #nebill_developmentの所有者をnebillに変更
nebill_development=# [control] + Dで抜ける
8. db:create
(git cloneしたディレクトリに入ってから)
bundle exec rake db:create
9. seed
bundle exec rake db:seed
Input admin user emailと聞かれたら自分のメールアドレスを入力する。

10. sample data
bundle exec rake db:sample:populate all=true
