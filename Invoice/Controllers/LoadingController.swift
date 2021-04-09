//
//  LoadingController.swift
//  Invoice Scanner
//
//  Created by Wilhelm Thieme on 02/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit
import VisionKit

class LoadingController: UIViewController, InvoiceRecognizerDelegate {
    
    @IBOutlet private var loader: UIImageView!
    @IBOutlet private var loaderText: UILabel!
    @IBOutlet private var cancelButton: UIButton!
    
    private let scan: VNDocumentCameraScan
    private let expenseType: ExpenseType
    
    private var cancelTimer: Timer?
    private var recognizer = InvoiceRecognizer()
    
    private var expenseItems: [ExpenseItem] = []
    
    init(scannedDocument: VNDocumentCameraScan, type: ExpenseType) {
        scan = scannedDocument
        expenseType = type
        super.init(nibName: "LoadingView", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let images = (0..<scan.pageCount).map { scan.imageOfPage(at: $0) }
        
        recognizer.delegate = self
        recognizer.perform(on: images)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startLoading), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopLoading), name: UIApplication.didEnterBackgroundNotification, object: nil)
        startLoading()
        
        unhideCancelButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        stopLoading()
        
    }
    
    @objc private func startLoading() {
        loader.image = UIImage.gifImageWithName("loading", fps: 45)
    }
    
    @objc private func stopLoading() {
        loader.image = nil
    }
    
    private func unhideCancelButton() {
        cancelButton.isHidden = true
        cancelButton.alpha = 0
        cancelTimer?.invalidate()
        cancelTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { [weak self] (timer) in
            guard let self = self else { timer.invalidate(); return }
            self.cancelButton.isHidden = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.cancelButton.alpha = 1
            }
        })
    }
    
    private func animateTextChange(to text: String) {
        UIView.transition(with: loaderText, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.loaderText.text = text
        }, completion: nil)
    }
    
    @IBAction private func cancelPressed() {
        recognizer.cancel()
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Delegate
    
    func invoiceRecognizer(_ recognizer: InvoiceRecognizer, didGetExpenseItem item: ExpenseItem) {
        expenseItems.append(item)
        animateTextChange(to: localizedString("recognitionLoader", "\(expenseItems.count)", "\(scan.pageCount)"))
        
        if expenseItems.count == scan.pageCount {
            let list = ExpenseList(items: expenseItems, type: expenseType)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.animateTextChange(to: localizedString("recognitionCompleted"))
                let controller = OverviewController(list: list)
                
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func invoiceRecognizer(_ recognizer: InvoiceRecognizer, didFailFor image: UIImage, error: Error) {
        
        Crashes.log(error: error)
        
        recognizer.cancel()
        expenseItems = []
        
        let alert = AlertController(title: localizedString("recognitionFailed"), message: localizedString("recognitionFailedMessage"), primary: localizedString("retry"), secondary: localizedString("cancel"))
        alert.primaryButtonAction = { [weak self] in
            guard let self = self else { return }
            let images = (0..<self.scan.pageCount).map { self.scan.imageOfPage(at: $0) }
            self.recognizer.perform(on: images)
            self.animateTextChange(to: localizedString("recognitionRestart"))
        }
        alert.secondaryButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        present(alert, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
