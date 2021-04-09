//
//  Window.swift
//  Invoice
//
//  Created by Wilhelm Thieme on 04/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit

class Window: UIWindow {
    
    static var shared: Window? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window
    }
    
    private var blockNextTransitionView = false
    private var observingTraitColelctionChanges = false
    
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func applicationDidBecomeActive() {
        if #available(iOS 13.0, *) {
            setLightDarkAppIcon()
        }
        observingTraitColelctionChanges = true
    }
    
    @objc private func applicationWillResignActive() {
        observingTraitColelctionChanges = false
    }
    
    @available(iOS 13.0, *)
    func setLightDarkAppIcon() {
        let newIcon = traitCollection.userInterfaceStyle == .dark ? "DarkAppIcon" : "LightAppIcon"
        if UIApplication.shared.alternateIconName == newIcon { return }
        UIApplication.shared.setAlternateIconName(newIcon)
        blockNextTransitionView = true
    }

    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        guard blockNextTransitionView else { return }
        blockNextTransitionView = false
        subview.isHidden = true
        guard let root = rootViewController else { return }
        dismissTop(controller: root)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if !observingTraitColelctionChanges { return }
        if #available(iOS 13.0, *) {
            setLightDarkAppIcon()
        }
    }
    
    
    func dismissTop(controller: UIViewController) {
        if let presented = controller.presentedViewController {
            dismissTop(controller: presented)
        } else {
            controller.dismiss(animated: false, completion: nil)
        }
    }
//
//    override func sendEvent(_ event: UIEvent) {
//        super.sendEvent(event)
//
//        guard let touches = event.allTouches else { return }
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        switch touch.phase {
//        case .began: touchBegan(location)
//        case .moved: touchMoved(location)
//        case .ended: touchEnded(location)
//        case .cancelled: touchCancelled(location)
//        case .stationary: break
//        @unknown default: break
//        }
//    }
//
//
//    private var startPoint: CGPoint?
//    private var endPoint: CGFloat { return frame.height * 0.15 }
//    private var refreshObservers: [AnyHashable: ((Bool) -> Void)] = [:]
//    private var refreshProgressObservers: [AnyHashable: ((Float) -> Void)] = [:]
//
//    func addRefeshObserver(_ target: AnyHashable, _ observer: @escaping ((Bool) -> Void), progress: ((Float) -> Void)? = nil) {
//        refreshObservers[target] = observer
//        if let progress = progress {
//            refreshProgressObservers[target] = progress
//        }
//    }
//
//    func removeRefreshObserver(_ target: AnyHashable) {
//        refreshObservers[target] = nil
//        refreshProgressObservers[target] = nil
//    }
//
//
//    private func touchBegan(_ location: CGPoint) {
//        startPoint = location
//    }
//
//    private func touchMoved(_ location: CGPoint) {
//        guard let start = startPoint else { return }
//        let distance = location.y - start.y
//        let factor = Float(distance / endPoint)
//        let percentage = max(0, factor)
//        refreshProgressObservers.forEach { $0.value(percentage) }
//    }
//
//    private func touchEnded(_ location: CGPoint) {
//        guard let start = startPoint else { return }
//        let distance = location.y - start.y
//        refreshObservers.forEach { $0.value(distance > endPoint) }
//        startPoint = nil
//    }
//
//    private func touchCancelled(_ location: CGPoint) {
//        refreshObservers.forEach { $0.value(false) }
//        startPoint = nil
//    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

