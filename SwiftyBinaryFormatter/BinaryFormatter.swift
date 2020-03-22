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

extension BinaryFormatter.LongWord: BinaryFormattingProtocol {
	public init(withDoubleRepresentation double: Double) {
		self.init(double.bitPattern)
	}

	public init(withFloatRepresentation float: Float) {
		self.init(float.bitPattern)
	}
}

extension BinaryFormatter.Word: BinaryFormattingProtocol {
	public init(withFloatRepresentation float: Float) {
		self.init(float.bitPattern)
	}
}

extension BinaryFormatter.TwoByte: BinaryFormattingProtocol {}

extension BinaryFormatter.Byte: BinaryFormattingProtocol {}


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
		data.append(contentsOf: element.bytes)
	}

	public mutating func append(formatter: BinaryFormatter) {
		data.append(contentsOf: formatter.data)
	}

	public mutating func append(sequence: [BinaryFormattingProtocol]) {
		data.append(contentsOf: sequence.flatMap { $0.bytes })
	}

	public subscript(index: Int) -> BinaryFormatter.Byte {
		get {
			data[index]
		}
		set {
			data[index] = newValue
		}
	}

	public var hexString: String {
		data.reduce("") { $0 + $1.hexString }
	}

	@available(*, deprecated, message: "Use `data` instead.")
	public var renderedData: Data { data }
}
