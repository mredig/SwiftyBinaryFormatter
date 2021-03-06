//
//  BinaryFormattingProtocol.swift
//  BinaryFormatter
//
//  Created by Michael Redig on 5/1/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//

import Foundation

public protocol BinaryFormattingProtocol: CustomStringConvertible {
	var byteCount: Int { get }
	static var typeByteCount: Int { get }

	/**
	Whether larger or smaller than a LongWord, will form an array of LongWords, breaking at appropriate intervals.
	LongWord values will be padded with 0s if smaller. Larger values won't overflow but instead create a new LongWord.
	(See bytes)
	*/
	var longWords: [LongWord] { get }
	/// 64 bit value. Will pad value with 0s if smaller than 64 bits.
	var longWord: LongWord { get }

	/**
	Whether larger or smaller than a Word, will form an array of Words, breaking at appropriate intervals. Word values
	will be padded with 0s if smaller. Larger values won't overflow but instead create a new Word. (See bytes)

	Note that this breaks the established naming convention to include the word "Array". This is because there's an
	existing "words" property.
	*/
	var wordsArray: [Word] { get }
	/// 32 bit value. Will pad value with 0s if smaller than 32 bits. Will clip value if larger than 32 bits. (see byte)
	var word: Word { get }

	/**
	Whether larger or smaller than a TwoByte, will form an array of TwoBytes, breaking at appropriate intervals. TwoByte
	values will be padded with 0s if smaller. Larger values won't overflow but instead create a new TwoByte. (See bytes)
	*/
	var twoBytes: [TwoByte] { get }
	/// 16 bit value. Will pad value with 0s if smaller than 16 bits. Will clip value if larger than 16 bits. (see byte)
	var twoByte: TwoByte { get }

	/**
	Whether larger or smaller than a Byte, will form an array of Bytes, breaking at appropriate intervals. Byte
	values will be padded with 0s if smaller. Larger values won't overflow but instead create a new Byte.

	For example, given a Word (with 32 bits) such as `00110011 01010101 00000000 00001111` (aka `861208591`) would be
	converted to a Byte array resulting in `[00110011, 01010101, 00000000, 00001111]` (aka `[51, 85, 0, 15]`)
	*/
	var bytes: [Byte] { get }
	/**
	8 bit value. Will pad value with 0s if smaller than 8 bits. Will clip value if larger than 8 bits.

	For example, given a Word (with 32 bits) such as `00110011 01010101 00000000 00001111` (aka `861208591`) would be
	clipped to a Byte resulting in `00001111` (aka `15`). Conversely, given a value of `101` (aka `5`) will result in
	`00000101` (aka `5`).
	*/
	var byte: Byte { get }

	/**
	Will throw in the following scenarios:
	* if hexString contains non hex characters
	* if hexString is longer than the bytes of the type you're creating
		* word: four bytes
		* twoBytes: two bytes
		* byte: one byte
	* if, for some reason, the provided string cannot be converted to the type you're creating (shouldn't occur if
	you've followed the above rules)
	*/
	init(hexString: String) throws

	/**
	Will throw in the following scenarios:
	* if character is a non ascii value
	*/
	init(character: Character) throws

	var hexString: String { get }
	var binaryString: String { get }
}

public extension BinaryFormattingProtocol where Self: (FixedWidthInteger & BitRepper) {
	static var invalidHexCharacters: CharacterSet {
		CharacterSet(charactersIn: "0123456789abcdef").inverted
	}

	static var typeByteCount: Int {
		return Self.bitWidth / 8
	}

	var byteCount: Int {
		return Self.typeByteCount
	}

	// MARK: Single Types
	/// Provides conversion if necessary via padding with 0's to a LongWord
	var longWord: LongWord {
		// technically, this can never happen unless a new UInt size is added beyond 64 (like UInt128 or something)
		let value = bitPattern
		if byteCount > LongWord.typeByteCount {
			let destMax = LongWord(LongWord.max)
			let anded = destMax & LongWord(value)
			return LongWord(anded)
		}
		return LongWord(value)
	}

