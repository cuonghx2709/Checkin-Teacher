//
//  TKViewController.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 7/3/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

import UIKit
import Reusable
import RxCocoa
import RxSwift

final class TKViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var disposeBag = DisposeBag()
    var refreshControl = UIRefreshControl()
    var loadTrigger = PublishSubject<Void>()
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configBinding()
        loadTrigger.onNext(())
    }
    
    private func configView() {
        tableView.register(cellType: TKTableViewCell.self)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        title = Constants.Title.tk
        tableView.separatorStyle = .none
    }
    
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.endRefreshing()
        loadTrigger.onNext(())
    }
    
    private func configBinding() {
        loadTrigger.asDriver(onErrorDriveWith: .empty())
            .flatMapLatest {[weak self] _ -> Driver<[Student]> in
                guard let courseId = self?.course.id else { return .empty() }
                return APIClient.getCheckin(courseId: courseId)
                    .do(onNext: {[weak self] data in
                        if data.isEmpty {
                            self?.tableView.setEmptyMessage("Không có dữ liệu")
                        } else {
                            self?.tableView.restore()
                            self?.tableView.separatorStyle = .none
                        }
                    }, onError: { [weak self] error in
                        self?.showError(message: "Đã có lỗi sảy rã hãy thử lại")
                        self?.tableView.setEmptyMessage("Không có dữ liệu")
                        self?.tableView.setContentOffset(.zero, animated: true)
                    })
                    .asDriver(onErrorJustReturn: [])
            }
            .drive(self.tableView.rx
                    .items(cellIdentifier: "\(TKTableViewCell.self)")) {[weak self] row, model, cell in
                        if let `cell` = cell as? TKTableViewCell, let `self` = self {
                            cell.setupBinding(student: model, course: self.course)
                        }
                }
            .disposed(by: disposeBag)
    }
}

extension TKViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(for: indexPath, cellType: TKTableViewCell.self)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension TKViewController: StoryboardSceneBased {
    static var sceneStoryboard = UIStoryboard(name: "TK", bundle: nil)
}

