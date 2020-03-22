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

		let formatter = BinaryFormatter()
		formatter.append(sequence: [dead, beef])
		formatter.append(element: cafe)

		let formatter2 = BinaryFormatter()
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

		let formatter2 = BinaryFormatter()
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

		let formatter = BinaryFormatter(data: [de, ad, beefcafe])
		XCTAssertEqual(formatter[0] as? BinaryFormatter.Byte, de)

		formatter[0] = dead
		XCTAssertEqual(formatter[0] as? BinaryFormatter.TwoByte, dead)
	}

	func testAppendFormatter() {
		let dead = try! BinaryFormatter.TwoByte(hexString: "Dead")
		let beef = try! BinaryFormatter.TwoByte(hexString: "Beef")
		let cafe = try! BinaryFormatter.TwoByte(hexString: "cafe")

		let formatter = BinaryFormatter()
		formatter.append(sequence: [dead, beef])
		formatter.append(element: cafe)

		let formatter2 = BinaryFormatter()
		formatter2.append(element: cafe)
		formatter2.append(sequence: [beef, dead])

		formatter.append(formatter: formatter2)
		XCTAssertEqual(formatter.hexString, "deadbeefcafecafebeefdead")
	}
}
