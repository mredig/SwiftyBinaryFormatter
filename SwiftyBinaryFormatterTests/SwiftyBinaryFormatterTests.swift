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
			let number = BinaryFormatter.LongWord.random(in: 0...BinaryFormatter.LongWord.max)
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
		let testData: [BinaryFormattingProtocol] = [BinaryFormatter.Word(238974), BinaryFormatter.TwoByte(55653)]
		let formatter = BinaryFormatter(data: testData)
		let data = formatter.renderedData

		let confirmedData = testData.reduce(Data()) { $0 + $1.bytes }
		XCTAssertEqual(data, confirmedData)
	}

	func testHexString() {
		let dead = try! BinaryFormatter.TwoByte(hexString: "Dead")
		let beef = try! BinaryFormatter.TwoByte(hexString: "Beef")
		let cafe = try! BinaryFormatter.TwoByte(hexString: "cafe")

		var formatter = BinaryFormatter()
		formatter.append(sequence: [dead, beef])
		formatter.append(element: cafe)

		var formatter2 = BinaryFormatter()
		formatter2.append(element: dead)
		formatter2.append(sequence: [beef, cafe])

		XCTAssertEqual(formatter.hexString, "deadbeefcafe")
		XCTAssertEqual(formatter.hexString, formatter2.hexString)
	}

	func testByteCount() {
		let de = try! BinaryFormatter.Byte(hexString: "De")
		let ad = try! BinaryFormatter.Byte(hexString: "ad")
		let beefcafe = try! BinaryFormatter.Word(hexString: "Beefcafe")

		let formatter = BinaryFormatter(data: [de, ad, beefcafe])
		XCTAssertEqual(formatter.byteCount, 6)

		var formatter2 = BinaryFormatter()
		formatter2.append(element: de)
		formatter2.append(sequence: [ad, beefcafe])
		XCTAssertEqual(formatter2.byteCount, 6)
		formatter2.append(formatter: formatter)
		XCTAssertEqual(formatter2.byteCount, 12)
	}

	func testSubscript() {
		let de = try! BinaryFormatter.Byte(hexString: "De")
		let ad = try! BinaryFormatter.Byte(hexString: "ad")
		let dead = try! BinaryFormatter.TwoByte(hexString: "Dead")
		let beefcafe = try! BinaryFormatter.Word(hexString: "Beefcafe")

		var formatter = BinaryFormatter(data: [de, ad, beefcafe])
		XCTAssertEqual(formatter[0], de)

		formatter[0] = ad
		XCTAssertEqual(formatter[0], ad)
		formatter[0] = de

		let formatter2 = BinaryFormatter(data: [dead, beefcafe])
		XCTAssertEqual(formatter.data, formatter2.data)
	}

	func testAppendFormatter() {
		let dead = try! BinaryFormatter.TwoByte(hexString: "Dead")
		let beef = try! BinaryFormatter.TwoByte(hexString: "Beef")
		let cafe = try! BinaryFormatter.TwoByte(hexString: "cafe")

		var formatter = BinaryFormatter()
		formatter.append(sequence: [dead, beef])
		formatter.append(element: cafe)

		var formatter2 = BinaryFormatter()
		formatter2.append(element: cafe)
		formatter2.append(sequence: [beef, dead])

		formatter.append(formatter: formatter2)
		XCTAssertEqual(formatter.hexString, "deadbeefcafecafebeefdead")
	}

	func testRenderingData() throws {
		guard let testBytes = Bundle(for: type(of: self)).url(forResource: "random", withExtension: "bytes") else { return }
		let separatedHex = (try String(contentsOf: testBytes)).split(separator: "\n").map { String($0) }

		var formatter = BinaryFormatter()

		for hexStr in separatedHex {
			let value: BinaryFormattingProtocol
			switch hexStr.count {
			case 2: //1
				// byte
				value = try BinaryFormatter.Byte(hexString: hexStr)
			case 4: //2
				// twobyte
				value = try BinaryFormatter.TwoByte(hexString: hexStr)
			case 8: //4
				// word
				value = try BinaryFormatter.Word(hexString: hexStr)
			case 16: //8
				// longword
				value = try BinaryFormatter.LongWord(hexString: hexStr)
			default:
				XCTFail("Invalid hex string: \(hexStr)")
				return
			}
			formatter.append(element: value)
		}

//		XCTAssertEqual(<#T##expression1: Equatable##Equatable#>, <#T##expression2: Equatable##Equatable#>)
	}

}
