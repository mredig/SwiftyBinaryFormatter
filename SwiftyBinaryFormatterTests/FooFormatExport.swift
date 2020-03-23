//
//  FooFormatExport.swift
//  SwiftyBinaryFormatterTests
//
//  Created by Michael Redig on 3/23/20.
//  Copyright © 2020 Red_Egg Productions. All rights reserved.
//

import SwiftyBinaryFormatter

struct FooFormatExport {
	// MARK: - Constants and Properties (1)
	/// Magic number to identify this file format as the first few bytes of the file.
	let magicHeader = Word(0x464f4f00)
	/// Identifies the file version
	let version = Byte(1)
	/// Provides the total count of all the chunks in this file.
	var chunkCount: TwoByte {
		// there's always 1 body chunk + a variable amount of meta chunks
		TwoByte(metaChunks.count) + 1
	}

	/// Storage for meta data until it's time to compile down to a binary file
	private var metaChunks = [MetaType]()
	/// Storage for body data until it's time to compile down to a binary file
	private var bodyStorage = Data()

	/// Storage for compiled data to cache for potential subsequent access
	private var _renderedData: Data?

	// MARK: - Nested Helper Types (2)
	/// Identifies different chunk types with their corresponding constant value
	enum ChunkType: Word {
		/// Provides the constant value to identify the chunk type in compiled binary
		case meta = 0x4d455441
		/// Provides the constant value to identify the chunk type in compiled binary
		case body = 0x424f4459
	}

	/// Identifies different types of meta data for use in meta chunks.
	enum MetaType {
		/// Identifies and contains the author type of meta data.
		case author(author: String)
		/// Identifies and contains the creation date type of meta data.
		case creationDate(secondsSinceEpoch: Double)

		/// Provides the constant value to identify the meta type in compiled binary
		var hexKey: Word {
			switch self {
			case .author:
				return 0x41555448
			case .creationDate:
				return 0x44415445
			}
		}
	}

	// MARK: - Data accumulation (3)
	/// Accumulates and stores metadata for inclusion when compiling.
	mutating func addMetaData(ofType type: MetaType) {
		metaChunks.append(type)

		// if cached data exists, delete it
		_renderedData = nil
	}

	/// Takes the body string and stores it for future compilation. Overwrites any previously stored value.
	mutating func setBody(_ body: String) {
		// convert string to data and store it
		bodyStorage = strToData(body)

		// if cached data exists, delete it
		_renderedData = nil
	}

	/// Could really just convert the string to Data, but this tests more internals
	private func strToData(_ string: String) -> Data {
		let dataSeq = string.compactMap { letter -> UInt8? in
			guard let value = try? Byte(character: letter) else { return nil }
			return value
		}
		return Data(dataSeq)
	}

	// MARK: - Compilation (4)
	private func renderMetaType(_ type: MetaType) -> Data {
		// structure: 4 bytes for type, 4 bytes for data byte size, then all data bytes
		// convert the value portion to Data
		let metaValue: Data
		switch type {
		case .author(let author):
			metaValue = strToData(author)
		case .creationDate(let dateValue):
			metaValue = Data(dateValue.bytes)
		}

		// calulate size
		let hexKeyBytes = type.hexKey.bytes
		let byteCount =  hexKeyBytes.count + metaValue.count

		// compile data in correct order
		var mergedData = Data(bfp: ChunkType.meta.rawValue)
		mergedData.append(sequence: Word(byteCount).bytes)
		mergedData.append(sequence: hexKeyBytes)
		mergedData.append(metaValue)

		return mergedData
	}

	/// Compiles all the accumualted information into a single binary blob, suitable for writing to disk or otherwise exporting.
	mutating func renderData() -> Data {
		// structure: 4 byte magic number, 1 byte file version, 2 bytes for chunk count, finally followed by all the chunks
		if let renderedData = _renderedData {
			return renderedData
		}

		// compile the file header, including magic, version, chunk count, and meta info
		var renderedData = Data(bfpSequence: [magicHeader, version, chunkCount])

		// compile and append all the meta chunks
		for metaChunk in metaChunks {
			renderedData.append(renderMetaType(metaChunk))
		}

		// compile and append the body data
		let bodyHeader = Data(bfpSequence: [ChunkType.body.rawValue, Word(bodyStorage.count + 1)])
		let bodyData = bodyHeader + bodyStorage + [0]
		renderedData.append(bodyData)

		// cache the data so subsequent requests are faster
		_renderedData = renderedData
		return renderedData
	}
}
