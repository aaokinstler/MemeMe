//
//  SharedMemesTableViewController.swift
//  MemeMe
//
//  Created by Anton Kinstler on 28.03.2021.
//

import UIKit

class SharedMemesTableViewController: UITableViewController {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adding observer to reload data when meme image added
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReceivedNotification(notification:)), name: Notification.Name("AddedImage"), object: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath)
        let meme = delegate.memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = "\(meme.topText ?? "") \(meme.bottomText ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sharedMemeViewController = (self.storyboard?.instantiateViewController(identifier: "ShareMemeViewController"))! as SharedMemeViewController
        sharedMemeViewController.memeIndex = (indexPath as NSIndexPath).row
        self.navigationController?.pushViewController(sharedMemeViewController, animated: true)
    }
    
    @objc func ReceivedNotification(notification: Notification) {
        tableView.reloadData()
    }
}
