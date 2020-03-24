//
//  SwiftyBinaryFormatterTests.swift
//  SwiftyBinaryFormatterTests
//
//  Created by Michael Redig on 7/1/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//
//swiftlint:disable large_tuple type_body_length

import XCTest
@testable import SwiftyBinaryFormatter

class SwiftyBinaryFormatterTypesTests: XCTestCase {

	// MARK: - Basics
	func testLongWord() {
		// 00110011 01010101 00000000 00001111  11001100 10101111 00000101 11111100
		let value = LongWord(3_698_862_736_813_262_332)

		let correctBytes: [Byte] = [51, 85, 0, 15, 204, 175, 5, 252]
		let bytes = value.bytes
		XCTAssertEqual(bytes, correctBytes)
		let correctByte: Byte = 252
		let byte = value.byte
		XCTAssertEqual(byte, correctByte)

		let correctTwoBytes: [TwoByte] = [13141, 15, 52399, 1532]
		let twoBytes = value.twoBytes
		XCTAssertEqual(twoBytes, correctTwoBytes)
		let correctTwoByte: TwoByte = 1532
		let twoByte = value.twoByte
		XCTAssertEqual(twoByte, correctTwoByte)

		let correctWords: [Word] = [861208591, 3434022396]
		let words = value.wordsArray
		XCTAssertEqual(words, correctWords)
		let correctWord: Word = 3434022396
		let word = value.word
		XCTAssertEqual(word, correctWord)

		let correctLongWords: [LongWord] = [3_698_862_736_813_262_332]
		let longWords = value.longWords
		XCTAssertEqual(longWords, correctLongWords)
		let correctLongWord: LongWord = 3_698_862_736_813_262_332
		let longWord = value.longWord
		XCTAssertEqual(longWord, correctLongWord)

		let byteCount = value.byteCount
		XCTAssertEqual(byteCount, 8)

		let correctHexValue = "3355000FCCAF05FC".lowercased()
		let hexValue = value.hexString
		XCTAssertEqual(hexValue, correctHexValue)

		let shortValue = LongWord(18)
		let correctHexValue2 = "0000000000000012"
		let hexValue2 = shortValue.hexString
		XCTAssertEqual(hexValue2, correctHexValue2)
		XCTAssertEqual(LongWord(0).hexString, "0000000000000000")

		XCTAssertEqual(value.hexString, value.description)
	}

	func testWord() {
		let value = Word(3_735_928_559)

		let correctBytes: [Byte] = [222, 173, 190, 239]
		let bytes = value.bytes
		XCTAssertEqual(bytes, correctBytes)
		let correctByte: Byte = 239
		let byte = value.byte
		XCTAssertEqual(byte, correctByte)

		let correctTwoBytes: [TwoByte] = [57005, 48879]
		let twoBytes = value.twoBytes
		XCTAssertEqual(twoBytes, correctTwoBytes)
		let correctTwoByte: TwoByte = 48879
		let twoByte = value.twoByte
		XCTAssertEqual(twoByte, correctTwoByte)

		let correctWords: [Word] = [3_735_928_559]
		let words = value.wordsArray
		XCTAssertEqual(words, correctWords)
		let correctWord: Word = 3_735_928_559
		let word = value.word
		XCTAssertEqual(word, correctWord)

		let correctLongWords: [LongWord] = [3_735_928_559]
		let longWords = value.longWords
		XCTAssertEqual(longWords, correctLongWords)
		let correctLongWord: LongWord = 3_735_928_559
		let longWord = value.longWord
		XCTAssertEqual(longWord, correctLongWord)

		let byteCount = value.byteCount
		XCTAssertEqual(byteCount, 4)

		let correctHexValue = "DEADBEEF".lowercased()
		let hexValue = value.hexString
		XCTAssertEqual(hexValue, correctHexValue)

		let shortValue = Word(18)
		let correctHexValue2 = "00000012"
		let hexValue2 = shortValue.hexString
		XCTAssertEqual(hexValue2, correctHexValue2)
		XCTAssertEqual(Word(0).hexString, "00000000")

		XCTAssertEqual(value.hexString, value.description)
	}

