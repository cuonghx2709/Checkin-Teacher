//
//  TKTableViewCell.swift
//  Checkin-Teacher
//
//  Created by cuong hoang on 7/3/20.
//  Copyright © 2020 cuong hoang. All rights reserved.
//

import UIKit
import Reusable

class TKTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    private var student: Student!
    private var course: Course!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupBinding(student: Student, course: Course) {
        self.student = student
        self.course = course
        nameLabel.text = student.name
        countLabel.text = String(format: "%d", student.count ?? 0)
    }
    @IBAction private func detailButtonAction(_ sender: UIButton) {
        let detailVC = DetailViewController.instantiate()
        detailVC.course = course
        detailVC.student = student
        parentViewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
