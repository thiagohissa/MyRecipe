//
//  RecipesViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-03.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties
    var isCooking: Bool!
    @IBOutlet weak var selectionTitle: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var xibWrapView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newRecipeButton: UIButton!
    @IBOutlet weak var bottomButtonStack: UIStackView!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var ingridientsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var bglayer: CAGradientLayer!
    var arrayOfRecipes: [Recipe]!
    var recipe: Recipe!
    
    //Timer Properties
    var TIMER_ON: Bool!
    let timerPopUp = TimerPopUp.instanceFromNib() as! TimerPopUp
    let grayview = GrayLayer.instanceFromNib()
    var timer: Timer?
    var hour: Int?
    var minute: Int?
    var second: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isCooking = false
        self.arrayOfRecipes = DataManager.getArrayOfRecipes()
        self.prepareUI()
        self.tableView.estimatedRowHeight = 120
        self.TIMER_ON = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(receivedNotificationToRemoveTimerPopUp), name: NSNotification.Name(rawValue: "REMOVE_TIMER_POP_UP_NOTIFICATION"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startTimer), name: NSNotification.Name(rawValue: "START_TIMER_NOTIFICATION"), object: nil)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "REMOVE_TIMER_POP_UP_NOTIFICATION"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "START_TIMER_NOTIFICATION"), object: nil)
    }
    
    func prepareUI(){
        // BG Color
        let gradientcolor = Color.init(top: UIColor.init(red: 254/255, green: 184/255, blue: 141/255, alpha: 0.8), bottom: UIColor.init(red: 246/255, green: 133/255, blue: 148/255, alpha: 0.8))
        self.backgroundView.backgroundColor = UIColor.clear
        self.bglayer = gradientcolor.gl
        self.bglayer.frame = self.view.frame
        self.backgroundView.layer.insertSublayer(bglayer, at: 0)
        // Xib Wrapper Edge
        self.xibWrapView.layer.cornerRadius = 8
        let maskPath = UIBezierPath(roundedRect: self.xibWrapView.bounds, byRoundingCorners: [.topLeft], cornerRadii: CGSize(width: 100, height: 100))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.xibWrapView.layer.mask = shape
        // Buttons
        self.newRecipeButton.layer.cornerRadius = 18
        self.timerButton.layer.cornerRadius = 18
        self.ingridientsButton.layer.cornerRadius = 18
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isCooking {
            return self.recipe.steps.count
        }
        return self.arrayOfRecipes.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !self.isCooking {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! RecipeCell
            cell.name.text = "\(self.arrayOfRecipes[indexPath.section].name) "
            cell.briefDescription.text = self.arrayOfRecipes[indexPath.section].briefDescription
            cell.minute.text = "Ready in \(String(self.arrayOfRecipes[indexPath.section].cookingTime))min"
            cell.updateConstraintsIfNeeded()
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! CookingCell
            cell.stepText.text = self.recipe.steps[indexPath.section]
            cell.stepLabelCount.text = "Step \(indexPath.section+1)"
            cell.updateConstraintsIfNeeded()
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 20))
        header.backgroundColor = UIColor.clear
        return header
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.isCooking {
            self.recipe = self.arrayOfRecipes[indexPath.section]
            self.isCooking = true
            self.bottomButtonStack.alpha = 0
            self.bottomButtonStack.isHidden = false
            UIView.animate(withDuration: 1, animations: {
                self.tableView.alpha = 0
                self.selectionTitle.alpha = 0
                self.newRecipeButton.alpha = 0
            })
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                self.tableView.reloadData()
                self.selectionTitle.text = self.arrayOfRecipes[indexPath.section].name.uppercased()
                UIView.animate(withDuration: 0.5, animations: {
                    self.tableView.alpha = 1
                    self.selectionTitle.alpha = 1
                    self.bottomButtonStack.alpha = 1
                })
            })
        }
        else{
            let cell = self.tableView.cellForRow(at: indexPath) as! CookingCell
            cell.circleView.backgroundColor = UIColor.init(red: 244/255, green: 146/255, blue: 158/255, alpha: 1.0)
            let scrollIndex = IndexPath.init(row: indexPath.row, section: indexPath.section+1)
            self.tableView.scrollToRow(at: scrollIndex, at: UITableViewScrollPosition.top, animated: true)
        }
    }

    //MARK: IBAction
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func heartButtonTapped(_ sender: UIButton) {
    }
    @IBAction func newRecipeTapped(_ sender: UIButton) {
    }
    @IBAction func ingridientsTapped(_ sender: UIButton) {
    }
    @IBAction func timerTapped(_ sender: UIButton) {
        self.presentTimerPopUp()
    }
    
    
    //MARK: Timer
    @objc func presentTimerPopUp(){
        self.timerPopUp.center.x = self.view.center.x
        self.timerPopUp.center.y = 800
        self.view.addSubview(self.grayview)
        self.view.addSubview(self.timerPopUp)
        self.tabBarController?.tabBar.isHidden = true
        if self.TIMER_ON {
            self.timerPopUp.cancelLabel.isHidden = false
            self.timerPopUp.datePicker.isHidden = true
            self.timerPopUp.startButton.setTitle("Cancel Timer", for: .normal)
        }
        else{
            self.timerPopUp.cancelLabel.isHidden = true
            self.timerPopUp.datePicker.isHidden = false
            self.timerPopUp.startButton.setTitle("Start Timer", for: .normal)
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 3, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.timerPopUp.center.y = self.view.frame.height - (self.timerPopUp.frame.height/2) - 20
        }, completion: nil)
    }
    
    @objc func receivedNotificationToRemoveTimerPopUp() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 3, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.timerPopUp.center.y = 1200
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.timerPopUp.removeFromSuperview()
            self.grayview.removeFromSuperview()
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    @objc func startTimer(){
        // here we set the current date
        if self.TIMER_ON {
            self.timer?.invalidate()
            self.timer = nil
            self.timerButton.backgroundColor = UIColor.init(red: 56/255, green: 56/255, blue: 56/255, alpha: 1.0)
            self.timerButton.setTitleColor(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), for: .normal)
//            self.timerImage.image = UIImage.init(named: "icon_timerOFF")
//            self.timerImage.alpha = 0.6
            self.timerButton.setTitle("Timer", for: .normal)
            self.TIMER_ON = false
        }
        else{
            let date = Date()
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([.hour, .minute, .second], from: date)
            let currentDate = calendar.date(from: components)
            // here we set the due date. When the timer is supposed to finish
            let timerDate = self.timerPopUp.datePicker.date
            // Here we compare the two dates
            let difference = timerDate.timeIntervalSince(currentDate!)
            let differenceDate = Date.init(timeInterval: difference, since: currentDate!)
            let differenceComponents = calendar.dateComponents([.hour,.minute,.second], from: differenceDate)
            self.hour = differenceComponents.hour ?? 0
            self.minute = differenceComponents.minute ?? 0
            self.second = 0
            // UI
            self.timerButton.backgroundColor = UIColor.init(red: 246/255, green: 133/255, blue: 148/255, alpha: 1.0)
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRunDown), userInfo: nil, repeats: true)
            }
            self.TIMER_ON = true
        }
    }
    
    @objc func timerRunDown(){
        
        self.second = self.second! - 1
        if self.second! < 0 && self.minute! > 0 {
            self.second = 59
            if self.minute! == 0 && self.hour! > 0{
                self.minute = 59
                self.hour = self.hour! - 1
            }
            self.minute = self.minute! - 1
        }
        if self.second! <= 0 && self.minute! <= 0 && self.hour! > 0 {
            self.second = 59
            self.minute = 59
            self.hour = self.hour! - 1
        }
        
        // Display String
        var hourString = "\(self.hour!)"
        var minuteString = "\(self.minute!)"
        var secondString = "\(self.second!)"
        if hour! <= 10 {
            hourString = "0\(self.hour!)"
        }
        if minute! <= 10 {
            minuteString = "0\(self.minute!)"
        }
        if second! <= 10 {
            secondString = "0\(self.second!)"
        }

        if self.hour != nil && self.hour ?? 0 <= 0 {
            self.timerButton.setTitle("\(minuteString):\(secondString)", for: UIControlState.normal)
        }
        else{
            self.timerButton.setTitle("\(hourString):\(minuteString):\(secondString)", for: UIControlState.normal)
        }
        
        if self.second! <= 0 && self.minute! <= 0 && self.hour! <= 0 {
            print("Times up! - Display Local Notification")
            if self.timer != nil {
                self.timer?.invalidate()
                self.timer = nil
            }
            self.timerButton.backgroundColor = UIColor.init(red: 56/255, green: 56/255, blue: 56/255, alpha: 1.0)
            self.timerButton.setTitleColor(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), for: .normal)
            self.timerButton.setTitle("Timer", for: .normal)
        }
    }
    
}

class RecipeCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var minute: UILabel!
    @IBOutlet weak var briefDescription: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    
}

class CookingCell: UITableViewCell {
    @IBOutlet weak var stepLabelCount: UILabel!
    @IBOutlet weak var stepText: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.circleView.layer.borderWidth = 1
        self.circleView.layer.borderColor = UIColor.init(red: 244/255, green: 146/255, blue: 158/255, alpha: 1.0).cgColor
        self.circleView.layer.cornerRadius = self.circleView.frame.height/2
    }
    
}
