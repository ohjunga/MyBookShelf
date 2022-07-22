//
//  SettingViewController.swift
//  MyBookShelf
//
//  Created by junga oh on 2022/07/20.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    /* 책벌레 도감 뷰컨 띄우기*/
    @IBAction func tapBookBugGrowing(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let BugViewController = storyboard.instantiateViewController(identifier: "BugViewController") as? BugViewController else { return }
        self.show(BugViewController, sender: nil)
    }
    /* 개발자에게 메일보내기 */
    @IBAction func tapSendFeedback(_ sender: UIButton) {
        launchEmail()
    }
}
extension SettingViewController: MFMailComposeViewControllerDelegate {
    func launchEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            print("doesn't set mail address")
            return
        }
        let emailTitle = "앱 피드백"
        let messageBody =
                """
                OS Version: \(UIDevice.current.systemVersion)
                Device: (디바이스 알아내는 기능)
                메일 내용 템플릿
                """
        let toRecipents = ["메일주소@도메인.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: nil)
    }
}
