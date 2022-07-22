//
//  MyReportViewController.swift
//  MyBookShelf
//
//  Created by junga oh on 2022/07/20.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class MyReportViewController: UIViewController, SendDataDelegate {
    
    /* firebase realtime DB */
    let bookreportReference = Database.database().reference(withPath: "bookreport-list")
    /* 델리게이트 메서드 : 리포트 수정 */
    func sendReport(str: String, index: Int) {
        let editItem = index
        self.bookreportReference.child("book\(editItem)/bookreport").setValue(str)
    }
    /* 델리게이트 메서드 : 리포트 제거 */
    func delReport(index: Int) {
        let delItem = index
        self.bookreportReference.child("book\(delItem)").removeValue()
        self.reporttableView.reloadData()
    }
    
    var cell:BookListCell?
    
    var saveReportList: [saveData] = []
    
    @IBOutlet weak var reporttableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reporttableView.dataSource = self
        self.reporttableView.delegate = self
        /* db 호출 */
        bookreportReference.observe(.value) { snapshot in
            guard let snapData = snapshot.value as? [String:Any] else {
                /* db 비었을시 */
                self.saveReportList.removeAll(); return self.reporttableView.reloadData() }
            let data = try! JSONSerialization.data(withJSONObject: Array(snapData.values), options: [])
            do {
                let decoder = JSONDecoder()
                let reportList = try decoder.decode([saveData].self, from: data)
                self.saveReportList = reportList
                //print(self.saveReportList)
            } catch {
                print("error: ", error)
            }
            let group = DispatchGroup()
                    let enumerator = snapshot.children

                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        group.enter()
                        group.leave()
                    }
                    group.notify(queue: .main) {
                        /* db 데이터 확인 다 하고 동작되도록 */
                        self.reporttableView.reloadData()
                    }
        }
        let nibName = UINib(nibName: "BookListCell", bundle: nil)
        reporttableView.register(nibName, forCellReuseIdentifier: "ReportListCell")
    }
}
extension MyReportViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.saveReportList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportListCell", for: indexPath) as? BookListCell else { return UITableViewCell() }
        cell.bookTitleLabel.text = saveReportList[indexPath.row].title
        cell.bookWriterLabel.text = saveReportList[indexPath.row].author
        cell.bookPublisherLabel.text = saveReportList[indexPath.row].publisher
        let imageURL = URL(string: saveReportList[indexPath.row].image)
        cell.bookImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
extension MyReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let EditViewController = storyboard.instantiateViewController(identifier: "EditViewController") as? EditViewController else { return }
        EditViewController.delegate = self
        EditViewController.strtitle = saveReportList[indexPath.row].title
        EditViewController.strWriter = saveReportList[indexPath.row].author
        EditViewController.strStory = saveReportList[indexPath.row].description
        EditViewController.strPublisher = saveReportList[indexPath.row].publisher
        EditViewController.strReport = saveReportList[indexPath.row].bookreport
        EditViewController.strImage = saveReportList[indexPath.row].image
        EditViewController.indexNum = saveReportList[indexPath.row].id
        self.show(EditViewController, sender: nil)
    }
}
