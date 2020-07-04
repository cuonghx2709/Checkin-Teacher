//
//  DetailViewController.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 7/3/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var disposeBag = DisposeBag()
    var refreshControl = UIRefreshControl()
    var loadTrigger = PublishSubject<Void>()
    var course: Course!
    var student: Student!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupBinding()
        loadTrigger.onNext(())
    }
    
    private func configView() {
        collectionView.register(cellType: DetailCollectionViewCell.self)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setupBinding() {
        loadTrigger.asDriver(onErrorDriveWith: .empty())
        .flatMapLatest {[weak self] _ -> Driver<[Photo]> in
            guard let courseId = self?.course.id, let studentId = self?.student.id else { return .empty() }
            return APIClient.getPhoto(courseId: courseId, studentId: studentId)
                .do(onNext: {[weak self] data in
                    if data.isEmpty {
                        self?.collectionView.setEmptyMessage("Không có dữ liệu")
                    } else {
                        self?.collectionView.restore()
                    }
                }, onError: { [weak self] error in
                    self?.showError(message: "Đã có lỗi sảy rã hãy thử lại")
                    self?.collectionView.setEmptyMessage("Không có dữ liệu")
                    self?.collectionView.setContentOffset(.zero, animated: true)
                })
                .asDriver(onErrorJustReturn: [])
        }
        .drive(self.collectionView.rx
                .items(cellIdentifier: "\(DetailCollectionViewCell.self)")) { row, model, cell in
                    if let `cell` = cell as? DetailCollectionViewCell {
                        cell.setupBinding(photo: model)
                    }
                    cell.layoutIfNeeded()
            }
        .disposed(by: disposeBag)
    }
}

extension DetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = UIStoryboard(name: "TK", bundle: nil)
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}
