//
//  ChatViewController.swift
//  AddaChat
//
//  Created by Andriy Trubchanin on 11/10/17.
//  Copyright © 2017 Onlinico. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    let chatService = ChatService()
    
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
        
        chatService.delegate = self
        chatService.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendButtonTouched(_ sender: UIButton) {
        guard let message = messageView.text else {
            return
        }
        
        if message.count > 0 {
            setStatus("Sending ...")
            newMessage("ME: "+message)
            chatService.sendMessage(message)
            messageView.text = ""
        }
    }
    
}

extension ChatViewController: ChatServiceDelegate {
    func newMessage(_ message: String) {
        chatView.text = chatView.text.appending("\n"+message)
    }
    
    func setStatus(_ status: String) {
        statusLabel.text = status
    }
}
