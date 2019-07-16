//
//  ViewController.swift
//  SupriseMeTest
//
//  Created by Владислав Дьяков on 12.07.2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftEntryKit
import Alamofire
import ActiveLabel
import SwiftyJSON

class ViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.delegate = self
        }
    }
    
    let url = "https://app.surprizeme.ru/api/login_magic/"
    let service = "myService"
    let account = "myAccount"
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides:[Intro] = []
    let loginViewModal = loginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)
        view.bringSubviewToFront(pageControl)
    }
    
    func createSlides() -> [Intro] {
        let slide1:Intro = Bundle.main.loadNibNamed("Intro", owner: self, options: nil)?.first as! Intro
        slide1.title.text = "Self-guided tours 2"
        slide1.descriptionLabel.text = "Patrician, gladiator fights, Emperors and Senate. Let's try to find out something interesting about Ancient Rome."
        slide1.actionButton.layer.backgroundColor = UIColor.rasberryBtn.cgColor
        slide1.actionButton.setTitle("Let me in", for: .normal)
        slide1.actionButton.addTarget(self, action: #selector(letMeIn), for: .touchUpInside)
        slide1.skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)
        slide1.nextSlideButton.tag = 1
        slide1.nextSlideButton.addTarget(self, action: #selector(nextSilde(_:)), for: .touchUpInside)
        slide1.enterTourCodeButton.addTarget(self, action: #selector(tourCode), for: .touchUpInside)
        
        let slide2:Intro = Bundle.main.loadNibNamed("Intro", owner: self, options: nil)?.first as! Intro
        slide2.title.text = "Keep in touch"
        slide2.descriptionLabel.text = "Patrician, gladiator fights, Emperors and Senate. Let's try to find out something interesting about Ancient Rome."
        slide2.actionButton.layer.backgroundColor = UIColor.blueBtn.cgColor
        slide2.actionButton.setTitle("Allow push notifications", for: .normal)
        slide2.actionButton.addTarget(self, action: #selector(registerForPushNotifications), for: .touchUpInside)
        slide2.skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)
        slide2.nextSlideButton.tag = 2
        slide2.nextSlideButton.addTarget(self, action: #selector(nextSilde(_:)), for: .touchUpInside)
        slide2.enterTourCodeButton.addTarget(self, action: #selector(tourCode), for: .touchUpInside)
        
        let slide4:Intro = Bundle.main.loadNibNamed("Intro", owner: self, options: nil)?.first as! Intro
        slide4.title.text = "Keep in touch"
        slide4.descriptionLabel.text = "Patrician, gladiator fights, Emperors and Senate. Let's try to find out something interesting about Ancient Rome."
        slide4.actionButton.isEnabled = false
        slide4.actionButton.isHidden = true
        slide4.skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)
        slide4.nextSlideButton.isEnabled = false
        slide4.nextSlideButton.layer.opacity = 0.25
        slide4.enterTourCodeButton.addTarget(self, action: #selector(tourCode), for: .touchUpInside)
        let FBButton = HelpButton(frame: CGRect(x: 13, y: slide4.descriptionLabel.frame.maxY + 315, width: self.view.frame.width/2 - 19, height: 60))
        FBButton.addShadow()
        FBButton.backgroundColor = UIColor.white
        FBButton.setTitle("Facebook", for: .normal)
        FBButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        FBButton.setTitleColor(UIColor.facebook, for: .normal)
        slide4.addSubview(FBButton)
        let VKButton = HelpButton(frame: CGRect(x: self.view.frame.width/2 + 6, y: slide4.descriptionLabel.frame.maxY + 315, width: self.view.frame.width/2 - 19, height: 60))
        VKButton.addShadow()
        VKButton.backgroundColor = UIColor.white
        VKButton.setTitle("VK", for: .normal)
        VKButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        VKButton.setTitleColor(UIColor.vk, for: .normal)
        slide4.addSubview(VKButton)
        let TwitterButton = HelpButton(frame: CGRect(x: 13, y: slide4.descriptionLabel.frame.maxY + 387, width: self.view.frame.width/2 - 19, height: 60))
        TwitterButton.addShadow()
        TwitterButton.backgroundColor = UIColor.white
        TwitterButton.setTitle("Twitter", for: .normal)
        TwitterButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        TwitterButton.setTitleColor(UIColor.twitter, for: .normal)
        slide4.addSubview(TwitterButton)
        let GoogleButton = HelpButton(frame: CGRect(x: self.view.frame.width/2 + 6, y: slide4.descriptionLabel.frame.maxY + 387, width: self.view.frame.width/2 - 19, height: 60))
        GoogleButton.addShadow()
        GoogleButton.backgroundColor = UIColor.white
        GoogleButton.setTitle("Google", for: .normal)
        GoogleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        GoogleButton.setTitleColor(UIColor.google, for: .normal)
        slide4.addSubview(GoogleButton)
        let EmailButton = HelpButton(frame: CGRect(x: 13, y: slide4.descriptionLabel.frame.maxY + 459, width: self.view.frame.width - 26, height: 60))
        EmailButton.addShadow()
        EmailButton.backgroundColor = UIColor.white
        EmailButton.setTitle("Email", for: .normal)
        EmailButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        EmailButton.setTitleColor(UIColor.darkGray, for: .normal)
        EmailButton.addTarget(self, action: #selector(showAgreement), for: .touchUpInside)
        slide4.addSubview(EmailButton)
        
        return [slide1, slide2, slide4]
    }
    
    func setupSlideScrollView(slides: [Intro]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    /*
     * default function called when view is scolled. In order to enable callback
     * when scrollview is scrolled, the below code needs to be called:
     * slideScrollView.delegate = self or
     */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        
        if (percentageHorizontalOffset > 0 && percentageHorizontalOffset <= 0.5) {
            slides[0].textView.transform = CGAffineTransform(scaleX: (0.5-percentageHorizontalOffset)/0.5, y: (0.5-percentageHorizontalOffset)/0.5)
            slides[1].textView.transform = CGAffineTransform(scaleX: percentageHorizontalOffset/0.5, y: percentageHorizontalOffset/0.5)
        } else if (percentageHorizontalOffset > 0.5 && percentageHorizontalOffset <= 1) {
            slides[1].textView.transform = CGAffineTransform(scaleX: (1-percentageHorizontalOffset)/0.5, y: (1-percentageHorizontalOffset)/0.5)
            slides[2].textView.transform = CGAffineTransform(scaleX: percentageHorizontalOffset/1, y: percentageHorizontalOffset/1)
        }
    }
    
    @objc func skip() {
        performSegue(withIdentifier: "toMenu", sender: self)
    }
    
    @objc func tourCode() {
        performSegue(withIdentifier: "tourCode", sender: self)
    }
    
    @objc func nextSilde(_ sender: UIButton) {
        scrollToPage(page: sender.tag, animated: true)
    }
    
    @objc func letMeIn() {
        scrollToPage(page: 2, animated: true)
    }
    
    @objc func pageControlTapHandler(sender: UIPageControl) {
        scrollToPage(page: sender.currentPage, animated: true)
    }
    
    @objc func showAgreement() {
        var attributes = EKAttributes.centerFloat
        attributes.windowLevel = .normal
        attributes.hapticFeedbackType = .success
        attributes.position = .center
        attributes.roundCorners = .all(radius: 16)
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .absorbTouches
        attributes.displayDuration = .infinity
        attributes.entryBackground = .color(color: .white)
        attributes.screenBackground = .color(color: UIColor(white: 0.2, alpha: 0.5))
        showModalView(attributes: attributes)
    }
    
    @objc func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                granted, error in
                print("Permission granted: \(granted)")
        }
    }
    
    @objc func agreePressed() {
        var attributes = EKAttributes.bottomFloat
        attributes.hapticFeedbackType = .success
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: UIColor(white: 0.2, alpha: 0.5))
        attributes.entryBackground = .color(color: .white)
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .edgeCrossingDisabled(swipeable: true)
        attributes.roundCorners = .top(radius: 40)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 6))
        attributes.positionConstraints.size = .init(width: .fill, height: .ratio(value: 0.9))
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.safeArea = .overridden
        
        for view in loginViewModal.subviews[0].subviews[0].subviews {
            if view is ActionButton {
                view.backgroundColor = UIColor.blueBtn
                (view as! ActionButton).addTarget(self, action: #selector(authButtonPressed), for: .touchUpInside)
            } else if view is UIButton {
                (view as! UIButton).addTarget(self, action: #selector(closeModals), for: .touchUpInside)
                view.backgroundColor = UIColor(rgb: 0xf5f5f5)
                view.layer.cornerRadius = 24
            } else if view is UITextField {
                (view as! UITextField).delegate = self
            }
        }
        
        SwiftEntryKit.display(entry: loginViewModal, using: attributes)
    }
    
    @objc func authButtonPressed() {
        var email = ""
        var password = ""
        var errors: [String] = []
        for view in loginViewModal.subviews[0].subviews[0].subviews {
            if view is UITextField {
                if (view as! UITextField).textContentType == .emailAddress {
                    email = (view as! UITextField).text!
                    if email.isEmpty {
                        errors.append("Email is required")
                        (view as! UITextField).shake(with: "Email is required")
                    } else if !isValidEmail(emailStr: email) {
                        (view as! UITextField).shake(with: "Email is invalid")
                        errors.append("Email is invalid")
                    }
                } else if (view as! UITextField).textContentType == .password {
                    password = (view as! UITextField).text!
                    if password.isEmpty {
                        errors.append("Password is required")
                        (view as! UITextField).shake(with: "Password is required")
                    }
                }
            }
        }
        if errors.isEmpty {
            SwiftEntryKit.dismiss()
            sendCredentials(email: email, password: password)
        }
    }
    
    @objc func closeModals() {
        SwiftEntryKit.dismiss()
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: animated)
    }
    
    func showModalView(attributes: EKAttributes) {
        
        let contentView = agreementView()
        
        for view in contentView.subviews[0].subviews {
            if view is ActionButton {
                view.backgroundColor = UIColor.rasberryBtn
                (view as! ActionButton).addTarget(self, action: #selector(agreePressed), for: .touchUpInside)
            } else if view is UIButton {
                (view as! UIButton).addTarget(self, action: #selector(closeModals), for: .touchUpInside)
            } else if view is ActiveLabel {
                let terms = ActiveType.custom(pattern: "\\sTerms of Service\\b")
                let policy = ActiveType.custom(pattern: "\\sPrivacy Policy\\b")
                (view as! ActiveLabel).enabledTypes = [terms, policy]
                (view as! ActiveLabel).customize { label in
                    label.customColor[terms] = UIColor.purple
                    label.customColor[policy] = UIColor.purple
                    label.handleCustomTap(for: terms) { element in
                        UIApplication.shared.open(URL(string: "https://surprizeme.ru")!)
                    }
                    label.handleCustomTap(for: policy) { element in
                        UIApplication.shared.open(URL(string: "https://surprizeme.ru")!)
                    }
                }
            }
        }
        
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    private func sendCredentials(email: String, password: String) {
        Alamofire.request(URL(string: url + password)!, method: .post, parameters: ["username": email], encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.isSuccess {
                let token: JSON = JSON(response.result.value!)
                guard let _ = token["type"].string else
                {
                    let alert = UIAlertController(title: "Error", message: "Wrong email or password", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Fix", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                KeychainService.savePassword(service: self.service, account: self.account, data: password)
                self.skip()
            }
            else {
                let alert = UIAlertController(title: "Error", message: response.result.error as? String, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Fix", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.textContentType == .password {
            authButtonPressed()
        }
        return true
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
}
