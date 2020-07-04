//
//  CheckinViewController.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 7/3/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

import UIKit
import Reusable
import FirebaseDatabase

final class CheckinViewController: UIViewController {
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var totalStudentLabel: UILabel!
    @IBOutlet private weak var currentLabel: UILabel!
    
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectFirebase()
    }
    
    private func connectFirebase() {
        guard let courseID = course.id else { return }
        let ref = Database.database().reference()
        ref.child("CheckIn").child("Course_\(courseID)")
            .observe(.value, with: { [weak self] snap in
            guard let value = snap.value else { return }
            guard let jsondData = try? JSONSerialization.data(withJSONObject: value, options: []),
                let data = try? JSONDecoder().decode(CheckIn.self, from: jsondData) else {
                    return
                }
                self?.totalStudentLabel.text = data.totalStudent
                self?.currentLabel.text = data.attendStudent
        })
    }
}

extension CheckinViewController: StoryboardSceneBased {
    static var sceneStoryboard = UIStoryboard(name: "Checkin", bundle: nil)
}
