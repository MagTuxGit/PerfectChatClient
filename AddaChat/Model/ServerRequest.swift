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
    
    static func from(url urlString: String) -> ServerRequest? {
        guard let url = URL(string: urlString) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return from(data: data)
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

/*
extension ServerRequest {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(channelId, forKey: .channelId)
        try container.encode(command, forKey: .command)
        try container.encode(message, forKey: .message)
        if clientId != nil {
            try container.encode(clientId, forKey: .clientId)
        }
    }
}
 */
