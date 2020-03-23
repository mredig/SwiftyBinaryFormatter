//
//  FooFormatTests.swift
//  SwiftyBinaryFormatterTests
//
//  Created by Michael Redig on 3/23/20.
//  Copyright © 2020 Red_Egg Productions. All rights reserved.
//

import Foundation
import XCTest

class FooFormatTests: XCTestCase {
	func testFooFormatExport() {
		var fooFormat = FooFormatExport()

		let dateFloat = 1584945896.43886
		let dateBytes = dateFloat.bitPattern.bytes

		fooFormat.addMetaData(ofType: .auth, value: "Michael Redig".data(using: .utf8)!)
		fooFormat.addMetaData(ofType: .date, value: Data(dateBytes))

		fooFormat.setBody("Hello World!")

		let renderedData = fooFormat.renderData()


		let hexCorrectVersion = "464F4F00 0100034D 45544100 00001141 5554484D 69636861 656C2052 65646967 4D455441 0000000C 44415445 41D79E16 BA1C1648 424F4459 0000000D 48656C6C 6F20576F 726C6421 00"

		let hexWords = hexCorrectVersion.split(separator: " ").map { String($0) }.joined()
		var compareData = Data()
		var accumulator = ""
		let theAppender = {
			let value = UInt8(accumulator, radix: 16)!
			accumulator = ""
			compareData.append(value)
		}

		for (index, char) in hexWords.enumerated() {
			if index > 0 && index.isMultiple(of: 2) {
				theAppender()
			}
			accumulator.append(char)
		}
		theAppender() //need to run one additional time

		XCTAssertEqual(renderedData, compareData)
	}
}
