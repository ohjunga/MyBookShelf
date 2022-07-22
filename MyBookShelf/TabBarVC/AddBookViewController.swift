//
//  AddBookViewController.swift
//  MyBookShelf
//
//  Created by ohjunga on 2022/07/20.
//

import UIKit
import Kingfisher

class AddBookViewController: UIViewController, UITextFieldDelegate {
    
    var bookSearchList: [SearchResult.BookInfo] = []
    
    @IBOutlet weak var bookListTableView: UITableView!
    @IBOutlet weak var findBookTextField: UITextField!
    
    var cell:BookListCell?
    
    let jsconDecoder: JSONDecoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookListTableView.dataSource = self
        self.bookListTableView.delegate = self
        
        /* UITableView Cell 등록 */
        let nibName = UINib(nibName: "BookListCell", bundle: nil)
        bookListTableView.register(nibName, forCellReuseIdentifier: "BookListCell")
        
        self.findBookTextField.delegate = self
    }
    
    func urlTaskDone() {
        if dataManager.shared.searchResult?.items.count == 0 {
            print("No researching data")
        }
        for i in 0..<(dataManager.shared.searchResult?.items.count)! {
            let item = dataManager.shared.searchResult?.items[i]
            bookSearchList.append(item!)
        }
        DispatchQueue.main.async {
                self.bookListTableView.reloadData()
            }
    }
    /* textField enter 키 눌릴 시 호출 메서드 */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.findBookTextField {
            bookSearchList.removeAll()
            requestAPIToNaver(queryValue: findBookTextField.text!)
        }
        return true
    }
    /* Naver 책 검색 api 접근*/
    private func requestAPIToNaver(queryValue: String) {
        let clientID: String = "XCn2IrHOgLkNmd1XzOid"
        let cliendKEY: String = "HMzZambyTA"
        
        let query: String = "https://openapi.naver.com/v1/search/book.json?query=\(queryValue)"
        let encodedQuery: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedQuery)!
        
        var requestURL = URLRequest(url: queryURL)
        requestURL.addValue("application/json; charset=jtf-8", forHTTPHeaderField: "Content-Type")
        requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        requestURL.addValue(cliendKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard error == nil else { print(error); return }
            guard let data = data else { print(error); return }
            
            do {
                let searchInfo: SearchResult = try self.jsconDecoder.decode(SearchResult.self, from: data)
                dataManager.shared.searchResult = searchInfo
                self.urlTaskDone()
            } catch {
                print(fatalError())
            }
        }
        task.resume()
    }
}

extension AddBookViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookSearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookListCell", for: indexPath) as? BookListCell else { return UITableViewCell() }
        cell.bookTitleLabel.text = bookSearchList[indexPath.row].title.htmlEscaped
        cell.bookWriterLabel.text = bookSearchList[indexPath.row].author.htmlEscaped
        cell.bookPublisherLabel.text = bookSearchList[indexPath.row].publisher.htmlEscaped
        guard let imageUrl = URL(string: bookSearchList[indexPath.row].image) else {
            cell.bookImageView.image = UIImage()
                    return cell }
        cell.bookImageView.kf.setImage(with: imageUrl)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
extension AddBookViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* 다운캐스팅으로 자식뷰컨 프로퍼티에 접근 */
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let WriteViewController = storyboard.instantiateViewController(identifier: "WriteViewController") as? WriteViewController else { return }
        WriteViewController.strTitle = bookSearchList[indexPath.row].title.htmlEscaped
        WriteViewController.strWriter = bookSearchList[indexPath.row].author.htmlEscaped
        WriteViewController.strPublisher = bookSearchList[indexPath.row].publisher.htmlEscaped
        WriteViewController.strImage = bookSearchList[indexPath.row].image
        WriteViewController.strStory = bookSearchList[indexPath.row].description.htmlEscaped
        self.show(WriteViewController, sender: nil)
    }
}
/* html 태그 제거 + html entity들 디코딩 */
extension String {
    var htmlEscaped: String {
        guard let encodedData = self.data(using: .utf8) else {
            return self
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        do {
            let attributed = try NSAttributedString(data: encodedData,
                                                    options: options,
                                                    documentAttributes: nil)
            return attributed.string
        } catch {
            return self
        }
    }
}
