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

public class BinaryFormatter {

	public typealias LongWord = UInt64
	public typealias Word = UInt32
	public typealias TwoByte = UInt16
	public typealias Byte = UInt8

	public private(set) var byteCount: Int = 0

	static let invalidHexCharacters = CharacterSet(charactersIn: "0123456789abcdef").inverted

	private(set) var data = [BinaryFormattingProtocol]()

	public init() {}

	public init(data: [BinaryFormattingProtocol]) {
		self.data = data
		byteCount = data.reduce(0) { $0 + $1.byteCount }
	}

	public func append(element: BinaryFormattingProtocol) {
		data.append(element)
		byteCount += element.byteCount
	}

	public func append(formatter: BinaryFormatter) {
		data.append(contentsOf: formatter.data)
		byteCount += formatter.byteCount
	}

	public func append(sequence: [BinaryFormattingProtocol]) {
		data.append(contentsOf: sequence)
		byteCount += sequence.reduce(0) { $0 + $1.byteCount }
	}

	public subscript(index: Int) -> BinaryFormattingProtocol {
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

	/// Slow if called repeatedly. Caching would be smart.
	public var renderedData: Data {
		let bytes: [UInt8] = data.reduce([]) { $0 + $1.bytes }
		return Data(bytes)
	}
}
