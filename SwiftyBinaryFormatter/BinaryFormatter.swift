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

public protocol BinaryFormatting: AnyObject {
	var byteCount: Int { get }

	associatedtype BinaryFormattingType: BinaryFormattingProtocol
	var data: ContiguousArray<BinaryFormattingType> { get }

	init(estimatedEntryCount: Int)
	init(data: [BinaryFormattingType])

	func append(element: BinaryFormattingProtocol)

	func append<BF: BinaryFormatting>(formatter: BF)

	func append(sequence: [BinaryFormattingProtocol])

	subscript(index: Int) -> BinaryFormattingType { get set }

	var hexString: String { get }

	var renderedData: Data { get }

}

public class BinaryFormatter: BinaryFormatting {

	public typealias LongWord = UInt64
	public typealias Word = UInt32
	public typealias TwoByte = UInt16
	public typealias Byte = UInt8

	public private(set) var byteCount: Int = 0

	public typealias BinaryFormattingType = BinaryFormatter.Byte

	public private(set) var data = ContiguousArray<BinaryFormattingType>()

	required public init(estimatedEntryCount: Int = 0) {
		self.data = ContiguousArray<BinaryFormattingType>(repeating: 0, count: estimatedEntryCount)
		self.data.removeAll(keepingCapacity: true)
	}

	public init(data: [BinaryFormattingProtocol]) {
		self.data = ContiguousArray(data.flatMap { $0.bytes })
		byteCount = data.reduce(0) { $0 + $1.byteCount }
	}

	public required init(data: [BinaryFormattingType]) {
		self.data = ContiguousArray(data)
		byteCount = data.reduce(0) { $0 + $1.byteCount }
	}

	public func append(element: BinaryFormattingProtocol) {
		data.append(contentsOf: element.bytes)
		byteCount += element.byteCount
	}

	public func append<BF: BinaryFormatting>(formatter: BF) {
		if let baked = formatter as? BinaryFormatter {
			self.data.append(contentsOf: baked.data)
		} else {
			self.data.append(contentsOf: formatter.data.flatMap { $0.bytes })
		}
		byteCount += formatter.byteCount
	}

	public func append(sequence: [BinaryFormattingProtocol]) {
		data.append(contentsOf: sequence.flatMap { $0.bytes })
		byteCount += sequence.reduce(0) { $0 + $1.byteCount }
	}

	public subscript(index: Int) -> BinaryFormattingType {
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
