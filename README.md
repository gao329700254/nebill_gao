# nebill

[![wercker status](https://app.wercker.com/status/e26313bf02ace0511f7b4f573a99f37f/m/master "wercker status")](https://app.wercker.com/project/byKey/e26313bf02ace0511f7b4f573a99f37f)

**neat + bill = nebill**

### 環境変数について

dev環境にて環境変数が必要の場合は.envファイルを作成して変数を設定してください
本番環境ではherokuの環境変数機能を使用しているため.envは必要ありません

## chatwork-hookの設定方法

1. ngrokをインストール
2. `ngrok http 3000` でngrokを起動する。
3. https://www.chatwork.com/service/packages/chatwork/subpackages/webhook/list.php にアクセスして、botちゃんのchatwork webhookに2で起動したngrokのurlを登録する。
4. トークンの値を環境変数 CHATWORK_WEB_HOOK_TOKEN に追加する。
