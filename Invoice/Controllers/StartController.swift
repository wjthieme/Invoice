//
//  ViewController.swift
//  Invoice Scanner
//
//  Created by Wilhelm Thieme on 02/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit
import VisionKit
import AVFoundation

class StartController: UIViewController, VNDocumentCameraViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var selectedCategory = 0
    
    init() {
        super.init(nibName: "StartView", bundle: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        pickerView.delegate = self
        
        
    }
    
    
    @IBAction private func startButtonPressed() {
        #if targetEnvironment(simulator)
        let scan = DocumentScan()
        let loader = LoadingController(scannedDocument: scan, type: ExpenseType.allCases[selectedCategory])
        navigationController?.pushViewController(loader, animated: true)
        #else
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else { requestCameraPermission(); return }
        guard VNDocumentCameraViewController.isSupported else { unsupportedDocumentScanner(); return }
        let controller = VNDocumentCameraViewController()
        controller.delegate = self
        present(controller, animated: true)
        #endif
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] (allowed) in
            ^{ allowed ? self?.startButtonPressed() : self?.cameraPermissionAlert() }
        }
    }
    
    
    private func unsupportedDocumentScanner() {
        let alert = AlertController(title: localizedString("unsupported"), message: localizedString("scannerUnsupported"), primary: localizedString("ok"))
        present(alert, animated: true)
    }
    
    private func cameraPermissionAlert() {
        let alert = AlertController(title: localizedString("cameraAuthorization"), message: localizedString("cameraAuthroizationMessage"), primary: localizedString("settings"))
        alert.primaryButtonAction = {
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            guard UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        present(alert, animated: true)
    }
    
    
    //MARK: DocumentController
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount > 0 else { return }
        let loader = LoadingController(scannedDocument: scan, type: ExpenseType.allCases[selectedCategory])
        navigationController?.pushViewController(loader, animated: false)
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true) {
            let alert = AlertController(title: localizedString("captureFailed"), message: localizedString("captureFailedMessage"), primary: localizedString("ok"))
            
            self.present(alert, animated: true)
        }
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    
    //MARK: PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ExpenseType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ExpenseType.allCases[row].localized
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = row
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

