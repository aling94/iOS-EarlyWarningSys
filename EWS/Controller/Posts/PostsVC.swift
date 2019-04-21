//
//  PostsVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/12/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import SVProgressHUD

class PostsVC: BaseVC {

    @IBOutlet weak var notice: UILabel!
    @IBOutlet weak var table: UITableView!
    
    var posts: [PostInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.table.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }
    
    func fetchPosts() {
        SVProgressHUD.show()
        FirebaseManager.shared.getPosts { postList in
            self.posts = postList?.sorted(by: >) ?? []
        }
    }
}

extension PostsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notice.isHidden = !posts.isEmpty
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PostCell
        cell.set(posts[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
