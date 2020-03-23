//
//  FooFormatExport.swift
//  SwiftyBinaryFormatterTests
//
//  Created by Michael Redig on 3/23/20.
//  Copyright © 2020 Red_Egg Productions. All rights reserved.
//

import Foundation
import SwiftyBinaryFormatter

struct FooFormatExport {
	let magicHeader = Data.Word(0x464f4f00)
	let version = Data.Byte(1)
	var chunkCount: Data.TwoByte {
		Data.TwoByte(metaStorage.count) + 1
	}

	private var metaStorage = [Data]()
	private var bodyStorage = Data()

	private var _renderedData: Data?

	enum ChunkType: Data.Word {
		case meta = 0x4d455441
		case body = 0x424f4459
	}

	enum MetaType {
		case auth(String)
		case date(Double)

		var hexKey: Data.Word {
			switch self {
			case .auth:
				return 0x41555448
			case .date:
				return 0x44415445
			}
		}
	}

	mutating func addMetaData(ofType type: MetaType) {
		// structure: 4 bytes for type, 4 bytes for data byte size, then all data bytes

		let value: Data
		switch type {
		case .auth(let author):
			value = strToData(author)
		case .date(let dateValue):
			value = Data(dateValue.bytes)
		}

		// calulate size
		let hexKeyBytes = type.hexKey.bytes
		let byteCount = value.count + hexKeyBytes.count

		// compile data in correct order
		var mergedData = Data(Data.Word(byteCount).bytes)
		mergedData.append(sequence: hexKeyBytes)
		mergedData.append(value)
		metaStorage.append(mergedData)

		// if cached data exists, delete it
		_renderedData = nil
	}

	/// Could really just convert the string to Data, but this tests more internals
	private func strToData(_ string: String) -> Data {
		let dataSeq = string.compactMap { letter -> UInt8? in
			guard let value = try? Data.Byte(character: letter) else { return nil }
			return value
		}
		return Data(dataSeq)
	}

	mutating func setBody(_ body: String) {
		// convert string to data and store it
		bodyStorage = strToData(body)

		// if cached data exists, delete it
		_renderedData = nil
	}

	mutating func renderData() -> Data {
		if let renderedData = _renderedData {
			return renderedData
		}

		// structure: 4 byte magic number, 1 byte file version, 2 bytes for chunk count, finally followed by all the chunks

		// compile the file header, including magic, version, chunk count, and meta info
		var renderedData = Data(bfpSequence: [magicHeader, version, chunkCount])
		for metaChunk in metaStorage {
			// append each meta chunk, first marking it as a meta chunk
			renderedData.append(element: ChunkType.meta.rawValue)
			renderedData.append(metaChunk)
		}

		// compile and append the body data
		let bodyHeader = Data(bfpSequence: [ChunkType.body.rawValue, Data.Word(bodyStorage.count + 1)])
		let bodyData = bodyHeader + bodyStorage + [0]
		renderedData.append(bodyData)

		// cache the data so subsequent requests are faster
		_renderedData = renderedData
		return renderedData
	}
}
