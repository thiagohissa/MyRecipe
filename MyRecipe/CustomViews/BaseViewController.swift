//
//  BaseViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-09.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let alertSheet = AlertSheetView.instanceFromNib() as! AlertSheetView
    let grayview = GrayLayer.instanceFromNib()
    var whiteView: UIView!
    let loadingScreenDuration = 0.5

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(receivedNotificationToRemoveTimerPopUp), name: NSNotification.Name(rawValue: "REMOVE_ALERT_NOTIFICATION"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "REMOVE_ALERT_NOTIFICATION"), object: nil)
    }
    
    //MARK: Alert
    func presentAlert(title: String, message: String){
        self.alertSheet.center.x = self.view.center.x
        self.alertSheet.center.y = 800
        self.view.addSubview(self.grayview)
        self.view.addSubview(self.alertSheet)
        self.alertSheet.titleLabel.text = title
        self.alertSheet.messageLabel.text = message
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 3, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alertSheet.center.y = self.view.frame.height - (self.alertSheet.frame.height/2) - 20
        }, completion: nil)
    }
    
    @objc func receivedNotificationToRemoveTimerPopUp() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 3, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alertSheet.center.y = 1200
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.alertSheet.removeFromSuperview()
            self.grayview.removeFromSuperview()
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    //MARK: Loading Gif
    func presentLoadingScreen(){
        self.whiteView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.whiteView.backgroundColor = UIColor.white
        self.whiteView.alpha = 0
        
        let webview = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200))
        let url = Bundle.main.url(forResource: "loading2", withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webview.load(data, mimeType: "image/gif", textEncodingName: "UTF-8", baseURL: NSURL() as URL)
        webview.scalesPageToFit = true
        webview.contentMode = UIViewContentMode.scaleAspectFit
        webview.backgroundColor = UIColor.clear
        self.whiteView.addSubview(webview)
        webview.center = self.whiteView.center
        
        self.view.addSubview(self.whiteView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: self.loadingScreenDuration) {
                self.whiteView.alpha = 1
            }
        }
    }
    
    func removeLoadingScreen(){
        UIView.animate(withDuration: self.loadingScreenDuration) {
            self.whiteView.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + self.loadingScreenDuration) {
            self.whiteView.removeFromSuperview()
        }
    }
    
    func loadWhiteScreenTransition(){
        self.whiteView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.whiteView.backgroundColor = UIColor.white
        self.whiteView.alpha = 0
        self.view.addSubview(self.whiteView)
        UIView.animate(withDuration: self.loadingScreenDuration) {
            self.whiteView.alpha = 1
        }
    }
    
    func removeWhiteScreenTransition(){
        self.removeLoadingScreen()
    }

   

}