	func testTwoByte() {
		let value = TwoByte(57_005)

		let correctBytes: [Byte] = [222, 173]
		let bytes = value.bytes
		XCTAssertEqual(bytes, correctBytes)
		let correctByte: Byte = 173
		let byte = value.byte
		XCTAssertEqual(byte, correctByte)

		let correctTwoBytes: [TwoByte] = [57005]
		let twoBytes = value.twoBytes
		XCTAssertEqual(twoBytes, correctTwoBytes)
		let correctTwoByte: TwoByte = 57005
		let twoByte = value.twoByte
		XCTAssertEqual(twoByte, correctTwoByte)

		let correctWords: [Word] = [57005]
		let words = value.wordsArray
		XCTAssertEqual(words, correctWords)
		let correctWord: Word = 57005
		let word = value.word
		XCTAssertEqual(word, correctWord)

		let correctLongWords: [LongWord] = [57005]
		let longWords = value.longWords
		XCTAssertEqual(longWords, correctLongWords)
		let correctLongWord: LongWord = 57005
		let longWord = value.longWord
		XCTAssertEqual(longWord, correctLongWord)

		let byteCount = value.byteCount
		XCTAssertEqual(byteCount, 2)

		let correctHexValue = "DEAD".lowercased()
		let hexValue = value.hexString
		XCTAssertEqual(hexValue, correctHexValue)

		let shortValue = TwoByte(18)
		let correctHexValue2 = "0012"
		let hexValue2 = shortValue.hexString
		XCTAssertEqual(hexValue2, correctHexValue2)
		XCTAssertEqual(TwoByte(0).hexString, "0000")

		XCTAssertEqual(value.hexString, value.description)
	}

	func testByte() {
		let value = Byte(222)

		let correctBytes: [Byte] = [222]
		let bytes = value.bytes
		XCTAssertEqual(bytes, correctBytes)
		let correctByte: Byte = 222
		let byte = value.byte
		XCTAssertEqual(byte, correctByte)

		let correctTwoBytes: [TwoByte] = [222]
		let twoBytes = value.twoBytes
		XCTAssertEqual(twoBytes, correctTwoBytes)
		let correctTwoByte: TwoByte = 222
		let twoByte = value.twoByte
		XCTAssertEqual(twoByte, correctTwoByte)

		let correctWords: [Word] = [222]
		let words = value.wordsArray
		XCTAssertEqual(words, correctWords)
		let correctWord: Word = 222
		let word = value.word
		XCTAssertEqual(word, correctWord)

		let correctLongWords: [LongWord] = [222]
		let longWords = value.longWords
		XCTAssertEqual(longWords, correctLongWords)
		let correctLongWord: LongWord = 222
		let longWord = value.longWord
		XCTAssertEqual(longWord, correctLongWord)

		let byteCount = value.byteCount
		XCTAssertEqual(byteCount, 1)

		let correctHexValue = "DE".lowercased()
		let hexValue = value.hexString
		XCTAssertEqual(hexValue, correctHexValue)

		let shortValue = Byte(5)
		let correctHexValue2 = "05"
		let hexValue2 = shortValue.hexString
		XCTAssertEqual(hexValue2, correctHexValue2)
		XCTAssertEqual(Byte(0).hexString, "00")

		XCTAssertEqual(value.hexString, value.description)
	}

	// MARK: - Character Inits
	func testCharacterInits() {
		let character: Character = "t"

		do {
			let longWord = try LongWord(character: character)
			XCTAssertEqual(longWord, 116)

			let word = try Word(character: character)
			XCTAssertEqual(word, 116)

			let twoByte = try TwoByte(character: character)
			XCTAssertEqual(twoByte, 116)

			let byte = try Byte(character: character)
			XCTAssertEqual(byte, 116)
		} catch {
			XCTFail("failed to convert character to binary format: \(error)")
		}
		XCTAssertThrowsError(try LongWord(character: "π"))
	}