	/// Provides conversion if necessary via padding with 0's to a Word, or clipping higher magnitude bits if the source
	/// is larger. Will result in a value of UInt32.max
	var word: Word {
		let value = bitPattern
		if byteCount > Word.typeByteCount {
			let destMax = LongWord(Word.max)
			let anded = destMax & LongWord(value)
			return Word(anded)
		}
		return Word(value)
	}

	/// Provides conversion if necessary via padding with 0's to a TwoByte, or clipping higher magnitude bits if the source
	/// is larger. Will result in a value of UInt16.max
	var twoByte: TwoByte {
		let value = bitPattern
		if byteCount > TwoByte.typeByteCount {
			let destMax = LongWord(TwoByte.max)
			let anded = destMax & LongWord(value)
			return TwoByte(anded)
		}
		return TwoByte(value)
	}

	/// Provides conversion if necessary via clipping higher magnitude bits if the source is larger than a Byte. Will
	/// result in a value of UInt8.max
	var byte: Byte {
		let value = bitPattern
		if byteCount > Byte.typeByteCount {
			let destMax = LongWord(Byte.max)
			let anded = destMax & LongWord(value)
			return Byte(anded)
		}
		return Byte(value)
	}

	// MARK: Sequence Types
	/// Provides conversion (if necessary) to a sequence of LongWord, retaining all bits in their respective position.
	var longWords: [LongWord] {
		var outArray = [LongWord]()
		let shiftSize = LongWord.typeByteCount * 8
		let strideStart = (Self.typeByteCount * 8) - shiftSize

		// shift by shiftsize every loop. start at stridestart, but only if stridestart
		// is >= 0. stridestart will be lower than 0 when outputting an array with a
		// larger bytesize type than the input value. ex, TwoByte -> [Word]
		var shift = strideStart >= 0 ? strideStart : 0
		// repeat while cuz we want this to run at least once
		repeat {
			// start on the further left section, then continue to the right
			outArray.append((self >> shift).longWord)
			shift -= shiftSize
		} while shift >= 0
		return outArray
	}

	/// Provides conversion (if necessary) to a sequence of Word, retaining all bits in their respective position.
	var wordsArray: [Word] {
		var outArray = [Word]()
		let shiftSize = Word.typeByteCount * 8
		let strideStart = (Self.typeByteCount * 8) - shiftSize

		// shift by shiftsize every loop. start at stridestart, but only if stridestart
		// is >= 0. stridestart will be lower than 0 when outputting an array with a
		// larger bytesize type than the input value. ex, TwoByte -> [Word]
		var shift = strideStart >= 0 ? strideStart : 0
		// repeat while cuz we want this to run at least once
		repeat {
			// start on the further left section, then continue to the right
			outArray.append((self >> shift).word)
			shift -= shiftSize
		} while shift >= 0
		return outArray
	}

	/// Provides conversion (if necessary) to a sequence of TwoByte, retaining all bits in their respective position.
	var twoBytes: [TwoByte] {
		var outArray = [TwoByte]()
		let shiftSize = TwoByte.typeByteCount * 8
		let strideStart = (Self.typeByteCount * 8) - shiftSize

		// shift by shiftsize every loop. start at stridestart, but only if stridestart
		// is >= 0. stridestart will be lower than 0 when outputting an array with a
		// larger bytesize type than the input value. ex, TwoByte -> [Word]
		var shift = strideStart >= 0 ? strideStart : 0
		// repeat while cuz we want this to run at least once
		repeat {
			// start on the further left section, then continue to the right
			outArray.append((self >> shift).twoByte)
			shift -= shiftSize
		} while shift >= 0
		return outArray
	}

	/// Provides conversion (if necessary) to a sequence of Byte, retaining all bits in their respective position.
	var bytes: [Byte] {
		var outArray = [Byte]()
		let shiftSize = Byte.typeByteCount * 8
		let strideStart = (Self.typeByteCount * 8) - shiftSize

		// shift by shiftsize every loop. start at stridestart, but only if stridestart
		// is >= 0. stridestart will be lower than 0 when outputting an array with a
		// larger bytesize type than the input value. ex, TwoByte -> [Word]
		var shift = strideStart
		// repeat while cuz we want this to run at least once
		repeat {
			// start on the further left section, then continue to the right
			outArray.append((self >> shift).byte)
			shift -= shiftSize
		} while shift >= 0
		return outArray
	}

