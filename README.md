# nebill

neat + bill = nebill

## 環境構築手順

### phantomjs(featureテストを実行するために必要)

```sh
brew install phantomjs
```

### node/bowerのインストール(bower-railsを使うために必要)

```
brew install nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH
nodebrew install-binary stable
nodebrew use stable
npm install bower -g
```

### install

```sh
bundle install --path=vendor/bundle
bundle exec rake bower:install
```

### db:create

```sh
bundle exec rake db:create
```

### sample data

```sh
bundle exec rake db:sample:populate
```

## 開発ルール

### 要約

以下を実行してエラーが起きないこと

```sh
bundle exec rubocop                       && \
bundle exec rake coffeelint               && \
bundle exec slim-lint app/views/**/*.slim && \
bundle exec rspec                         && \
bundle exec rake teaspoon
```

### コーディング規約

- ruby : rubocopに従うこと
- coffee : coffee-lintに従うこと
- slim : slim-lintに従うこと
- scss : **TODO**

### Annotate

以下のように使い分けること

キーワード | 内容
---------- | --------------------------
TODO       | あとで追加すべき不足している機能を記す
FIXME      | 修正すべき壊れたコードを記す
OPTIMIZE   | パフォーマンスに影響を与える最適化すべき箇所を記す
HACK       | リファクタリングすべきコードの臭いのする箇所を記す
REVIEW     | レビューすべき箇所を記す

- **`TDOO`を書く場合は「いつやるか」を明記すること**
- annotateのあとには名前を入れること 例) `TODO(hishida): hogehoge`