	// MARK: - Subscript
	func testIntegerSubscript() {
		let value1: UInt8 = 0b10101010
		for index in (0..<value1.bitWidth) {
			let bit = value1[index]
			let intendedBitValue: UInt8 = index.isMultiple(of: 2) ? 0 : 1
			XCTAssertEqual(bit, intendedBitValue)
		}

		for index in (0..<value1.bitWidth * 2) {
			let bit = value1[padded: index]
			let intendedBitValue: UInt8
			if index < value1.bitWidth {
				intendedBitValue = index.isMultiple(of: 2) ? 0 : 1
			} else {
				intendedBitValue = 0
			}

			XCTAssertEqual(bit, intendedBitValue)
		}
	}

	// MARK: - Hex String inits
	func hexStrings() -> (long: String, medium: String, mediumShort: String, short: String) {
		return ("DEADBEEFCAFE0000", "DEADBEEF", "DEAD", "DE")
	}

	func testLongWordHexStringInit() {
		let (longString, mediumString, mediumShortString, shortString) = hexStrings()

		do {
			let longWordLong = try LongWord(hexString: longString)
			XCTAssertEqual(longWordLong, 16045690984503050240)
			let longWordMedium = try LongWord(hexString: mediumString)
			XCTAssertEqual(longWordMedium, 3735928559)
			let longWordMediumShort = try LongWord(hexString: mediumShortString)
			XCTAssertEqual(longWordMediumShort, 57005)
			let longWordShort = try LongWord(hexString: shortString)
			XCTAssertEqual(longWordShort, 222)
		} catch {
			XCTFail("failed to convert hex string to binary format: \(error)")
		}
	}

	func testWordHexStringInit() {
		let (longString, mediumString, mediumShortString, shortString) = hexStrings()

		do {
			XCTAssertThrowsError(try Word(hexString: longString))
			let valueMedium = try Word(hexString: mediumString)
			XCTAssertEqual(valueMedium, 3735928559)
			let valueMediumShort = try Word(hexString: mediumShortString)
			XCTAssertEqual(valueMediumShort, 57005)
			let valueShort = try Word(hexString: shortString)
			XCTAssertEqual(valueShort, 222)
		} catch {
			XCTFail("failed to convert hex string to binary format: \(error)")
		}
	}

	func testTwoByteHexStringInit() {
		let (longString, mediumString, mediumShortString, shortString) = hexStrings()

		do {
			XCTAssertThrowsError(try TwoByte(hexString: longString))
			XCTAssertThrowsError(try TwoByte(hexString: mediumString))
			let valueMediumShort = try TwoByte(hexString: mediumShortString)
			XCTAssertEqual(valueMediumShort, 57005)
			let valueShort = try TwoByte(hexString: shortString)
			XCTAssertEqual(valueShort, 222)
		} catch {
			XCTFail("failed to convert hex string to binary format: \(error)")
		}
	}

	func testByteHexStringInit() {
		let (longString, mediumString, mediumShortString, shortString) = hexStrings()

		do {
			XCTAssertThrowsError(try Byte(hexString: longString))
			XCTAssertThrowsError(try Byte(hexString: mediumString))
			XCTAssertThrowsError(try Byte(hexString: mediumShortString))
			let valueShort = try Byte(hexString: shortString)
			XCTAssertEqual(valueShort, 222)
		} catch {
			XCTFail("failed to convert hex string to binary format: \(error)")
		}
	}

	func testHexStringInitErrors() {
		let invalidCharacter = "DEADBEEFXAFE"
		let invalidSize = "DEADBEEFCAFEDEADBEEFCAFE"

		do {
			_ = try LongWord(hexString: invalidCharacter)
		} catch BinaryErrors.containsNonHexCharacters {
			// it worked!
		} catch {
			XCTFail("wrong error: \(error)")
		}

		do {
			_ = try LongWord(hexString: invalidSize)
		} catch BinaryErrors.wrongHexStringSize {
			// it worked
		} catch {
			XCTFail("wrong error: \(error)")
		}
	}

