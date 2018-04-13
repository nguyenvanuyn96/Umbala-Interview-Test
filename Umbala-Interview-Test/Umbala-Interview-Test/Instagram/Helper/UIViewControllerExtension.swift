//
//  UIViewControllerExtension.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func showLoading(onView: UIView) -> UIView {
        let backgroundView = UIView.init(frame: onView.bounds)
        backgroundView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let indicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
        indicatorView.startAnimating()
        indicatorView.center = backgroundView.center
        
        DispatchQueue.main.async {
            backgroundView.addSubview(indicatorView)
            onView.addSubview(backgroundView)
        }
        
        return backgroundView
    }
    
    class func hideLoading(view: UIView) {
        DispatchQueue.main.async {
            view.removeFromSuperview()
        }
    }
}

