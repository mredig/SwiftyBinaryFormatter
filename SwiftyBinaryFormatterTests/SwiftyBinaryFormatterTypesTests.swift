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
		let value = BinaryFormatter.LongWord(3_698_862_736_813_262_332)

		let correctBytes: [BinaryFormatter.Byte] = [51, 85, 0, 15, 204, 175, 5, 252]
		let bytes = value.bytes
		XCTAssertEqual(bytes, correctBytes)
		let correctByte: BinaryFormatter.Byte = 252
		let byte = value.byte
		XCTAssertEqual(byte, correctByte)

		let correctTwoBytes: [BinaryFormatter.TwoByte] = [13141, 15, 52399, 1532]
		let twoBytes = value.twoBytes
		XCTAssertEqual(twoBytes, correctTwoBytes)
		let correctTwoByte: BinaryFormatter.TwoByte = 1532
		let twoByte = value.twoByte
		XCTAssertEqual(twoByte, correctTwoByte)

		let correctWords: [BinaryFormatter.Word] = [861208591, 3434022396]
		let words = value.wordsArray
		XCTAssertEqual(words, correctWords)
		let correctWord: BinaryFormatter.Word = 3434022396
		let word = value.word
		XCTAssertEqual(word, correctWord)

		let correctLongWords: [BinaryFormatter.LongWord] = [3_698_862_736_813_262_332]
		let longWords = value.longWords
		XCTAssertEqual(longWords, correctLongWords)
		let correctLongWord: BinaryFormatter.LongWord = 3_698_862_736_813_262_332
		let longWord = value.longWord
		XCTAssertEqual(longWord, correctLongWord)

		let byteCount = value.byteCount
		XCTAssertEqual(byteCount, 8)

		let correctHexValue = "3355000FCCAF05FC".lowercased()
		let hexValue = value.hexString
		XCTAssertEqual(hexValue, correctHexValue)

		let shortValue = BinaryFormatter.LongWord(18)
		let correctHexValue2 = "0000000000000012"
		let hexValue2 = shortValue.hexString
		XCTAssertEqual(hexValue2, correctHexValue2)
		XCTAssertEqual(BinaryFormatter.LongWord(0).hexString, "0000000000000000")

		XCTAssertEqual(value.hexString, value.description)
	}

	func testWord() {
		let value = BinaryFormatter.Word(3_735_928_559)

		let correctBytes: [BinaryFormatter.Byte] = [222, 173, 190, 239]
		let bytes = value.bytes
		XCTAssertEqual(bytes, correctBytes)
		let correctByte: BinaryFormatter.Byte = 239
		let byte = value.byte
		XCTAssertEqual(byte, correctByte)

		let correctTwoBytes: [BinaryFormatter.TwoByte] = [57005, 48879]
		let twoBytes = value.twoBytes
		XCTAssertEqual(twoBytes, correctTwoBytes)
		let correctTwoByte: BinaryFormatter.TwoByte = 48879
		let twoByte = value.twoByte
		XCTAssertEqual(twoByte, correctTwoByte)

		let correctWords: [BinaryFormatter.Word] = [3_735_928_559]
		let words = value.wordsArray
		XCTAssertEqual(words, correctWords)
		let correctWord: BinaryFormatter.Word = 3_735_928_559
		let word = value.word
		XCTAssertEqual(word, correctWord)

		let correctLongWords: [BinaryFormatter.LongWord] = [3_735_928_559]
		let longWords = value.longWords
		XCTAssertEqual(longWords, correctLongWords)
		let correctLongWord: BinaryFormatter.LongWord = 3_735_928_559
		let longWord = value.longWord
		XCTAssertEqual(longWord, correctLongWord)

		let byteCount = value.byteCount
		XCTAssertEqual(byteCount, 4)

		let correctHexValue = "DEADBEEF".lowercased()
		let hexValue = value.hexString
		XCTAssertEqual(hexValue, correctHexValue)

		let shortValue = BinaryFormatter.Word(18)
		let correctHexValue2 = "00000012"
		let hexValue2 = shortValue.hexString
		XCTAssertEqual(hexValue2, correctHexValue2)
		XCTAssertEqual(BinaryFormatter.Word(0).hexString, "00000000")

		XCTAssertEqual(value.hexString, value.description)
	}

	func testTwoByte() {
		let value = BinaryFormatter.TwoByte(57_005)

		let correctBytes: [BinaryFormatter.Byte] = [222, 173]
		let bytes = value.bytes
		XCTAssertEqual(bytes, correctBytes)
		let correctByte: BinaryFormatter.Byte = 173
		let byte = value.byte
		XCTAssertEqual(byte, correctByte)

		let correctTwoBytes: [BinaryFormatter.TwoByte] = [57005]
		let twoBytes = value.twoBytes
		XCTAssertEqual(twoBytes, correctTwoBytes)
		let correctTwoByte: BinaryFormatter.TwoByte = 57005
		let twoByte = value.twoByte
		XCTAssertEqual(twoByte, correctTwoByte)

		let correctWords: [BinaryFormatter.Word] = [57005]
		let words = value.wordsArray
		XCTAssertEqual(words, correctWords)
		let correctWord: BinaryFormatter.Word = 57005
		let word = value.word
		XCTAssertEqual(word, correctWord)

		let correctLongWords: [BinaryFormatter.LongWord] = [57005]
		let longWords = value.longWords
		XCTAssertEqual(longWords, correctLongWords)
		let correctLongWord: BinaryFormatter.LongWord = 57005
		let longWord = value.longWord
		XCTAssertEqual(longWord, correctLongWord)

		let byteCount = value.byteCount
		XCTAssertEqual(byteCount, 2)

		let correctHexValue = "DEAD".lowercased()
		let hexValue = value.hexString
		XCTAssertEqual(hexValue, correctHexValue)

		let shortValue = BinaryFormatter.TwoByte(18)
		let correctHexValue2 = "0012"
		let hexValue2 = shortValue.hexString
		XCTAssertEqual(hexValue2, correctHexValue2)
		XCTAssertEqual(BinaryFormatter.TwoByte(0).hexString, "0000")

		XCTAssertEqual(value.hexString, value.description)
	}

	func testByte() {
		let value = BinaryFormatter.Byte(222)

		let correctBytes: [BinaryFormatter.Byte] = [222]
		let bytes = value.bytes
		XCTAssertEqual(bytes, correctBytes)
		let correctByte: BinaryFormatter.Byte = 222
		let byte = value.byte
		XCTAssertEqual(byte, correctByte)

		let correctTwoBytes: [BinaryFormatter.TwoByte] = [222]
		let twoBytes = value.twoBytes
		XCTAssertEqual(twoBytes, correctTwoBytes)
		let correctTwoByte: BinaryFormatter.TwoByte = 222
		let twoByte = value.twoByte
		XCTAssertEqual(twoByte, correctTwoByte)

		let correctWords: [BinaryFormatter.Word] = [222]
		let words = value.wordsArray
		XCTAssertEqual(words, correctWords)
		let correctWord: BinaryFormatter.Word = 222
		let word = value.word
		XCTAssertEqual(word, correctWord)

		let correctLongWords: [BinaryFormatter.LongWord] = [222]
		let longWords = value.longWords
		XCTAssertEqual(longWords, correctLongWords)
		let correctLongWord: BinaryFormatter.LongWord = 222
		let longWord = value.longWord
		XCTAssertEqual(longWord, correctLongWord)

		let byteCount = value.byteCount
		XCTAssertEqual(byteCount, 1)

		let correctHexValue = "DE".lowercased()
		let hexValue = value.hexString
		XCTAssertEqual(hexValue, correctHexValue)

		let shortValue = BinaryFormatter.Byte(5)
		let correctHexValue2 = "05"
		let hexValue2 = shortValue.hexString
		XCTAssertEqual(hexValue2, correctHexValue2)
		XCTAssertEqual(BinaryFormatter.Byte(0).hexString, "00")

		XCTAssertEqual(value.hexString, value.description)
	}

	// MARK: - Character Inits
	func testCharacterInits() {
		let character: Character = "t"

		do {
			let longWord = try BinaryFormatter.LongWord(character: character)
			XCTAssertEqual(longWord, 116)

			let word = try BinaryFormatter.Word(character: character)
			XCTAssertEqual(word, 116)

			let twoByte = try BinaryFormatter.TwoByte(character: character)
			XCTAssertEqual(twoByte, 116)

			let byte = try BinaryFormatter.Byte(character: character)
			XCTAssertEqual(byte, 116)
		} catch {
			XCTFail("failed to convert character to binary format: \(error)")
		}
		XCTAssertThrowsError(try BinaryFormatter.LongWord(character: "π"))
	}

	// MARK: - Hex String inits
	func hexStrings() -> (long: String, medium: String, mediumShort: String, short: String) {
		return ("DEADBEEFCAFE0000", "DEADBEEF", "DEAD", "DE")
	}

	func testLongWordHexStringInit() {
		let (longString, mediumString, mediumShortString, shortString) = hexStrings()

		do {
			let longWordLong = try BinaryFormatter.LongWord(hexString: longString)
			XCTAssertEqual(longWordLong, 16045690984503050240)
			let longWordMedium = try BinaryFormatter.LongWord(hexString: mediumString)
			XCTAssertEqual(longWordMedium, 3735928559)
			let longWordMediumShort = try BinaryFormatter.LongWord(hexString: mediumShortString)
			XCTAssertEqual(longWordMediumShort, 57005)
			let longWordShort = try BinaryFormatter.LongWord(hexString: shortString)
			XCTAssertEqual(longWordShort, 222)
		} catch {
			XCTFail("failed to convert hex string to binary format: \(error)")
		}
	}

	func testWordHexStringInit() {
		let (longString, mediumString, mediumShortString, shortString) = hexStrings()

		do {
			XCTAssertThrowsError(try BinaryFormatter.Word(hexString: longString))
			let valueMedium = try BinaryFormatter.Word(hexString: mediumString)
			XCTAssertEqual(valueMedium, 3735928559)
			let valueMediumShort = try BinaryFormatter.Word(hexString: mediumShortString)
			XCTAssertEqual(valueMediumShort, 57005)
			let valueShort = try BinaryFormatter.Word(hexString: shortString)
			XCTAssertEqual(valueShort, 222)
		} catch {
			XCTFail("failed to convert hex string to binary format: \(error)")
		}
	}

	func testTwoByteHexStringInit() {
		let (longString, mediumString, mediumShortString, shortString) = hexStrings()

		do {
			XCTAssertThrowsError(try BinaryFormatter.TwoByte(hexString: longString))
			XCTAssertThrowsError(try BinaryFormatter.TwoByte(hexString: mediumString))
			let valueMediumShort = try BinaryFormatter.TwoByte(hexString: mediumShortString)
			XCTAssertEqual(valueMediumShort, 57005)
			let valueShort = try BinaryFormatter.TwoByte(hexString: shortString)
			XCTAssertEqual(valueShort, 222)
		} catch {
			XCTFail("failed to convert hex string to binary format: \(error)")
		}
	}

	func testByteHexStringInit() {
		let (longString, mediumString, mediumShortString, shortString) = hexStrings()

		do {
			XCTAssertThrowsError(try BinaryFormatter.Byte(hexString: longString))
			XCTAssertThrowsError(try BinaryFormatter.Byte(hexString: mediumString))
			XCTAssertThrowsError(try BinaryFormatter.Byte(hexString: mediumShortString))
			let valueShort = try BinaryFormatter.Byte(hexString: shortString)
			XCTAssertEqual(valueShort, 222)
		} catch {
			XCTFail("failed to convert hex string to binary format: \(error)")
		}
	}

	func testHexStringInitErrors() {
		let invalidCharacter = "DEADBEEFXAFE"
		let invalidSize = "DEADBEEFCAFEDEADBEEFCAFE"

		do {
			_ = try BinaryFormatter.LongWord(hexString: invalidCharacter)
		} catch BinaryErrors.containsNonHexCharacters {
			// it worked!
		} catch {
			XCTFail("wrong error: \(error)")
		}

		do {
			_ = try BinaryFormatter.LongWord(hexString: invalidSize)
		} catch BinaryErrors.wrongHexStringSize {
			// it worked
		} catch {
			XCTFail("wrong error: \(error)")
		}
	}

	// MARK: - Float Inits
	func testFloatInits() {
		let floatBytes = BinaryFormatter.Word(withFloatRepresentation: -1234.5)
		XCTAssertEqual(floatBytes.hexString, "C49A5000".lowercased())

		let longFloatBytes = BinaryFormatter.LongWord(withFloatRepresentation: -1234.5)
		XCTAssertEqual(longFloatBytes.hexString, "00000000C49A5000".lowercased())

		let doubleBytes = BinaryFormatter.LongWord(withDoubleRepresentation: 1234.5678)
		XCTAssertEqual(doubleBytes.hexString, "40934A456D5CFAAD".lowercased())
	}
}
