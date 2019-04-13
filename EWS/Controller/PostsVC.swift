//
//  PostsVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/12/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

class PostsVC: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var posts: [PostInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavBarClear()
        fetchPosts()
    }
    
    func fetchPosts() {
        FirebaseManager.shared.getPosts { postList in
            self.posts = postList ?? []
        }
    }
}

extension PostsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PostCell
        setCell(cell, indexPath: indexPath)
        return cell
    }
    
    func setCell(_ cell: PostCell, indexPath: IndexPath) {
        let post = posts[indexPath.row]
        cell.nameLabel.text = post.user?.name
        cell.commentText.text = post.description
        cell.userImage.image = post.user?.image ?? UIImage(named: "default-user")
        cell.postImage.image = post.image
    }
}
