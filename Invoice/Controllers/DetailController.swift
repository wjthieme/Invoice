//
//  DetailController.swift
//  Invoice
//
//  Created by Wilhelm Thieme on 06/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit

class DetailController: UIViewController, UIScrollViewDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return traitCollection.userInterfaceStyle == .dark ? .darkContent : .lightContent }
    
    @IBOutlet private var titleButton: UIButton!
    @IBOutlet private var dateButton: UIButton!
    @IBOutlet private var amountButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    
    private let expenseItem: ExpenseItem
    
    private var scale: CGPoint = .zero
    private var offset: CGPoint = .zero
    
    private var boundingBoxes: [UIButton] = []
    
    init(item: ExpenseItem) {
        self.expenseItem = item
        super.init(nibName: "DetailView", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleButton.setTitle(expenseItem.title, for: .normal)
        dateButton.setTitle(localizedDate(expenseItem.date ?? Date(), dateStyle: .full), for: .normal)
        amountButton.setTitle(expenseItem.amount?.localized, for: .normal)
        imageView.image = UIImage(data: expenseItem.image)
//        scrollView.zoomScale = 0.8
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let image = imageView.image else { return }
        
        let screenAspect = imageView.frame.width / imageView.frame.height
        let imageAspect = image.size.width / image.size.height
        
        let width = imageAspect > screenAspect ? imageView.frame.width : imageView.frame.height * imageAspect
        let height = imageAspect > screenAspect ? imageView.frame.width / imageAspect : imageView.frame.height
        
        let xScale = width / image.size.width
        let yScale = height / image.size.height
        let newScale = CGPoint(x: xScale, y: yScale)
        
        let xOffset = imageView.frame.width * 0.5 - width * 0.5
        let yOffset = imageView.frame.height * 0.5 - height * 0.5
        let newOffset = CGPoint(x: xOffset, y: yOffset)
        
        if scale != newScale && offset != newOffset {
            scale = newScale
            offset = newOffset
            redrawBoundingBoxes()
        }
    }
    
    private func redrawBoundingBoxes() {
        boundingBoxes.forEach { $0.removeFromSuperview() }
        boundingBoxes = []
        expenseItem.amounts.enumerated().forEach { createBoundingBox($0.element.rect, 1, $0.offset) }
        expenseItem.dates.enumerated().forEach { createBoundingBox($0.element.rect, 2, $0.offset) }
        expenseItem.titles.enumerated().forEach { createBoundingBox($0.element.rect, 3, $0.offset) }
    }
    
    private func createBoundingBox(_ r: CGRect, _ group: Int, _ tag: Int) {
        let p = CGFloat(2)
        
        let x = r.origin.x * scale.x + offset.x - p
        let y = r.origin.y * scale.y + offset.y - p
        let w = r.width * scale.x + p * 2
        let h = r.height * scale.y + p * 2
        
        let button = UIButton()
        button.layer.cornerRadius = p
        button.tag = group >< tag
        button.addTarget(self, action: #selector(squareButtonPressed), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.frame = CGRect(x: x, y: y, width: w, height: h)
        
        switch group {
        case 1: button.layer.borderColor = UIColor.systemRed.cgColor
        case 2: button.layer.borderColor = UIColor.systemBlue.cgColor
        case 3: button.layer.borderColor = UIColor.systemGreen.cgColor
        default: break
        }
        
        imageView.addSubview(button)
        boundingBoxes.append(button)
    }
    
    @IBAction private func backPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func labelButtonPressed(sender: UIButton) {
        //TODO: <- Buttons are userinteractiondisabled
        switch sender.tag {
        case 1:
            print("title")
        case 2:
            print("date")
        case 3:
            print("amount")
        default: return
        }
    }
    
    @objc private func squareButtonPressed(sender: UIButton) {
        //TODO: Doesn't get called yet
        let (group, elem) = <>sender.tag
        switch group {
        case 1:
            expenseItem.title = expenseItem.titles[elem].content
            titleButton.setTitle(expenseItem.title, for: .normal)
        case 2:
            expenseItem.date = expenseItem.dates[elem].content
            dateButton.setTitle(localizedDate(expenseItem.date ?? Date(), dateStyle: .full), for: .normal)
        case 3:
            expenseItem.amount = expenseItem.amounts[elem].content
            amountButton.setTitle(expenseItem.amount?.localized, for: .normal)
        default: return
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
