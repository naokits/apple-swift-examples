// Playground - noun: a place where people can play

// iBoosで紹介されているコードを実際に実行してみるだけのプレイグラウンドです

import Cocoa

var str = "Hello, playground"


// Simple Values p6

/*
Use let to make a constant and var to make a variable. 
The value of a constant doesn’t need to be known at compile time, but you must assign it a value exactly once. 
This means you can use constants to name a value that you determine once but use in many places.
*/
var myVariable = 42
myVariable = 50
let myConstant = 42

/*
A constant or variable must have the same type as the value you want to assign to it. 
However, you don’t always have to write the type explicitly. 
Providing a value when you create a constant or variable lets the compiler infer its type. In the example above, 
the compiler infers that myVariable is an integer because its initial value is a integer.
*/


/*
If the initial value doesn’t provide enough information (or if there is no initial value), 
specify the type by writing it after the variable, separated by a colon.

“EXPERIMENT

Create a constant with an explicit type of Float and a value of 4.”

*/
let implicitInteger = 70
let implicitDouble = 70.0
let explicitDouble: Double = 70



let label = "The width is "
let width = 94
let widthLabel = label + String(width)


let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let fruitSummary = "I have \(apples + oranges) pieces of fruit."

let 苗字 = "筒井"
let 名前 = "直樹"
var 氏名 = 苗字 + 名前

氏名 = "hoge"

println(苗字 + 名前)





////////////////////////////


// Swift変数は、　var 変数名:　型 = 値で宣言する
//var explicitDouble: Double = 70

/// 型が省略された場合は。初期値によって推測する。
//var implicitInteger = 70
//var implicitDouble = 70.0

// "let" キーワードは定数/今後変化しない値を定義し型も省略できる。
// また変数名は絵文字、日本語そして中国語などの言語も使用できる。
let リンゴの数 = 3
let みかんの数 = 5
//\(￥サインまたはバックスラッシュ）に続く（変数名）はそこに変数を代入する)

let リンゴ説明 = "私は\(リンゴの数)個のリンゴを持っている。"  // ”私は3個のリンゴを持っている。"
let 果物説明 = "私は\(リンゴの数 + みかんの数)個の果物を持っている。" //"私は8個の果物を持っている。"

// Swiftは文法の中にNSArray や NSDictionaryコレクションクラスを綺麗に隠す
// この場合、dictionary /辞書を定義している。　4つの人の名前と年齢を持っている。 キー：値の順
let people = ["Anna": 67, "Bety": 8, "Jack": 33, "Sam": 25]

// Swiftの柔軟な　enumerator/ 列挙　を使って1つのループの中でpeapleが持つメンバー4人全ての2つの値を連続して取り出す。
for (name, age) in people {
    println("\(name) is \(age) years old.")
}

// メソッドやファンクションは "func"文法を使って宣言する。
// パラメータ名の付け方に注意。　-> で戻り値の型を宣言する
func sayHello(personName: String) -> String {
    let greeting = "こんにちは、" + personName + "さん"
    return greeting
}

// "こんにちは、花子さん"をプリントする
println(sayHello("花子"))



let dec = 29
let bin = 0b11101  // 2進数で29
let oct = 0o35     // 8進数で29
let hex = 0x1D     // 16進数で29

var arr = ["あ", "い", "う", "え", "お"]
let emptyArray = String[]()

//var dict2 = [a:"あ", i:"い", u:"う", e:"え", o:"お"]

let emptyDictionary = Dictionary<String, Float>()


let errorStatus: (Int, String) = (404, "Not Found")


let errorStatus2 = (404, "Not Found")



