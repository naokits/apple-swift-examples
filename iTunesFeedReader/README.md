
## iTunesFeedReader

概要



このサンプルアプリについての説明


アップルの[RSS Generator](https://rss.itunes.apple.com/jp/?urlDesc=%2Fgenerator)から取得したフィード情報を一覧表示し、任意のセルをタップすると、該当のフィード情報を表示します。
表示されるのは辞書配列を文字列化した内容のみです。

取得しているフィード情報は次のとおりです。

* 国: 日本
* メディアタイプ: ミュージック
* フィードタイプ: トップソング
* 件数: 20
* ジャンル: All

このサンプルは、次のライブラリを使用しています。また、ライブラリの導入にはCocoaPodsを使用しています

* [AFNetworking]
* [SDWebImage]


また、このサンプルでは、CocoaPodsを使用している他、フィード情報を取得するネットワーク通信部分のコードは、Objective-Cで記述されています。



[AFNetworking]: https://github.com/AFNetworking/AFNetworking
[SDWebImage]: https://github.com/rs/SDWebImage
