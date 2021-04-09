//
//  AlertController.swift
//  Invoice Scanner
//
//  Created by Wilhelm Thieme on 02/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit

class AlertController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var primaryButton: UIButton!
    @IBOutlet private var secondaryButton: UIButton!
    
    var dismissOnBackground = true
    var primaryButtonAction: (() -> Void)?
    var secondaryButtonAction: (() -> Void)?
    
    private let titleString: String?
    private let messageString: String?
    private let primaryString: String?
    private let secondaryString: String?
    
    init(title: String? = nil, message: String? = nil, primary: String? = nil, secondary: String? = nil) {
        titleString = title
        messageString = message
        primaryString = primary
        secondaryString = secondary
        super.init(nibName: "AlertView", bundle: nil)
        
        modalTransitionStyle = .crossDissolve
        isModalInPresentation = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentationController?.delegate = self
        
        titleLabel.text = titleString
        messageLabel.text = messageString
        primaryButton.setTitle(primaryString, for: .normal)
        secondaryButton.setTitle(secondaryString, for: .normal)
        
        if messageString == nil {
            messageLabel.removeFromSuperview()
        }
        
        if titleString == nil {
            titleLabel.removeFromSuperview()
        }
        
        if secondaryString == nil {
            secondaryButton.removeFromSuperview()
        }
        
        if primaryString == nil {
            primaryButton.removeFromSuperview()
        }
        
    }
    
    @IBAction func primaryButtonPressed() {
        primaryButtonAction?()
        dismiss(animated: true)
        
    }
    
    @IBAction func secondaryButtonPressed() {
        secondaryButtonAction?()
        dismiss(animated: true)
    }
    
    @IBAction func backgroundPressed() {
        guard dismissOnBackground else { return }
        dismiss(animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
