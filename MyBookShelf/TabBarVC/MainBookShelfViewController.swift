//
//  MainBookShelfViewController.swift
//  MyBookShelf
//
//  Created by junga oh on 2022/07/20.
//

import UIKit
import FirebaseDatabase

class MainBookShelfViewController: UIViewController {
    
    @IBOutlet weak var bugImageView: UIImageView!
    @IBOutlet weak var phraseTextView: UITextView!
    
    var imageIndex: Int?
    var strImage: String = "egg"
    
    let bookreportReference = Database.database().reference(withPath: "bookreport-list")
    
    var arrPhrase: Array<String> = [
                        "일정 연령이 지나면 독서는 창의적인 추구로부터 마음을 너무 멀어지게 만든다.\n너무 많이 읽고 자신의 뇌를 너무 적게 쓰는 사람은 누구나 게으른 사고 습관에 빠진다.",
                        "신간은 대개 1년이면 잊혀지는데\n특히 책을 빌리는 사람들에게서 잊혀진다.",
                        "책 없는 방은 영혼 없는 육체와도 같다.",
                        "이 책의 앞표지와 뒤표지는 \n너무 멀리 떨어져있다.",
                        "진정한 책을 만났을 때는 틀림이 없다.\n그것은 사랑에 빠지는 것과도 같다.",
                        "내가 책을 좋아한다는 것을 알고 \n그는 내가 내 공작의 작위보다 더 소중히 여길 책들로 \n내 서재를 채워 주었다.",
                        "책으로 한 나라의 상당 부분을 다닐 수 있다.",
                        "독서할 때 당신은\n항상 가장 좋은 친구와 함께 있다.",
                        "이 책을 읽는 것은\n첫 신을 신고 발 떼기를 기다리는 것과 같다.",
                        "한 권의 책을 읽음으로써\n자신의 삶에서 새 시대를 본 사람이 너무나 많다."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showRandomPhrase()
        bookreportReference.observe(.value) { snapshot in
            guard let snapData = snapshot.value as? [String:Any] else {
                /* db가 비어있을 때 */
                return self.bugImageView.image = UIImage(named: "egg") }
            let data = try! JSONSerialization.data(withJSONObject: Array(snapData.values), options: [])
            do {
                let decoder = JSONDecoder()
                let reportList = try decoder.decode([saveData].self, from: data)
                self.imageIndex = reportList.count
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
                        /* db child수(독서 리포트)에 따른 캐릭터 성장 */
                        switch self.imageIndex! {
                        case 0:
                            self.strImage = "egg"
                        case 1...5:
                            self.strImage = "crackegg"
                        case 6...10:
                            self.strImage = "baby"
                        case 11...20:
                            self.strImage = "kid"
                        case 21...30:
                            self.strImage = "student"
                        case 31...:
                            self.strImage = "adult"
                        default:
                            self.strImage = "egg"
                        }
                        print(self.strImage)
                        self.bugImageView.image = UIImage(named: self.strImage)
                    }
        }
    }
    /* 명언 랜덤으로 보여주기 메서드 */
    func showRandomPhrase() {
        var RandomNum = Int.random(in: 0...9)
        self.phraseTextView.text = arrPhrase[RandomNum]
    }
}
