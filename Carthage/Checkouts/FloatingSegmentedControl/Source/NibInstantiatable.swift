//
//  NibInstantiatable.swift
//  FloatingControl
//
//  Created by Ryuhei Kaminishi on 2019/10/21.
//  Copyright © 2019 catelina777. All rights reserved.
//

import UIKit

public protocol NibInstantiatable {
    static var nibName: String {get}
    static func nib(inBundle bundle: Bundle?) -> UINib
    static func fromNib<T:UIView>(inBundle bundle: Bundle?, filesOwner: Any?) -> T
}

extension NibInstantiatable where Self: UIView {
    public static var nibName: String {
        return "\(Self.self)"
    }

    public static func nib(inBundle bundle: Bundle?) -> UINib {
        return UINib(nibName: nibName, bundle: bundle)
    }

    public static func fromNib<T:UIView>(inBundle bundle: Bundle? = nil, filesOwner: Any? = nil) -> T {
        let nib = self.nib(inBundle: bundle)
        let objs = nib.instantiate(withOwner: filesOwner, options: nil)
        return objs.filter { $0 is UIView }.last as! T
    }
}
