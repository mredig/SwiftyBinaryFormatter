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

	public private(set) var byteCount: Int = 0

	public private(set) var data = ContiguousArray<BinaryFormatter.Byte>()

	public init(estimatedEntryCount: Int = 0) {
		self.data = ContiguousArray<BinaryFormatter.Byte>(repeating: 0, count: estimatedEntryCount)
		self.data.removeAll(keepingCapacity: true)
	}

	public init(data: [BinaryFormattingProtocol]) {
		self.data = ContiguousArray(data.flatMap { $0.bytes })
		byteCount = data.reduce(0) { $0 + $1.byteCount }
	}

	public init(data: [BinaryFormatter.Byte]) {
		self.data = ContiguousArray(data)
		byteCount = data.reduce(0) { $0 + $1.byteCount }
	}

	public mutating func append(element: BinaryFormattingProtocol) {
		data.append(contentsOf: element.bytes)
		byteCount += element.byteCount
	}

	public mutating func append(formatter: BinaryFormatter) {
		data.append(contentsOf: formatter.data)
		byteCount += formatter.byteCount
	}

	public mutating func append(sequence: [BinaryFormattingProtocol]) {
		data.append(contentsOf: sequence.flatMap { $0.bytes })
		byteCount += sequence.reduce(0) { $0 + $1.byteCount }
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

	public var renderedData: Data {
		Data(data)
	}
}
