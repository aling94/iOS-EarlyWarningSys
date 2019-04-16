//
//  ChatVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/15/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var friendPic: CircleImageView!
    @IBOutlet weak var msgText: UITextView!
    @IBOutlet weak var friendName: UILabel!
    
    let sender = (FirebaseManager.shared.currentUser?.uid)!
    var friend: UserInfo?
    var chatList: [ChatInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendName.text = friend?.name
        friendPic.image = friend?.image ?? UIImage(named: "default-user")
    }
    
    @IBAction func closeChat(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func sendText(_ sender: Any) {
    }
}

extension ChatVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChatCell
        
        return cell
    }
    
    
}
