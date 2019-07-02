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

	public var byteCount: Int {
		return data.reduce(0) { $0 + $1.byteCount }
	}

	static let invalidHexCharacters = CharacterSet(charactersIn: "0123456789abcdef").inverted

	private(set) var data = [BinaryFormattingProtocol]()

	public init() {}

	public init(data: [BinaryFormattingProtocol]) {
		self.data = data
	}

	public mutating func append(element: BinaryFormattingProtocol) {
		data.append(element)
	}

	public mutating func append(formatter: BinaryFormatter) {
		data.append(contentsOf: formatter.data)
	}

	public mutating func append(sequence: [BinaryFormattingProtocol]) {
		data.append(contentsOf: sequence)
	}

	public subscript(index: Int) -> BinaryFormattingProtocol {
		get {
			return data[index]
		}
		set {
			data[index] = newValue
		}
	}

	public var hexString: String {
		return data.reduce("") { $0 + $1.hexString }
	}

	public var renderedData: Data {
		let bytes: [UInt8] = data.reduce([]) { $0 + $1.bytes }
		return Data(bytes)
	}
}
