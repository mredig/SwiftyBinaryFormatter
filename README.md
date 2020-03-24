# SwiftyBinaryFormatter

[![Swift Version][swift-badge]][swift-link] [![License][license-badge]][license-link] [![Carthage compatible][carthage-badge]][carthage-link]


This framework is an assistant in generating binary files. Makes it a lot easier, at least for me.

### What it is

Its philosophy is essentially to make compiling binary data easier to comprehend, as most of the functionality is already available directly in basic Swift types. Through a combination of typealiases to help mentally bridge the concept of `Byte` to `UInt8`, etc and conveniences to append larger types, automatically breaking them down into their smaller components (like taking a `Word`/`UInt32` and breaking it into 4 `Byte`/`UInt8`s to be successively appended to the blob). Additionally, it's meant to be as unobtrusive as possible, mimicing existing method naming styles so as to naturally slip into your code.

Note that, while semantically, the terms may not be entirely correct as they are technically relative to the platform they are on, they should should line up with what their typically understood to be. I think. I don't know everything.

So if you have a need to conform to a file spec that outputs binary data, this should help assist in making that easier.

### Basics

It provides methods to easily convert bidirectionallty between of the following types:

| Type | Alias |
|-|-|
| `UInt8` | `Byte` |
| `UInt16` | `TwoByte` |
| `UInt32` | `Word` |
| `UInt64` | `LongWord` |

All of the following can be converted *to* any of the above types easily:
* `UInt`
* `Int`
* `Int8`
* `Int16`
* `Int32`
* `Int64`

And finally, the following can be converted to an array of `Byte`:
* `Float`
* `Double`

The integer types all gain the following properties and methods (which enable the above mentioned functionality) through the `BinaryFormattingProtocol`:
* `var byteCount: Int`
* `static var typeByteCount: Int`
* `var longWords: [LongWord]`
* `var longWord: LongWord`
* `var wordsArray: [Word]` (`words` is already part of vanilla Swift)
* `var word: Word`
* `var twoBytes: [TwoByte]`
* `var twoByte: TwoByte`
* `var bytes: [Byte]`
* `var byte: Byte`
* `var hexString: String`
* `var binaryString: String`
* `init(hexString: String)`
* `init(character: Character)`
* `subscript(_ index: Int) -> UInt8` (returns the value of the bit in the requested index)
* `subscript(padded index: Int) -> UInt8` (returns the value of the bit in the requested index, padding if you escape the `bitWidth` of the type)

And both integer AND float types gain the `BitRepper` protocol, allowing easy retrieval of the underlying bit representation of the value. (Yes, float types come with this, but with the protcol, you can pass either type into a function and get the underlying `bitPattern` regardless)

So this is great and everything, but what can you do with it? Well, `Data` is a great type. The thing is, it's a bit strict. Its main interaction is with `UInt8`s, or `Byte`s. It only likes appending `Byte`s, initializing from `Byte`s, and pretty much nothing else. But that doesn't make much sense, does it? I mean, all these other types are really just `UInt8`/`Bytes`s underneath it all, aren't they? (Yes, they are) Well, the real magic of **SwiftyBinaryFormatter** is that you now can use all these types with Data and it will magically just break them down into their source `Byte`s for you.

So, have an `Int` you need to store in a `Data` blob? Easy!
```swift
let myInt = 1234

let myFirstData = Data(myInt.bytes)
```

Wait, now I need to smash a magic number on the front, and follow it up with a `Double` value of today's date and then pi.:

```swift
var compiledData = Data(bfp: magicNumber)
compiledData.append(myFirstData)
compiledData.append(Date().timeIntervalSince1970)
compiledData.append(Double.pi)
```

And finally add a `Byte`, `Word`, `TwoByte`, `Word`, `LongWord` sequence because reasons.

```swift
compiledData.append(contentsOf: [Byte(3), Word(42), TwoByte(1238), Word(123456789), LongWord(9999999999)])
```

I think you get the picture.

[carthage-link]: https://github.com/Carthage/Carthage
[carthage-badge]: https://img.shields.io/badge/carthage-compatible-red
[swift-badge]: https://img.shields.io/badge/swift-5.2-orange.svg
[swift-link]: https://swift.org/
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg
[license-link]: LICENSE
