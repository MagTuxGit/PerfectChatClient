//
//  ChatViewController.swift
//  AddaChat
//
//  Created by Andriy Trubchanin on 11/10/17.
//  Copyright © 2017 Onlinico. All rights reserved.
//

import UIKit
import Starscream

typealias JSON = [String:Any]

struct WSParams {
    let channel: String
    var clientId: String
}

class ChatViewController: UIViewController {
    let socket = WebSocket(url: URL(string: "ws://34.198.94.121:8181/api/v1/chat")!, protocols: ["chat"])
    var wsParams = WSParams(channel: "trial1", clientId: "")
    
    @IBOutlet var chatView: UITextView!
    @IBOutlet var messageView: UITextView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageView.layer.borderColor = UIColor.black.cgColor
        messageView.layer.borderWidth = 1
        sendButton.layer.borderColor = UIColor.black.cgColor
        sendButton.layer.borderWidth = 1
        
        socket.delegate = self
        socket.connect()
    }

    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendButtonTouched(_ sender: UIButton) {
        if messageView.text.count > 0 {
            sendMessage(messageView.text)
            messageView.text = ""
        }
    }
    
}

// MARK: - FilePrivate
fileprivate extension ChatViewController {
    
    func sendMessage(_ message: String) {
        chatView.text = chatView.text.appending("\n"+message)
        statusLabel.text = "Sending ..."
        let valueToSend = ["cmd": "send", "msg": message, "clientid": wsParams.clientId, "channelid": wsParams.channel];
        if let jsonString = String.fromJson(valueToSend) {
            print("SENDING: " + jsonString)
            socket.write(string: jsonString)
        }
    }
    
    func messageReceived(_ message: String) {
        chatView.text = chatView.text.appending("\n"+message)
    }
    
    func register(_ response: String) {
        guard let resp = response.toJson() else {
            return
        }
        
        if let result = resp["result"] as? String {
            statusLabel.text = "Connection: " + result
        }
        
        if let params = resp["params"] as? JSON,
            let clientId = params["client_id"] as? String {
            wsParams.clientId = clientId
        }
    }
    
    /*
    ws_params.client_id = resp.params.client_id;
    ws_params.messages = resp.params.messages;
    if(resp.params.client_list != undefined){
    ws_params.client_list = resp.params.client_list
    listClients(ws_params.client_list)
    } else {
    ws_params.client_list = new Array();
    }
    }
 */
 }

// MARK: - WebSocketDelegate
extension ChatViewController : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("CONNECTED")
        statusLabel.text = "Connecting ..."
        let valueToSend = ["cmd": "register", "msg": "joining channel "+wsParams.channel, "channelid":wsParams.channel];
        if let jsonString = String.fromJson(valueToSend) {
            socket.write(string: jsonString)
        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("DISCONNECTED")
        //performSegue(withIdentifier: "websocketDisconnected", sender: self)
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("MESSAGE")
        guard let jsonDict = text.toJson(),
            let msg = jsonDict["msg"] as? String,
            let request = jsonDict["request"] as? String else {
                return
        }
        
        switch(request) {
        case "send":
            print("send message: "+msg)
            messageReceived(msg)
            break;
        case "dispatch":
            print("dispatch message: "+msg)
            break;
        case "client_list":
            print("client_list message: "+msg)
            break;
        case "client_add":
            print("client_add message: "+msg)
            break;
        case "client_remove":
            print("client_remove message: "+msg)
            break;
        case "register":
            print("register message: "+msg)
            register(msg)
            break;
        default:
            print("default message: "+msg)
            break;
        }
        
        //messageReceived(messageText, senderName: messageAuthor)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("DATA")
    }
    
}

extension String {
    
    func toJson() -> JSON? {
        if let data = self.data(using: .utf16),
            let jsonData = try? JSONSerialization.jsonObject(with: data),
            let jsonDict = jsonData as? JSON {
            return jsonDict
        }
        return nil
    }
    
    static func fromJson(_ json: JSON) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
