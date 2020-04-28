//
//  extensions.swift
//  InterDevicePointer
//
//  Created by sachin jeph on 28/04/20.
//  Copyright © 2020 sachin jeph. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}


