//
//  ServerResponse.swift
//  AddaChat
//
//  Created by Andriy Trubchanin on 11/10/17.
//  Copyright © 2017 Onlinico. All rights reserved.
//

import Foundation

struct ServerResponse: Codable {
    let params: Params
    let result: String
}

struct Params: Codable {
    let clientId: String
    let clientList: [String]
    let messages: [String]
}

extension ServerResponse {
    static func from(json: String, using encoding: String.Encoding = .utf8) -> ServerResponse? {
        guard let data = json.data(using: encoding) else { return nil }
        return ServerResponse.from(data: data)
    }
    
    static func from(data: Data) -> ServerResponse? {
        let decoder = JSONDecoder()
        return try? decoder.decode(ServerResponse.self, from: data)
    }
    
    static func from(url urlString: String) -> ServerResponse? {
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

extension ServerResponse {
    enum CodingKeys: String, CodingKey {
        case params = "params"
        case result = "result"
    }
}

extension Params {
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientList = "client_list"
        case messages = "messages"
    }
}