	// MARK: String Output
	/// Representation of the value in a hex string.
	var hexString: String {
		let valueStr = String(self, radix: 16)
		let zeroCount = self.byteCount * 2 - valueStr.count
		let zeroPad = String((0..<zeroCount).map { _ in ("0") })

		return zeroPad + valueStr
	}

	var binaryString: String {
		(0..<bitWidth).reduce("") { "\(self[$1])" + $0 }
	}

	var description: String {
		return self.hexString
	}

	// MARK: Inits
	init(character: Character) throws {
		guard let ascii = character.asciiValue else { throw BinaryErrors.nonAsciiCharacter }
		self.init(ascii)
	}

	init(hexString: String) throws {
		let lowerCase = String(hexString.lowercased().utf8)
		guard lowerCase.count <= Self.typeByteCount * 2 else { throw BinaryErrors.wrongHexStringSize }
		guard lowerCase.rangeOfCharacter(from: Self.invalidHexCharacters) == nil else {
			throw BinaryErrors.containsNonHexCharacters
		}

		guard let outValue = Self(lowerCase, radix: 16) else { throw BinaryErrors.hexConversionFailed }
		self.init(outValue)
	}
}

public extension FixedWidthInteger {
	subscript(_ index: Int) -> UInt8 {
		precondition(index < bitWidth && index >= 0, "index (\(index)) invalid for type: \(type(of: self))")
		return UInt8((self >> index) & 1)
	}

	subscript(padded index: Int) -> UInt8 {
		precondition(index >= 0, "padded index (\(index)) invalid for type: \(type(of: self))")
		return UInt8((self >> index) & 1)
	}
}

public enum BinaryErrors: Error {
	case wrongHexStringSize
	case containsNonHexCharacters
	case hexConversionFailed
	case nonAsciiCharacter
}

public protocol BitRepper {
	associatedtype RepType: (BinaryInteger & BinaryFormattingProtocol)
	var bitPattern: RepType { get }
}

extension LongWord: BinaryFormattingProtocol, BitRepper {
	public typealias RepType = Self
	public var bitPattern: RepType { self }

	public init(withDoubleRepresentation double: Double) {
		self.init(double.bitPattern)
	}

	public init(withFloatRepresentation float: Float) {
		self.init(float.bitPattern)
	}
}

extension Word: BinaryFormattingProtocol, BitRepper {
	public typealias RepType = Self
	public var bitPattern: RepType { self }

	public init(withFloatRepresentation float: Float) {
		self.init(float.bitPattern)
	}
}

extension TwoByte: BinaryFormattingProtocol, BitRepper {
	public typealias RepType = Self
	public var bitPattern: RepType { self }
}

extension Byte: BinaryFormattingProtocol, BitRepper {
	public typealias RepType = Self
	public var bitPattern: RepType { self }
}

extension UInt: BinaryFormattingProtocol, BitRepper {
	public typealias RepType = Self
	public var bitPattern: RepType { self }
}

extension Int: BinaryFormattingProtocol, BitRepper {
	public typealias RepType = UInt
	public var bitPattern: RepType {
		RepType(bitPattern: self)
	}
}
extension Int8: BinaryFormattingProtocol, BitRepper {
	public typealias RepType = UInt8
	public var bitPattern: RepType {
		RepType(bitPattern: self)
	}
}
extension Int16: BinaryFormattingProtocol, BitRepper {
	public typealias RepType = UInt16
	public var bitPattern: RepType {
		RepType(bitPattern: self)
	}
}
extension Int32: BinaryFormattingProtocol, BitRepper {
	public typealias RepType = UInt32
	public var bitPattern: RepType {
		RepType(bitPattern: self)
	}
}
extension Int64: BinaryFormattingProtocol, BitRepper {
	public typealias RepType = UInt64
	public var bitPattern: RepType {
		RepType(bitPattern: self)
	}
}

extension Float: BitRepper {}
public extension Float {
	var bytes: [Byte] {
		Word(withFloatRepresentation: self).bytes
	}
}

extension Double: BitRepper {}
public extension Double {
	var bytes: [Byte] {
		LongWord(withDoubleRepresentation: self).bytes
	}
}
