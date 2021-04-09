//
//  NavigationController.swift
//  Invoice Scanner
//
//  Created by Wilhelm Thieme on 02/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarHidden = true
        
        pushViewController(StartController(), animated: false)
    }
    
    //MARK: Fade Animation
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if animated { self.addFadeAnimation() }
        super.pushViewController(viewController, animated: false)
    }
    
    @discardableResult override func popViewController(animated: Bool) -> UIViewController? {
        guard viewControllers.count > 0 else { return nil }
        if animated { self.addFadeAnimation() }
        return super.popViewController(animated: false)
    }
    
    @discardableResult override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        guard let first = viewControllers.first else { return nil }
        return popToViewController(first, animated: true)
    }
    
    @discardableResult override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        guard index <= viewControllers.count-2 else { return nil }
        if animated { self.addFadeAnimation() }
        
        var result: [UIViewController] = []
        let range = index...viewControllers.count-2
        range.forEach { _ in result.append(self.popViewController(animated: false)!) }
        
        return result
    }
    
    private func addFadeAnimation() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.view.layer.add(transition, forKey: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
