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
		let value = Data.LongWord(3_698_862_736_813_262_332)

		let correctBytes: [Data.Byte] = [51, 85, 0, 15, 204, 175, 5, 252]
		let bytes = value.bytes
		XCTAssertEqual(bytes, correctBytes)
		let correctByte: Data.Byte = 252
		let byte = value.byte
		XCTAssertEqual(byte, correctByte)

		let correctTwoBytes: [Data.TwoByte] = [13141, 15, 52399, 1532]
		let twoBytes = value.twoBytes
		XCTAssertEqual(twoBytes, correctTwoBytes)
		let correctTwoByte: Data.TwoByte = 1532
		let twoByte = value.twoByte
		XCTAssertEqual(twoByte, correctTwoByte)

		let correctWords: [Data.Word] = [861208591, 3434022396]
		let words = value.wordsArray
		XCTAssertEqual(words, correctWords)
		let correctWord: Data.Word = 3434022396
		let word = value.word
		XCTAssertEqual(word, correctWord)

		let correctLongWords: [Data.LongWord] = [3_698_862_736_813_262_332]
		let longWords = value.longWords
		XCTAssertEqual(longWords, correctLongWords)
		let correctLongWord: Data.LongWord = 3_698_862_736_813_262_332
		let longWord = value.longWord
		XCTAssertEqual(longWord, correctLongWord)

		let byteCount = value.byteCount
		XCTAssertEqual(byteCount, 8)

		let correctHexValue = "3355000FCCAF05FC".lowercased()
		let hexValue = value.hexString
		XCTAssertEqual(hexValue, correctHexValue)

		let shortValue = Data.LongWord(18)
		let correctHexValue2 = "0000000000000012"
		let hexValue2 = shortValue.hexString
		XCTAssertEqual(hexValue2, correctHexValue2)
		XCTAssertEqual(Data.LongWord(0).hexString, "0000000000000000")

		XCTAssertEqual(value.hexString, value.description)
	}

	func testWord() {
		let value = Data.Word(3_735_928_559)

		let correctBytes: [Data.Byte] = [222, 173, 190, 239]
		let bytes = value.bytes
		XCTAssertEqual(bytes, correctBytes)
		let correctByte: Data.Byte = 239
		let byte = value.byte
		XCTAssertEqual(byte, correctByte)

		let correctTwoBytes: [Data.TwoByte] = [57005, 48879]
		let twoBytes = value.twoBytes
		XCTAssertEqual(twoBytes, correctTwoBytes)
		let correctTwoByte: Data.TwoByte = 48879
		let twoByte = value.twoByte
		XCTAssertEqual(twoByte, correctTwoByte)

		let correctWords: [Data.Word] = [3_735_928_559]
		let words = value.wordsArray
		XCTAssertEqual(words, correctWords)
		let correctWord: Data.Word = 3_735_928_559
		let word = value.word
		XCTAssertEqual(word, correctWord)

		let correctLongWords: [Data.LongWord] = [3_735_928_559]
		let longWords = value.longWords
		XCTAssertEqual(longWords, correctLongWords)
		let correctLongWord: Data.LongWord = 3_735_928_559
		let longWord = value.longWord
		XCTAssertEqual(longWord, correctLongWord)

		let byteCount = value.byteCount
		XCTAssertEqual(byteCount, 4)

		let correctHexValue = "DEADBEEF".lowercased()
		let hexValue = value.hexString
		XCTAssertEqual(hexValue, correctHexValue)

		let shortValue = Data.Word(18)
		let correctHexValue2 = "00000012"
		let hexValue2 = shortValue.hexString
		XCTAssertEqual(hexValue2, correctHexValue2)
		XCTAssertEqual(Data.Word(0).hexString, "00000000")

		XCTAssertEqual(value.hexString, value.description)
	}

	func testTwoByte() {
		let value = Data.TwoByte(57_005)

		let correctBytes: [Data.Byte] = [222, 173]
		let bytes = value.bytes
		XCTAssertEqual(bytes, correctBytes)
		let correctByte: Data.Byte = 173
		let byte = value.byte
		XCTAssertEqual(byte, correctByte)

		let correctTwoBytes: [Data.TwoByte] = [57005]
		let twoBytes = value.twoBytes
		XCTAssertEqual(twoBytes, correctTwoBytes)
		let correctTwoByte: Data.TwoByte = 57005
		let twoByte = value.twoByte
		XCTAssertEqual(twoByte, correctTwoByte)

		let correctWords: [Data.Word] = [57005]
		let words = value.wordsArray
		XCTAssertEqual(words, correctWords)
		let correctWord: Data.Word = 57005
		let word = value.word
		XCTAssertEqual(word, correctWord)

		let correctLongWords: [Data.LongWord] = [57005]
		let longWords = value.longWords
		XCTAssertEqual(longWords, correctLongWords)
		let correctLongWord: Data.LongWord = 57005
		let longWord = value.longWord
		XCTAssertEqual(longWord, correctLongWord)

		let byteCount = value.byteCount
		XCTAssertEqual(byteCount, 2)

		let correctHexValue = "DEAD".lowercased()
		let hexValue = value.hexString
		XCTAssertEqual(hexValue, correctHexValue)

		let shortValue = Data.TwoByte(18)
		let correctHexValue2 = "0012"
		let hexValue2 = shortValue.hexString
		XCTAssertEqual(hexValue2, correctHexValue2)
		XCTAssertEqual(Data.TwoByte(0).hexString, "0000")

		XCTAssertEqual(value.hexString, value.description)
	}

	func testByte() {
		let value = Data.Byte(222)

		let correctBytes: [Data.Byte] = [222]
		let bytes = value.bytes
		XCTAssertEqual(bytes, correctBytes)
		let correctByte: Data.Byte = 222
		let byte = value.byte
		XCTAssertEqual(byte, correctByte)

		let correctTwoBytes: [Data.TwoByte] = [222]
		let twoBytes = value.twoBytes
		XCTAssertEqual(twoBytes, correctTwoBytes)
		let correctTwoByte: Data.TwoByte = 222
		let twoByte = value.twoByte
		XCTAssertEqual(twoByte, correctTwoByte)

		let correctWords: [Data.Word] = [222]
		let words = value.wordsArray
		XCTAssertEqual(words, correctWords)
		let correctWord: Data.Word = 222
		let word = value.word
		XCTAssertEqual(word, correctWord)

		let correctLongWords: [Data.LongWord] = [222]
		let longWords = value.longWords
		XCTAssertEqual(longWords, correctLongWords)
		let correctLongWord: Data.LongWord = 222
		let longWord = value.longWord
		XCTAssertEqual(longWord, correctLongWord)

		let byteCount = value.byteCount
		XCTAssertEqual(byteCount, 1)

		let correctHexValue = "DE".lowercased()
		let hexValue = value.hexString
		XCTAssertEqual(hexValue, correctHexValue)

		let shortValue = Data.Byte(5)
		let correctHexValue2 = "05"
		let hexValue2 = shortValue.hexString
		XCTAssertEqual(hexValue2, correctHexValue2)
		XCTAssertEqual(Data.Byte(0).hexString, "00")

		XCTAssertEqual(value.hexString, value.description)
	}

	// MARK: - Character Inits
	func testCharacterInits() {
		let character: Character = "t"

		do {
			let longWord = try Data.LongWord(character: character)
			XCTAssertEqual(longWord, 116)

			let word = try Data.Word(character: character)
			XCTAssertEqual(word, 116)

			let twoByte = try Data.TwoByte(character: character)
			XCTAssertEqual(twoByte, 116)

			let byte = try Data.Byte(character: character)
			XCTAssertEqual(byte, 116)
		} catch {
			XCTFail("failed to convert character to binary format: \(error)")
		}
		XCTAssertThrowsError(try Data.LongWord(character: "π"))
	}

	// MARK: - Hex String inits
	func hexStrings() -> (long: String, medium: String, mediumShort: String, short: String) {
		return ("DEADBEEFCAFE0000", "DEADBEEF", "DEAD", "DE")
	}

	func testLongWordHexStringInit() {
		let (longString, mediumString, mediumShortString, shortString) = hexStrings()

		do {
			let longWordLong = try Data.LongWord(hexString: longString)
			XCTAssertEqual(longWordLong, 16045690984503050240)
			let longWordMedium = try Data.LongWord(hexString: mediumString)
			XCTAssertEqual(longWordMedium, 3735928559)
			let longWordMediumShort = try Data.LongWord(hexString: mediumShortString)
			XCTAssertEqual(longWordMediumShort, 57005)
			let longWordShort = try Data.LongWord(hexString: shortString)
			XCTAssertEqual(longWordShort, 222)
		} catch {
			XCTFail("failed to convert hex string to binary format: \(error)")
		}
	}

	func testWordHexStringInit() {
		let (longString, mediumString, mediumShortString, shortString) = hexStrings()

		do {
			XCTAssertThrowsError(try Data.Word(hexString: longString))
			let valueMedium = try Data.Word(hexString: mediumString)
			XCTAssertEqual(valueMedium, 3735928559)
			let valueMediumShort = try Data.Word(hexString: mediumShortString)
			XCTAssertEqual(valueMediumShort, 57005)
			let valueShort = try Data.Word(hexString: shortString)
			XCTAssertEqual(valueShort, 222)
		} catch {
			XCTFail("failed to convert hex string to binary format: \(error)")
		}
	}

	func testTwoByteHexStringInit() {
		let (longString, mediumString, mediumShortString, shortString) = hexStrings()

		do {
			XCTAssertThrowsError(try Data.TwoByte(hexString: longString))
			XCTAssertThrowsError(try Data.TwoByte(hexString: mediumString))
			let valueMediumShort = try Data.TwoByte(hexString: mediumShortString)
			XCTAssertEqual(valueMediumShort, 57005)
			let valueShort = try Data.TwoByte(hexString: shortString)
			XCTAssertEqual(valueShort, 222)
		} catch {
			XCTFail("failed to convert hex string to binary format: \(error)")
		}
	}

	func testByteHexStringInit() {
		let (longString, mediumString, mediumShortString, shortString) = hexStrings()

		do {
			XCTAssertThrowsError(try Data.Byte(hexString: longString))
			XCTAssertThrowsError(try Data.Byte(hexString: mediumString))
			XCTAssertThrowsError(try Data.Byte(hexString: mediumShortString))
			let valueShort = try Data.Byte(hexString: shortString)
			XCTAssertEqual(valueShort, 222)
		} catch {
			XCTFail("failed to convert hex string to binary format: \(error)")
		}
	}

	func testHexStringInitErrors() {
		let invalidCharacter = "DEADBEEFXAFE"
		let invalidSize = "DEADBEEFCAFEDEADBEEFCAFE"

		do {
			_ = try Data.LongWord(hexString: invalidCharacter)
		} catch BinaryErrors.containsNonHexCharacters {
			// it worked!
		} catch {
			XCTFail("wrong error: \(error)")
		}

		do {
			_ = try Data.LongWord(hexString: invalidSize)
		} catch BinaryErrors.wrongHexStringSize {
			// it worked
		} catch {
			XCTFail("wrong error: \(error)")
		}
	}

	// MARK: - Float Inits
	func testFloatInits() {
		let floatBytes = Data.Word(withFloatRepresentation: -1234.5)
		XCTAssertEqual(floatBytes.hexString, "C49A5000".lowercased())

		let longFloatBytes = Data.LongWord(withFloatRepresentation: -1234.5)
		XCTAssertEqual(longFloatBytes.hexString, "00000000C49A5000".lowercased())

		let doubleBytes = Data.LongWord(withDoubleRepresentation: 1234.5678)
		XCTAssertEqual(doubleBytes.hexString, "40934A456D5CFAAD".lowercased())
	}
}
