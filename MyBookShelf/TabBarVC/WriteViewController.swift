//
//  WriteViewController.swift
//  MyBookShelf
//
//  Created by junga oh on 2022/07/20.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class WriteViewController: UIViewController {
    
    @IBOutlet weak var cancelBtn: UIButton!
    var saveReportList: [saveData] = []
    
    //Firebase Realtime Database
    var ref: DatabaseReference!
    
    let bookreportReference = Database.database().reference(withPath: "bookreport-list")
    
    @IBOutlet weak var saveStoryLabel: UILabel!
    @IBOutlet weak var savePublisherLabel: UILabel!
    @IBOutlet weak var saveWriterLabel: UILabel!
    @IBOutlet weak var saveTitleLabel: UILabel!
    @IBOutlet weak var saveImageView: UIImageView!
    @IBOutlet weak var saveTextView: UITextView!
    
    var strTitle: String?
    var strWriter: String?
    var strPublisher: String?
    var strImage: String?
    var strStory: String?
    var strReport: String?
    
    var addItemNum: Int?
    var maxID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addItemNum = 0
        if let strTitle = strTitle {
            self.saveTitleLabel.text = strTitle
        }
        if let strWriter = strWriter {
            self.saveWriterLabel.text = strWriter
        }
        if let strPublisher = strPublisher {
            self.savePublisherLabel.text = strPublisher
        }
        if let strImage = strImage {
            let imageUrl = URL(string: strImage)
            saveImageView.kf.setImage(with: imageUrl)
        }
        if let strStory = strStory {
            self.saveStoryLabel.text = strStory
        }
        //Firebase Database 읽어오기
        bookreportReference.observe(.value) { snapshot in
            guard let snapData = snapshot.value as? [String:Any] else {return}
            let data = try! JSONSerialization.data(withJSONObject: Array(snapData.values), options: [])
            do {
                let decoder = JSONDecoder()
                let reportList = try decoder.decode([saveData].self, from: data)
                self.saveReportList = reportList
                self.addItemNum = reportList.count
                //print("observe")
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
    }
    /* 취소버튼 */
    @IBAction func tapCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    /* 저장버튼 */
    @IBAction func tapSaveBtn(_ sender: UIButton) {
        //Firebase Database 쓰기
        print("addItemNum : \(addItemNum!)")
        if addItemNum != 0 {
            maxID = 0
            for i in 0..<addItemNum! {
                /* 중복제목 체크 */
                if strTitle == saveReportList[i].title {
                    let alert = UIAlertController(title: "이미 정리한 책입니다. ", message: "", preferredStyle: .alert)
                    present(alert, animated: true, completion: nil)
                    self.dismiss(animated: true)
                    print("중복..")
                    break
                }
                else {
                    if saveReportList[i].id > maxID! {
                        maxID = saveReportList[i].id
                    }
                    addDB()
                }
            }
        } else {
            maxID = 0
            addItemNum = 0
            addDB()
        }
        print("maxID : \(maxID)")
        self.dismiss(animated: true)
    }
    /* db 추가 메서드 */
    func addDB() {
        let addItemRef = bookreportReference.child("book\(maxID!+1)")
        let values: [String: Any] = [ "title": strTitle!, "author": strWriter!, "publisher": strPublisher!, "description": strStory!, "image": strImage!, "bookreport": self.saveTextView.text!, "id": maxID!+1]
        addItemRef.setValue(values)
    }
}
