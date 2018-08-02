//
//  GrayLayer.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-04.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class GrayLayer: UIView {

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "GrayLayer", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        let notificationName1 = Notification.Name("REMOVE_TIMER_POP_UP_NOTIFICATION")
        NotificationCenter.default.post(name: notificationName1, object: nil)
        let notificationName2 = Notification.Name("REMOVE_ALERT_NOTIFICATION")
        NotificationCenter.default.post(name: notificationName2, object: nil)
        let notificationName3 = Notification.Name("REMOVE_SHAREVIEW_NOTIFICATION")
        NotificationCenter.default.post(name: notificationName3, object: nil)
    }
    
}
