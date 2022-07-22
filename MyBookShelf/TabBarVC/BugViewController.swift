//
//  BugViewController.swift
//  MyBookShelf
//
//  Created by junga oh on 2022/07/22.
//

import UIKit

class BugViewController: UIViewController {

    @IBOutlet weak var bugImage1: UIImageView!
    @IBOutlet weak var bugImage2: UIImageView!
    @IBOutlet weak var bugImgae3: UIImageView!
    @IBOutlet weak var bugImage4: UIImageView!
    @IBOutlet weak var bugImage5: UIImageView!
    @IBOutlet weak var bugImage6: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bugImage1.image = UIImage(named: "egg")
        bugImage2.image = UIImage(named: "crackegg")
        bugImgae3.image = UIImage(named: "baby")
        bugImage4.image = UIImage(named: "kid")
        bugImage5.image = UIImage(named: "student")
        bugImage6.image = UIImage(named: "adult")
    }
    @IBAction func tapDismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
