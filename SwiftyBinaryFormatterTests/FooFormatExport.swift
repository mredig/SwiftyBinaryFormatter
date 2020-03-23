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

	enum MetaType: Data.Word {
		case auth = 0x41555448
		case date = 0x44415445
	}

	mutating func addMetaData(ofType type: MetaType, value: Data) {
		// structure: 4 bytes for type, 4 bytes for data byte size, then all data bytes


		// need to add four for the bytes in `type`
		var mergedData = Data(data: Data.Word(value.count + 4).bytes)
		mergedData.append(sequence: type.rawValue.bytes)
		mergedData.append(value)
		metaStorage.append(mergedData)
		_renderedData = nil
	}

	mutating func setBody(_ body: String) {
		bodyStorage = body.data(using: .utf8) ?? Data()
		_renderedData = nil
	}

	mutating func renderData() -> Data {
		if let renderedData = _renderedData {
			return renderedData
		}

		var renderedData = Data(data: [magicHeader, version, chunkCount])
		for metaChunk in metaStorage {
			// append each meta chunk, first marking it as a meta chunk
			renderedData.append(element: ChunkType.meta.rawValue)
			renderedData.append(metaChunk)
		}

		let bodyHeader = Data(data: [ChunkType.body.rawValue, Data.Word(bodyStorage.count + 1)])
		let bodyData = bodyHeader + bodyStorage + [0]
		renderedData.append(bodyData)

		_renderedData = renderedData
		return renderedData
	}
}
