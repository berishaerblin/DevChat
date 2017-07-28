//
//  RoundedButton.swift
//  DevChat
//
//  Created by Erblin Berisha on 7/28/17.
//  Copyright © 2017 Erblin Berisha. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidh: CGFloat = 0.0 {
        didSet{
            layer.borderWidth = borderWidh
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var bgColor: UIColor? {
        didSet{
            backgroundColor = bgColor
        }
    }
    
}
