//
//  CreateViewController.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 7/4/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

import UIKit
import Reusable

final class CreateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        title = Constants.Title.create
    }
}

extension CreateViewController: StoryboardSceneBased {
    static var sceneStoryboard = UIStoryboard(name: "Create", bundle: nil)
}
