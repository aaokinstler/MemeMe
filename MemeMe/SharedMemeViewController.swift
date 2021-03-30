//
//  SharedMemeViewController.swift
//  MemeMe
//
//  Created by Anton Kinstler on 28.03.2021.
//

import UIKit

class SharedMemeViewController: UIViewController {
    
    var memeIndex : Int!
    @IBOutlet weak var memeView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeView.image = (UIApplication.shared.delegate as! AppDelegate).memes[memeIndex].memedImage
    }
}
