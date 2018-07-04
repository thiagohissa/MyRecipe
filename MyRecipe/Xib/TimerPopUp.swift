//
//  TimerPopUp.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-04.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class TimerPopUp: UIView {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.startButton.layer.cornerRadius = 18
        self.layer.cornerRadius = 20
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft], cornerRadii: CGSize(width: 100, height: 100))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "TimerPopUp", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    @IBAction func startTimerTapped(_ sender: Any) {
        let notificationName1 = Notification.Name("REMOVE_TIMER_POP_UP_NOTIFICATION")
        NotificationCenter.default.post(name: notificationName1, object: nil)
        let notificationName2 = Notification.Name("START_TIMER_NOTIFICATION")
        NotificationCenter.default.post(name: notificationName2, object: nil)
    }

}
