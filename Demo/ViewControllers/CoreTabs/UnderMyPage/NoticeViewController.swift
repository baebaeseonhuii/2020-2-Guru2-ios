//
//  NoticeViewController.swift
//  Demo
//
//  Created by apple on 2021/02/09.
//

import UIKit

class NoticeViewController: UIViewController {

    var notices = ["공지사항5", "공지사항4", "공지사항3", "공지사항2", "공지사항"]
    var dates = ["2021.02.05", "2021.01.30", "2021.01.28", "2021.01.03", "2020.12.27"]
    var main = ["안녕하세요. 항상 연하늘을 사랑해주셔서 감사합니다. 2021년 3월 연하늘 어플을 업데이트 할 예정입니다.", "안녕하세요. 내 봉사활동 페이지를 My 페이지에 새로 등록하였습니다. 많은 관심 부탁드립니다.", "안녕하세요. 현재 봉사 페이지 오류의 원인을 파악 중에 있습니다. 빠른 시일 내로 수정하도록 하겠습니다.", "안녕하세요. 2021월 1월 4일 오후 2시부터 오후 5시까지 점검이 있을 예정입니다. 참고해주시길 바랍니다.", "안녕하세요. 반갑습니다. 연하늘을 이용해주셔서 감사합니다."]
        
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "공지사항"
            
    }
       
}

extension NoticeViewController: UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath) as? NoticeCell
        cell?.noticeLabel.text = notices[indexPath.row]
        cell?.dateLabel.text = dates[indexPath.row]
            
        return cell!
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "NoticeDetailViewController") as! NoticeDetailViewController
        vc.notices = notices[indexPath.row]
        vc.dates = dates[indexPath.row]
        vc.main = main[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
}


