//
//  HomeViewController.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 7/2/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var disposeBag = DisposeBag()
    var refreshControl = UIRefreshControl()
    var loadTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configBinder()
        loadTrigger.onNext(())
    }
    
    private func configView() {
        title = Constants.Title.home
        tableView.rowHeight = 109
        tableView.register(cellType: HomeTableViewCell.self)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: "#32a5d8")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let button = UIBarButtonItem(image: UIImage(named: "more_ic_3"), style: .done, target: self, action: #selector(addTapped(sender:)))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func addTapped(sender: UIBarButtonItem) {
        let sheet = UIAlertController(title: "Hãy lựa chọn", message: nil, preferredStyle: .actionSheet)
        let logout = UIAlertAction(title: "Đăng xuất", style: .destructive) { _ in
            
        }
        
        let create = UIAlertAction(title: "Tạo khoá học mới", style: .default) {[weak self] _ in
            let createdVC = CreateViewController.instantiate()
            self?.navigationController?.pushViewController(createdVC, animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(create)
        sheet.addAction(logout)
        sheet.addAction(cancel)
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.endRefreshing()
        loadTrigger.onNext(())
    }
    
    private func configBinder() {
        loadTrigger.asDriver(onErrorDriveWith: .empty())
            .flatMapLatest { _ -> Driver<[Course]> in
                guard let email = SupportAuthManager.shared.getEmail() else { return .empty()}
                return APIClient.getCourses(email: email)
                    .do(onNext: {[weak self] data in
                        if data.isEmpty {
                            self?.tableView.setEmptyMessage("Không có dữ liệu")
                        } else {
                            self?.tableView.restore()
                        }
                    }, onError: { [weak self] error in
                        self?.showError(message: "Đã có lỗi sảy rã hãy thử lại")
                        self?.tableView.setEmptyMessage("Không có dữ liệu")
                        self?.tableView.setContentOffset(.zero, animated: true)
                    })
                    .asDriver(onErrorJustReturn: [])
            }
            .drive(self.tableView.rx
                    .items(cellIdentifier: "\(HomeTableViewCell.self)")) { row, model, cell in
                        if let `cell` = cell as? HomeTableViewCell {
                            cell.binding(course: model)
                        }
                }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        let createdVC = CreateViewController.instantiate()
        self.navigationController?.pushViewController(createdVC, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sheet = UIAlertController(title: "Hãy lựa chọn", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "Xoá khoá học", style: .destructive, handler: nil)
        let message = UIAlertAction(title: "Nhắn tin", style: .default, handler: nil)
        
        sheet.addAction(cancel)
        sheet.addAction(message)
        sheet.addAction(delete)
        
        self.present(sheet, animated: true, completion: nil)
    }
}

extension HomeViewController: StoryboardSceneBased {
    static var sceneStoryboard = UIStoryboard(name: "Home", bundle: nil)
}
