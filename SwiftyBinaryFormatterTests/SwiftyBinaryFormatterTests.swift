//
//  SwiftyBinaryFormatterTests.swift
//  SwiftyBinaryFormatterTests
//
//  Created by Michael Redig on 7/1/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//
//swiftlint:disable force_try identifier_name

import XCTest
@testable import SwiftyBinaryFormatter

class SwiftyBinaryFormatterTests: XCTestCase {

	/// Not meant to be run every time a test is run, but is used to generate the random.bytes file. Hopefully only
	/// needs to have been run once, but keeping the source code around in the event more tests are needed
	private func generateRandomTestBytes() throws {
		var size = 512 * 512

		var output = ""
		while size > 0 {
			let number = LongWord.random(in: 0...LongWord.max)
			let bytes = number.bytes
			let potentialByteCount = [0,4,6,7] // random number of how many bytes to remove, leaving the result with 8, 4, 2, or 1 bytes as a result
			let firstNonZeroIndex = potentialByteCount.randomElement() ?? 1
			let validBytes = bytes[firstNonZeroIndex..<bytes.count]
			let hex = validBytes.map { $0.hexString }.joined(separator: "")
			output += "\(hex)\n"

			size -= validBytes.count
		}

		let outputFile = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("random").appendingPathExtension("bytes")
		try output.write(to: outputFile, atomically: true, encoding: .utf8)
		print(outputFile)
	}

	// MARK: - test binary formatter inits
	func testInits() {
		let testData: [BinaryFormattingProtocol] = [Word(238974), TwoByte(55653)]
		let formatter = Data(testData)

		let confirmedData = testData.reduce(Data()) { $0 + $1.bytes }
		XCTAssertEqual(formatter, confirmedData)

		let blpSeq: [BinaryFormattingProtocol] = [Byte(1), Byte(2), Byte(3), Byte(4)]
		let formatter2 = Data(blpSeq)
		let uInt8: [UInt8] = [1, 2, 3, 4]
		let data2 = Data(uInt8)
		XCTAssertEqual(formatter2, data2)
	}

	func testHexString() {
		let dead = try! TwoByte(hexString: "Dead")
		let beef = try! TwoByte(hexString: "Beef")
		let cafe = try! TwoByte(hexString: "cafe")

		var formatter = Data()
		formatter.append(contentsOf: [dead, beef])
		formatter.append(cafe)

		var formatter2 = Data()
		formatter2.append(dead)
		formatter2.append(contentsOf: [beef, cafe])

		XCTAssertEqual(formatter.hexString, "deadbeefcafe")
		XCTAssertEqual(formatter.hexString, formatter2.hexString)
	}

	/// Also tests ability to use BinaryFormatter. While deprecated, can at least know that it works
	func testByteCount() {
		let de = try! Byte(hexString: "De")
		let ad = try! Byte(hexString: "ad")
		let beefcafe = try! Word(hexString: "Beefcafe")

		let formatter = BinaryFormatter(data: [de, ad, beefcafe])
		XCTAssertEqual(formatter.byteCount, 6)

		var formatter2 = Data()
		formatter2.append(de)
		formatter2.append(contentsOf: [ad, beefcafe])
		XCTAssertEqual(formatter2.count, 6)
		formatter2.append(formatter: formatter)
		XCTAssertEqual(formatter2.count, 12)
	}

	func testSubscript() {
		let de = try! Byte(hexString: "De")
		let ad = try! Byte(hexString: "ad")
		let dead = try! TwoByte(hexString: "Dead")
		let beefcafe = try! Word(hexString: "Beefcafe")

		var formatter = Data([de, ad, beefcafe])
		XCTAssertEqual(formatter[0], de)

		formatter[0] = ad
		XCTAssertEqual(formatter[0], ad)
		formatter[0] = de

		let formatter2 = Data([dead, beefcafe])
		XCTAssertEqual(formatter, formatter2)
	}

	/// Also tests ability to use BinaryFormatter. While deprecated, can at least know that it works
	func testAppendFormatter() {
		let dead = try! TwoByte(hexString: "Dead")
		let beef = try! TwoByte(hexString: "Beef")
		let cafe = try! TwoByte(hexString: "cafe")

		var formatter = Data()
		formatter.append(contentsOf: [dead, beef])
		formatter.append(cafe)

		var formatter2 = BinaryFormatter()
		formatter2.append(element: cafe)
		formatter2.append(sequence: [beef, dead])

		formatter.append(formatter: formatter2)
		XCTAssertEqual(formatter.hexString, "deadbeefcafecafebeefdead")
	}

