

import UIKit

class SharedMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var sharedMemesCollectionViewLayout: UICollectionViewFlowLayout!
    let delegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3
        sharedMemesCollectionViewLayout.minimumInteritemSpacing = space
        sharedMemesCollectionViewLayout.minimumLineSpacing = space
        sharedMemesCollectionViewLayout.itemSize = CGSize(width: dimension, height: dimension)
        // Add observer to reload data when meme image added
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReceivedNotification(notification:)), name: Notification.Name("AddedImage"), object: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sharedMemeViewController = (self.storyboard?.instantiateViewController(identifier: "ShareMemeViewController"))! as SharedMemeViewController
        sharedMemeViewController.memeIndex = (indexPath as NSIndexPath).row
        self.navigationController?.pushViewController(sharedMemeViewController, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! SharedMemeCollectionCellViewController
        cell.memeImageView.image = delegate.memes[(indexPath as NSIndexPath).row].memedImage
        return cell
        
    }
    
    @objc func ReceivedNotification(notification: Notification) {
        collectionView.reloadData()
    }
}
