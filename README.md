# SwiftyBinaryFormatter

This framework is an assistant in generating binary files. Makes it a lot easier, at least for me.

### What it is

Its philosophy is essentially to make compiling binary data easier to comprehend, as most of the functionality is already available directly in basic Swift types. Through a combination of typealiases to help mentally bridge the concept of `Byte` to `UInt8`, etc and conveniences to append larger types, automatically breaking them down into their smaller components (like taking a `Word`/`UInt32` and breaking it into 4 `Byte`/`UInt8`s to be successively appended to the blob). 

Note that, while semantically, the terms may not be entirely correct as they are technically relative to the platform they are on, they should should line up with what their typically understood to be. I think. I don't know everything.

So if you have a need to conform to a file spec that outputs binary data, this should help assist in making that easier.

### Basics

It provides methods to easily convert any of the following to any other:

| Type | Alias |
|-|-|
| `UInt8` | `Data.Byte` |
| `UInt16` | `Data.TwoByte` |
| `UInt32` | `Data.Word` |
| `UInt64` | `Data.LongWord` |

For example, all of the following work:

```swift
let myByte = Data.Byte(123)
let myTwoByte = myByte.twoByte
let myWord = myByte.word
let myLongWord = myByte.longWord

// and the other direction works too
let aLongWord = Data.LongWord(6159482783026658)
let aWord = aLongWord.word // 1464356322
let aTwoByte = aLongWord.twoByte // 19938
let aByte = aLongWord.byte // 226
```

Notice how, when going from a greater bit size to a smaller, the extra, large magnitude, bits are simply clipped.

If you need to losslessly convert from a larger bit size to a smaller, you can use the *pluralized* property to get an array of the requested type back. For example:

```swift
let aLongWord = Data.LongWord(6159482783026658)
let words = aLongWord.wordsArray // `.words` already exists in Foundation on int types
print(words) // [1434116, 1464356322]
let twoBytes = aLongWord.twoBytes
print(twoBytes) // [21, 57860, 22344, 19938]
let bytes = aLongWord.bytes
print(bytes) // [0, 21, 226, 4, 87, 72, 77, 226]
```

All of the above types can convert from and to each other, all following the principles that were just laid out.


