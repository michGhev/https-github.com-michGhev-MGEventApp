//
//  UIStoryboard + Extension.swift
//  MGEventApp
//
//  Created by Michael Ghevondyan on 15.08.23.
//

import UIKit

extension UIStoryboard {
    @nonobjc class var main: UIStoryboard {
        UIStoryboard(name: Storyboard.main, bundle: nil)
    }
}

extension NSObject {
  class var className: String {
    return String(describing: self.self)
  }
}

