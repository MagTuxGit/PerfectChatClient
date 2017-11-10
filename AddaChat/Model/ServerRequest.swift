//
//  ServerRequest.swift
//  AddaChat
//
//  Created by Andriy Trubchanin on 11/10/17.
//  Copyright © 2017 Onlinico. All rights reserved.
//

import Foundation

struct ServerRequest: Codable {
    let channelId: String
    let clientId: String?
    let command: String
    let message: String
}

extension ServerRequest {
    static func from(json: String, using encoding: String.Encoding = .utf8) -> ServerRequest? {
        guard let data = json.data(using: encoding) else { return nil }
        return ServerRequest.from(data: data)
    }
    
    static func from(data: Data) -> ServerRequest? {
        let decoder = JSONDecoder()
        return try? decoder.decode(ServerRequest.self, from: data)
    }
    
    var jsonData: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    var jsonString: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension ServerRequest {
    enum CodingKeys: String, CodingKey {
        case channelId = "channelid"
        case clientId = "clientid"
        case command = "cmd"
        case message = "msg"
    }
}
