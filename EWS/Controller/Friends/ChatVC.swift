//
//  ChatVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/15/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatVC: UIViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var friendPic: CircleImageView!
    @IBOutlet weak var msgText: UITextView!
    @IBOutlet weak var friendName: UILabel!
    
    let sender = (FirebaseManager.shared.currentUser?.uid)!
    var friend: UserInfo!
    var chatList: [ChatInfo] = []
    private lazy var notificationRef = Database.database().reference().child("notificationRequests")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.tableFooterView = UIView()
        friendName.text = friend.name
        friendPic.image = friend.image ?? UIImage(named: "default-user")
        FirebaseManager.shared.getConversation(friendID: friend.uid) { (chatLog) in
            self.chatList = chatLog?.sorted(by: <) ?? []
            DispatchQueue.main.async {
                self.table.reloadData()
                let lastRow = self.chatList.count - 1
                if lastRow > 0 {
                    self.table.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: true)
                }
                
            }
        }
    }
    
    @IBAction func closeChat(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func sendText(_ sender: Any) {
        guard !msgText.text.isEmpty else { return }
        FirebaseManager.shared.sendText(friendID: friend.uid, msg: msgText.text) { (error) in
            guard error == nil else { return }
            let chatInfo = ChatInfo(msg: self.msgText.text, receiver: self.friend.uid)
            DispatchQueue.main.async {
                self.addRow(chatInfo)
                self.msgText.text = ""
            }
        }
    }
}

extension ChatVC: UITableViewDataSource {
    
    func addRow(_ info: ChatInfo) {
        chatList.append(info)
        let lastRow = self.chatList.count - 1
        table.beginUpdates()
        table.insertRows(at: [IndexPath(row: lastRow, section: 0)], with: .right)
        table.endUpdates()
        if lastRow > 0 {
            self.table.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChatCell
        let chatInfo = chatList[indexPath.row]
        let wasSent = chatInfo.receiverID != sender
        cell.setup(wasSent: wasSent, message: chatInfo.message)
        return cell
    }
}
