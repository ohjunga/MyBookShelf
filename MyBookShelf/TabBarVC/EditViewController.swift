//
//  EditViewController.swift
//  MyBookShelf
//
//  Created by junga oh on 2022/07/21.
//

import UIKit

protocol SendDataDelegate: AnyObject {
    func sendReport(str: String, index: Int)
    func delReport(index: Int)
}

class EditViewController: UIViewController {
    
    weak var delegate: SendDataDelegate?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var storyTextView: UITextView!
    
    var strtitle: String?
    var strWriter: String?
    var strPublisher: String?
    var strStory: String?
    var strReport: String?
    var strImage: String?
    
    var indexNum: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = strtitle
        self.writerLabel.text = strWriter
        self.publisherLabel.text = strPublisher
        self.storyLabel.text = strStory
        self.storyTextView.text = strReport
        let imageURL = URL(string: strImage!)
        self.imageView.kf.setImage(with: imageURL)
        self.storyTextView.text = strReport

    }
    /* 취소버튼 */
    @IBAction func tapCancleBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    /* 수정버튼 */
    @IBAction func tapEditBtn(_ sender: UIButton) {
        self.delegate?.sendReport(str: self.storyTextView.text, index: indexNum!)
        self.dismiss(animated: true)
    }
    /* 삭제버튼 */
    @IBAction func tapDeleteBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: "", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "네", style: .default) { action in
            self.delegate?.delReport(index: self.indexNum!)
            self.dismiss(animated: true)
        }
        let cancel = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}
