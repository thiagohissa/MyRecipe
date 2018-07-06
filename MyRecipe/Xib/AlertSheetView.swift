//
//  AlertSheetView.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-06.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class AlertSheetView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "AlertSheet", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.doneButton.layer.cornerRadius = 18
        self.layer.cornerRadius = 20
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft], cornerRadii: CGSize(width: 100, height: 100))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }

    @IBAction func doneTapped(_ sender: Any) {
        let notificationName = Notification.Name("REMOVE_ALERT_NOTIFICATION")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
}
