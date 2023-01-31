//
//  ChatViewController.swift
//  Chat Application
//
//  Created by Nikhil Mac on 18/01/23.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message:MessageType{
    
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
}

struct Sender:SenderType{
    
    var senderId: String
    var displayName: String
    var photoURL: String
    
}

class ChatViewController: MessagesViewController {
    
    public var isNewConversation = false
    public var otherUserEmail:String = ""
    
    private var messages = [Message]()
    private var selfSender = Sender(senderId: "1", displayName: "nikhil", photoURL: "")
    
//    init(with email:String){
//        self.otherUserEmail = email
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        //navigationItem.largeTitleDisplayMode = .never
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
    }
    

    
}

//messageInputBar delegate methods
extension ChatViewController:InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {return}
        //send message
        print("sending: \(text)")
        if isNewConversation {
            //create convo in database
//            let message = Message(sender: <#T##SenderType#>, messageId: <#T##String#>, sentDate: Date(), kind: .text(text))
//            DatabaseManager.shared.createNewConversation(with: otherUserEmail, firstMessage: <#T##Message#>, completion: <#T##(Bool) -> Void#>)
        } else {
            //append to existing convo data
        }
    }
}


//message delegate methods
extension ChatViewController:MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate{
    
    
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    
}
