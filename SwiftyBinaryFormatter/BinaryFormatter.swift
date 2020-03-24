//
//  BinaryFormatter.swift
//  BinaryFormatter
//
//  Created by Michael Redig on 5/1/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//

import Foundation

@available(*, deprecated, renamed: "Data")
public struct BinaryFormatter {
	@available(*, deprecated, message: "Simply use `LongWord` instead (no nesting).")
	public typealias LongWord = UInt64
	@available(*, deprecated, message: "Simply use `Word` instead (no nesting).")
	public typealias Word = UInt32
	@available(*, deprecated, message: "Simply use `TwoByte` instead (no nesting).")
	public typealias TwoByte = UInt16
	@available(*, deprecated, message: "Simply use `Byte` instead (no nesting).")
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
		data.append(element)
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

	@available(swift, obsoleted: 5.0, renamed: "data", message: "But also just use Data instead of BinaryFormatter")
	public var renderedData: Data { data }
}


public typealias LongWord = UInt64
public typealias Word = UInt32
public typealias TwoByte = UInt16
public typealias Byte = UInt8

extension Data {
	public var hexString: String {
		reduce("") { $0 + $1.hexString }
	}

	/// Simply an alias for `count`, but semantically makes more sense in some siutations.
	public var byteCount: Int { count }

	@available(swift, obsoleted: 5.0, message: "No need to use the `data` property as this is an instance of Data itself")
	public var data: Data { self }

	@available(*, deprecated, renamed: "init(_:)")
	public init(data: [BinaryFormattingProtocol]) {
		self.init(data)
	}

	public init(_ bfp: BinaryFormattingProtocol) {
		self.init(bfp.bytes)
	}

	public init(_ bfpSequence: [BinaryFormattingProtocol]) {
		self.init(bfpSequence.flatMap { $0.bytes })
	}

	@available(*, deprecated, renamed: "init(_:)")
	public init(data: [Byte]) {
		self.init(data)
	}

	public mutating func append(_ element: BinaryFormattingProtocol) {
		append(contentsOf: element.bytes)
	}

	public mutating func append<T: BitRepper>(_ element: T) {
		append(contentsOf: element.bitPattern.bytes)
	}

	@available(*, deprecated, message: "BinaryFormatter is deprecated. Look into migrating the source to Data")
	public mutating func append(formatter: BinaryFormatter) {
		append(contentsOf: formatter.data)
	}

	@available(*, deprecated, renamed: "append(contentsOf:)")
	public mutating func append(sequence: [BinaryFormattingProtocol]) {
		append(contentsOf: sequence)
	}

	public mutating func append(contentsOf bfpSequence: [BinaryFormattingProtocol]) {
		append(contentsOf: bfpSequence.flatMap { $0.bytes })
	}
}
