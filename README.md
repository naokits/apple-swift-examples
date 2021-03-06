## apple-swift-examples
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/naokits/apple-swift-examples?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


このプロジェクトはアップル社の新言語**[Swift]**を使用した、さまざまなiOSアプリケーションのサンプルを提供することを目的としています。

現在のところ、このリポジトリは、[naokits]と[ikesyo]の二人が管理しています。

このREADMEでは必要最低限の説明のみしていますので、各サンプルの詳細内容についてはそれぞれのサンプルのREADMEを御覧ください。


### [swift-iTunesFeed-RAC](https://github.com/naokits/apple-swift-examples/tree/master/swift-iTunesFeed-RAC)

次のライブラリを使用したiTunesフィードを表示するサンプルです。

* [AFNetworking]
* [Mantle]
* [ReactiveCocoa]
* [SDWebImage]


### [iTunesFeedReader](https://github.com/naokits/apple-swift-examples/tree/master/iTunesFeedReader)

iTunesフィード（トップ20のソング）を一覧表示し、任意のセルをタップすると詳細情報（辞書配列の内容）を表示する簡単なサンプルアプリケーションです。
フィードを取得するコードはObjective-Cで記述（AFNetworkingを使用）しています。

このサンプルアプリケーションでは、CocoaPodsを使用して次のライブラリを使用しています。

* [AFNetworking]
* [SDWebImage]

### [DownloadDemo](https://github.com/naokits/apple-swift-examples/tree/master/DownloadDemo)

NSURLSessionDownloadDelegateを使用した、大きめのPDFファイルをダウンロードするデモアプリ。（バックグラウンド通信対応）

### [ResumeDownloadDemo](https://github.com/naokits/apple-swift-examples/tree/master/ResumeDownloadDemo)

NSURLSessionDownloadDelegateを使用した、大きめのPDFファイルをダウンロードするデモアプリ。（バックグラウンド通信、レジューム対応）

### AnimatedImageDemo

バンドル内の複数の画像ファイルをアニメーションで表示するデモアプリ

* [wantedly/swift-rss-sample](https://github.com/wantedly/swift-rss-sample)


## 関連情報

* [Swift Programming Language - Apple Developer](https://developer.apple.com/swift/)

## ライセンス

それぞれのサンプルのREADMEを御覧ください。

[ikesyo]: https://github.com/ikesyo
[naokits]: https://github.com/naokits

[Swift]: https://developer.apple.com/swift/

[AFNetworking]: https://github.com/AFNetworking/AFNetworking
[SDWebImage]: https://github.com/rs/SDWebImage
[ReactiveCocoa]: https://github.com/ReactiveCocoa/ReactiveCocoa
[Mantle]: https://github.com/Mantle/Mantle
[TheAmazingAudioEngine]: https://github.com/TheAmazingAudioEngine/TheAmazingAudioEngine
