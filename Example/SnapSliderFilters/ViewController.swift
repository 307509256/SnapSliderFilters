//
//  ViewController.swift
//  SnapSliderFilters
//
//  Created by Paul Jeannot on 05/04/2016.
//  Copyright (c) 2016 Paul Jeannot. All rights reserved.
//

import UIKit
import SnapSliderFilters

class ViewController: UIViewController {
    
    var slider:SNSlider = SNSlider(frame: CGRect(origin: CGPointZero, size: SNUtils.screenSize))
    var textField:SNTextField?
    
    var data:[SNFilter] = []
    
    var tapGesture:UITapGestureRecognizer = UITapGestureRecognizer()
    
    //MARK: - Overriden functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
        
        self.initSlider()
        self.initTextField()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let textField = self.textField {
            NSNotificationCenter.defaultCenter().removeObserver(textField)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.setAnimationsEnabled(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createData() {
        self.data = SNFilter.generateFilters(SNFilter(frame: self.slider.frame, withImage: UIImage(named: "pic")!), filters: SNFilter.filterNameList)
        
        self.data[3].addSticker(SNSticker(frame: CGRect(x: 20, y: 00, width: 140, height: 140), image: UIImage(named: "stick")!))
        
        self.data[1].addSticker(SNSticker(frame: CGRect(x: 195, y: 30, width: 90, height: 90), image: UIImage(named: "stick")!))
        
        self.data[2].addSticker(SNSticker(frame: CGRect(x: 30, y: 100, width: 250, height: 250), image: UIImage(named: "stick")!))
    }
    
    func initSlider() {
        
        self.createData()
        self.slider.dataSource = self
        self.slider.userInteractionEnabled = true
        self.view.addSubview(slider)
        self.slider.reloadData()
    }
    
    func initTextField() {
        self.textField = SNTextField(y: SNUtils.screenSize.height/2, width: SNUtils.screenSize.width, heightOfScreen: SNUtils.screenSize.height)
        textField!.layer.zPosition = 100
        self.view.addSubview(textField!)
        
        tapGesture.delegate = self
        self.slider.addGestureRecognizer(tapGesture)
        
        NSNotificationCenter.defaultCenter().addObserver(self.textField!, selector: #selector(SNTextField.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self.textField!, selector: #selector(SNTextField.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self.textField!, selector: #selector(SNTextField.keyboardTypeChanged(_:)), name: UIKeyboardDidShowNotification, object: nil)
    }
}

//MARK: - Extension SNSlider DataSource

extension ViewController: SNSliderDataSource {
    
    func numberOfSlides(slider: SNSlider) -> Int {
        return data.count
    }
    
    func slider(slider: SNSlider, slideAtIndex index: Int) -> SNFilter {
        
        return data[index]
    }
    
    func startAtIndex(slider: SNSlider) -> Int {
        return 0
    }
}

//MARK: - Extension Gesture Recognizer Delegate and touch Handler for TextField

extension ViewController: UIGestureRecognizerDelegate {
    
    internal func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.textField?.handleTap()
    }
}