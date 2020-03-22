//
//  BinaryFormatter.swift
//  BinaryFormatter
//
//  Created by Michael Redig on 5/1/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//

import Foundation

public enum BinaryErrors: Error {
	case wrongHexStringSize
	case containsNonHexCharacters
	case hexConversionFailed
	case nonAsciiCharacter
}

extension Data.LongWord: BinaryFormattingProtocol {
	public init(withDoubleRepresentation double: Double) {
		self.init(double.bitPattern)
	}

	public init(withFloatRepresentation float: Float) {
		self.init(float.bitPattern)
	}
}

extension Data.Word: BinaryFormattingProtocol {
	public init(withFloatRepresentation float: Float) {
		self.init(float.bitPattern)
	}
}

extension Data.TwoByte: BinaryFormattingProtocol {}

extension Data.Byte: BinaryFormattingProtocol {}


@available(*, deprecated, renamed: "Data")
public struct BinaryFormatter {
	public typealias LongWord = UInt64
	public typealias Word = UInt32
	public typealias TwoByte = UInt16
	public typealias Byte = UInt8


	public var byteCount: Int { data.count }

	public private(set) var data: Data

	public init() {
		data = Data()
	}

	public init(data: [BinaryFormattingProtocol]) {
		self.data = Data(data.flatMap { $0.bytes })
	}

	public init(data: [BinaryFormatter.Byte]) {
		self.data = Data(data)
	}

	public mutating func append(element: BinaryFormattingProtocol) {
		data.append(element: element)
	}

	public mutating func append(formatter: BinaryFormatter) {
		data.append(formatter: formatter)
	}

	public mutating func append(sequence: [BinaryFormattingProtocol]) {
		data.append(sequence: sequence)
	}

	public subscript(index: Int) -> BinaryFormatter.Byte {
		get {
			data[index]
		}
		set {
			data[index] = newValue
		}
	}

	public var hexString: String { data.hexString }

	@available(*, deprecated, renamed: "data")
	public var renderedData: Data { data }
}


extension Data {
	public typealias LongWord = UInt64
	public typealias Word = UInt32
	public typealias TwoByte = UInt16
	public typealias Byte = UInt8

	var hexString: String {
		reduce("") { $0 + $1.hexString }
	}

	@available(*, deprecated, renamed: "count")
	var byteCount: Int { count }

	@available(*, deprecated, message: "No need to use the `data` property as this is an instance of Data itself")
	var data: Data { self }

	public init(data: [BinaryFormattingProtocol]) {
		self.init(data.flatMap { $0.bytes })
	}

	public init(data: [Data.Byte]) {
		self.init(data)
	}

	mutating func append(element: BinaryFormattingProtocol) {
		append(contentsOf: element.bytes)
	}

	@available(*, deprecated, message: "BinaryFormatter is deprecated. Look into migrating the source to Data")
	mutating func append(formatter: BinaryFormatter) {
		append(contentsOf: formatter.data)
	}

	mutating func append(sequence: [BinaryFormattingProtocol]) {
		append(contentsOf: sequence.flatMap { $0.bytes })
	}
}