	func testRenderingData() throws {
		guard let testBytes = Bundle(for: type(of: self)).url(forResource: "random", withExtension: "bytes") else { return }
		let separatedHex = (try String(contentsOf: testBytes)).split(separator: "\n").map { String($0) }

		let start = CFAbsoluteTimeGetCurrent()
		var formatter = Data()
		for hexStr in separatedHex {
			let value: BinaryFormattingProtocol
			switch hexStr.count {
			case 2: //1
				// byte
				value = try Byte(hexString: hexStr)
			case 4: //2
				// twobyte
				value = try TwoByte(hexString: hexStr)
			case 8: //4
				// word
				value = try Word(hexString: hexStr)
			case 16: //8
				// longword
				value = try LongWord(hexString: hexStr)
			default:
				XCTFail("Invalid hex string: \(hexStr)")
				return
			}
			formatter.append(value)
		}

		let lap = CFAbsoluteTimeGetCurrent()

		let longHex = Array(separatedHex.joined(separator: ""))
		var compareData = Data()
		var accumulator = ""
		let theAppender = {
			let value = UInt8(accumulator, radix: 16)!
			accumulator = ""
			compareData.append(value)
		}

		for (index, char) in longHex.enumerated() {
			if index > 0 && index.isMultiple(of: 2) {
				theAppender()
			}
			accumulator.append(char)
		}
		theAppender() //need to run one additional time
		let finish = CFAbsoluteTimeGetCurrent()

		print("BinaryFormatting time: \(lap - start)")
		print("Old Data time: \(finish - lap)")
		print("BinaryForatting takes \((lap - start) / (finish - lap)) times as long as Old Data method.")

		XCTAssertEqual(formatter, compareData)
	}

	func testBinaryString() {
		let values8: [UInt8] = [0, 1, 2, 4, 8, 10, 255]
		let binStrs8 = values8.map { $0.binaryString }

		let correctBinStrs8 = ["00000000", "00000001", "00000010", "00000100", "00001000", "00001010", "11111111"]
		XCTAssertEqual(binStrs8, correctBinStrs8)

		let values16: [UInt16] = [0, 1, 2, 4, 8, 10, 255, 256, 65535]
		let binStrs16 = values16.map { $0.binaryString }

		let correctBinStrs16 = ["0000000000000000",
								"0000000000000001",
								"0000000000000010",
								"0000000000000100",
								"0000000000001000",
								"0000000000001010",
								"0000000011111111",
								"0000000100000000",
								"1111111111111111"]
		XCTAssertEqual(binStrs16, correctBinStrs16)


		// will fail on a 32 bit system
		let values: [UInt] = [0, 1, 2, 4, 8, 10, 255, 256, 65535]
		let binStrs = values.map { $0.binaryString }

		let correctBinStrs = ["0000000000000000000000000000000000000000000000000000000000000000",
							  "0000000000000000000000000000000000000000000000000000000000000001",
							  "0000000000000000000000000000000000000000000000000000000000000010",
							  "0000000000000000000000000000000000000000000000000000000000000100",
							  "0000000000000000000000000000000000000000000000000000000000001000",
							  "0000000000000000000000000000000000000000000000000000000000001010",
							  "0000000000000000000000000000000000000000000000000000000011111111",
							  "0000000000000000000000000000000000000000000000000000000100000000",
							  "0000000000000000000000000000000000000000000000001111111111111111"]
		XCTAssertEqual(binStrs, correctBinStrs)

		let valuesI8: [Int8] = [0, 1, 2, 4, 8, 10, 127, -1, -10, -128]
		let binStrsI8 = valuesI8.map { $0.binaryString }

		let correctBinStrsI8 = ["00000000",
								"00000001",
								"00000010",
								"00000100",
								"00001000",
								"00001010",
								"01111111",
								"11111111",
								"11110110",
								"10000000"]
		XCTAssertEqual(binStrsI8, correctBinStrsI8)


		let valuesI16: [Int16] = [0, 1, 2, 4, 8, 10, 255, 256, -1, -32768]
		let binStrsI16 = valuesI16.map { $0.binaryString }

		let correctBinStrsI16 = ["0000000000000000",
								 "0000000000000001",
								 "0000000000000010",
								 "0000000000000100",
								 "0000000000001000",
								 "0000000000001010",
								 "0000000011111111",
								 "0000000100000000",
								 "1111111111111111",
								 "1000000000000000"]
		XCTAssertEqual(binStrsI16, correctBinStrsI16)
	}


	func testThing() {

		let value = Int.min

		print(value.bitPattern.binaryString)
//		print(value.word)
//		print(value.twoByte)
//		print(value.byte)

		let myInt = 1234

		let intInData = Data(myInt.bytes)

		let magicNumber: Word = 0x464f4f00

		var compiledData = Data(magicNumber)
		compiledData.append(intInData)
		compiledData.append(Date().timeIntervalSince1970)
		compiledData.append(Double.pi)


		compiledData.append(contentsOf: [Byte(3), Word(42), TwoByte(1238), Word(123456789), LongWord(9999999999)])
	}
}
