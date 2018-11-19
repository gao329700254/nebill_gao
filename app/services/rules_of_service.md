
# serviceのルールについて

serviceクラスを作るときは以下のルールを守って実装してください

1. クラス名には動詞と目的語と「Service」を付ける
2. 引数は必ずnewで渡してインスタンス化する
3. 1つのserviceにpublicなメソッドは、原則1つにする
4. 初期化したインスタンスはprivateのattr_readerで呼ぶ
5. 切り分けたメソッドはなるべくprivateなgetterメソッドとして実装する
