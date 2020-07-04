//
//  HomeTableViewCell.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 7/2/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

class HomeTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var codeLabel: UILabel!
    
    private var course: Course!
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func binding(course: Course) {
        self.course = course
        nameLabel.text = course.name
        codeLabel.text = course.code
    }
    
    @IBAction func messageAction(_ sender: UIButton) {
        let chatBoxVC = ChatLogCollectionViewController.instantiate()
        self.parentViewController?.navigationController?.pushViewController(chatBoxVC, animated: true)
    }
    
    @IBAction func checkinAction(_ sender: UIButton) {
        let checkinVC = CheckinViewController.instantiate()
        checkinVC.course = course
        self.parentViewController?.navigationController?.pushViewController(checkinVC, animated: true)
//        guard let courseId = course.id else { return }
//        APIClient.checkin(id: courseId)
//            .subscribe(onNext: {[weak self] response in
//                if response.status == 1 {
//                    self?.parentViewController?
//                        .showAutoCloseMessage(image: nil, title: nil, message: "Success", completion: nil)
//                }
//            }, onError: { [weak self] error in
//                self?.parentViewController?.showError(message: "Đã có lỗi sảy ra hãy thử lại sau.")
//            })
//            .disposed(by: disposeBag)
    }
    
    @IBAction func tkAction(_ sender: UIButton) {
        let tkVC = TKViewController.instantiate()
        tkVC.course = course
        self.parentViewController?.navigationController?.pushViewController(tkVC, animated: true)
    }
}
