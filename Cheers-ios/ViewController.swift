//
//  ViewController.swift
//  Cheers-ios
//
//  Created by yuya on 2016/06/20.
//  Copyright © 2016年 hy. All rights reserved.
//

import UIKit
import FlatUIKit
import FBSDKCoreKit
import FBSDKLoginKit
import LTMorphingLabel

class ViewController: UIViewController, FBSDKLoginButtonDelegate, UIScrollViewDelegate, LTMorphingLabelDelegate {
    private var pageControl: UIPageControl!
    private var scrollView: UIScrollView!
    private var timer: NSTimer = NSTimer()
    var subTitleLabel: LTMorphingLabel!
    let pageSize: Int = 4
    let pageControlHeight: CGFloat = 50.0
    var visibleSize: CGSize!
    var morphingIndex = 0
    var subTitleTextArray = ["Cheers!!!", "Beer ?", "Cocktail ?", "Wine ?", "Whisky ?", "Shochu ?", "Soft Drink ?"]
    var subTitleText: String {
        get {
            if self.morphingIndex >= self.subTitleTextArray.count {
                self.morphingIndex = 0
            }
            self.morphingIndex += 1
            return self.subTitleTextArray[self.morphingIndex - 1]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.visibleSize = self.view.bounds.size
        self.setScrollView()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(self.changeSubTitleText), userInfo: nil, repeats: true)
        //Set UI parts to self.scrollView below this line.
        self.setTitle()
        self.setFBLoginButton()
        self.setDescCheersButton()
    }
    
    func setDescCheersButton() {
        let descButton: FUIButton = FUIButton(frame: CGRectMake(0, 0, 200, 50))
        descButton.buttonColor = UIColor(red: 0.6, green: 0.1, blue: 0.9, alpha: 0.5)
        descButton.shadowColor = UIColor(red: 0.7, green: 0.01, blue: 1.0, alpha: 0.7)
        descButton.shadowHeight = 3.0
        descButton.cornerRadius = 6.0
        descButton.setTitle("What is Cheers ?", forState: .Normal)
        descButton.setTitle("Description", forState: .Highlighted)
        descButton.setTitleColor(UIColor.cloudsColor(), forState: .Normal)
        descButton.setTitleColor(UIColor.greenColor(), forState: .Highlighted)
        descButton.titleLabel?.font = UIFont(name: "Courier", size: 18)
        descButton.layer.masksToBounds = true
        descButton.layer.position = CGPointMake(self.visibleSize.width / 3 + self.visibleSize.width, self.visibleSize.height / 4)
        descButton.titleLabel?.adjustsFontSizeToFitWidth = true
        descButton.addTarget(self, action: #selector(self.showDescCheersLabel), forControlEvents: .TouchUpInside)
        self.scrollView.addSubview(descButton)
        
    }
    
    func setTitle() {
        let titleLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.visibleSize.width, 200))
        titleLabel.text = "Cheers"
        titleLabel.font = UIFont(name: "Zapfino", size: 30)
        titleLabel.textColor = UIColor.amethystColor()
        titleLabel.textAlignment = .Center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.layer.position = CGPointMake(self.visibleSize.width / 2, self.visibleSize.height / 3)
        
        self.subTitleLabel = LTMorphingLabel(frame: CGRectMake(0, 0, self.visibleSize.width, 100))
        self.subTitleLabel.text = self.subTitleText
        self.subTitleLabel.center = CGPointMake(self.visibleSize.width / 2, self.visibleSize.height / 2)
        self.subTitleLabel.textColor = UIColor(red: 0.3, green: 0.1, blue: 1.0, alpha: 0.6)
        //self.subTitleLabel.backgroundColor = UIColor.blackColor()
        self.subTitleLabel.morphingEffect = .Evaporate
        self.subTitleLabel.delegate = self
        self.subTitleLabel.textAlignment = .Center
        self.subTitleLabel.font = UIFont(name: "Courier", size: 16)
        self.subTitleLabel.setNeedsLayout()
        
        self.scrollView.addSubview(titleLabel)
        self.scrollView.addSubview(self.subTitleLabel)
    }
    
    func setScrollView() {
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSizeMake(CGFloat(self.pageSize) * self.visibleSize.width, 0)
        self.pageControl = UIPageControl(frame: CGRectMake(0, self.visibleSize.height - self.pageControlHeight,
            visibleSize.width, self.pageControlHeight))
        self.pageControl.backgroundColor = UIColor(red: 0.01, green: 0.3, blue: 0.9, alpha: 0.5)
        self.pageControl.numberOfPages = self.pageSize
        self.pageControl.currentPage = 0
        self.pageControl.userInteractionEnabled = false
        self.view.addSubview(self.pageControl)
        self.view.addSubview(self.scrollView)
    }

    func setFBLoginButton() {
        for iPage in 0 ..< self.pageSize {
            let FBLoginButton: FBSDKLoginButton = FBSDKLoginButton()
            FBLoginButton.center = CGPointMake(visibleSize.width / 2 + visibleSize.width * CGFloat(iPage) , visibleSize.height - self.pageControlHeight - FBLoginButton.bounds.size.height / 2)
            FBLoginButton.delegate = self
            FBLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
            self.scrollView.addSubview(FBLoginButton)
        }
    }
    
    // Selector Method
    func changeSubTitleText() {
        self.subTitleLabel.text = self.subTitleText
    }
    func showDescCheersLabel() {
        
    }
    
    
    //Rarely Used Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            self.pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        if error != nil {
            
        }
        else if result.isCancelled {
            
        }
        else {
            if result.grantedPermissions.contains("email") {
                
            }
            // After Login
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }


}