	// MARK: - Float Inits
	func testFloatInits() {
		let floatBytes = Word(withFloatRepresentation: -1234.5)
		XCTAssertEqual(floatBytes.hexString, "C49A5000".lowercased())

		let longFloatBytes = LongWord(withFloatRepresentation: -1234.5)
		XCTAssertEqual(longFloatBytes.hexString, "00000000C49A5000".lowercased())

		let doubleBytes = LongWord(withDoubleRepresentation: 1234.5678)
		XCTAssertEqual(doubleBytes.hexString, "40934A456D5CFAAD".lowercased())

		let moreFloatBytes = Float(-1234.5).bytes
		XCTAssertEqual(Data(moreFloatBytes).hexString, "C49A5000".lowercased())

		let moreDoubleBytes = (1234.5678).bytes
		XCTAssertEqual(Data(moreDoubleBytes).hexString, "40934A456D5CFAAD".lowercased())
	}

	func testSignedSingleConversions() {
		let values: [Int8] = [1, 64, 127, -1, -64, -128]
		let bitReps: [UInt8] = [1, 64, 127, 255, 192, 128]

		let conversion = values.map { $0.byte }
		XCTAssertEqual(conversion, bitReps)

		let values32: [Int32] = [1, 64, 127, -1, -64, -128, -2147483648]
		let bitReps32: [UInt32] = [1, 64, 127, 4294967295, 4294967232, 4294967168, 2147483648]

		let conversion32 = values32.map { $0.word }
		XCTAssertEqual(conversion32, bitReps32)

		let values8_32: [Int8] = [1, 64, 127, -1, -64, -128]
		let bitReps8_32: [UInt32] = [1, 64, 127, 255, 192, 128]

		let conversion8_32 = values8_32.map { $0.word }
		XCTAssertEqual(conversion8_32, bitReps8_32)

		let values32_8: [Int32] = [1, 64, 127, -1, -64, -128, -2147483648, -256, -257]
		let bitReps32_8: [UInt8] = [1, 64, 127, 255, 192, 128, 0, 0, 255]

		let conversion32_8 = values32_8.map { $0.byte }
		XCTAssertEqual(conversion32_8, bitReps32_8)
	}

	func testSignedPluralConversions() {
		let values: [Int8] = [1, 64, 127, -1, -64, -128]
		let bitReps: [[UInt8]] = [[1], [64], [127], [255], [192], [128]]

		let conversion = values.map { $0.bytes }
		XCTAssertEqual(conversion, bitReps)

		let values32: [Int32] = [1, 64, 127, -1, -64, -128, -2147483648]
		let bitReps32: [[UInt32]] = [[1], [64], [127], [4294967295], [4294967232], [4294967168], [2147483648]]

		let conversion32 = values32.map { $0.wordsArray }
		XCTAssertEqual(conversion32, bitReps32)

		let values8_32: [Int8] = [1, 64, 127, -1, -64, -128]
		let bitReps8_32: [[UInt32]] = [[1], [64], [127], [255], [192], [128]]

		let conversion8_32 = values8_32.map { $0.wordsArray }
		XCTAssertEqual(conversion8_32, bitReps8_32)

		let values32_8: [Int32] = [1,
								   64,
								   127,
								   -1,
								   -64,
								   -128,
								   -2147483648,
								   -256,
								   -257]
		let bitReps32_8: [[UInt8]] = [[0, 0, 0, 1],
									  [0, 0, 0, 64],
									  [0, 0, 0, 127],
									  [255, 255, 255, 255],
									  [255, 255, 255, 192],
									  [255, 255, 255, 128],
									  [128, 0, 0, 0],
									  [255, 255, 255, 0],
									  [255, 255, 254, 255]]

		let conversion32_8 = values32_8.map { $0.bytes }
		XCTAssertEqual(conversion32_8, bitReps32_8)
	}
}
