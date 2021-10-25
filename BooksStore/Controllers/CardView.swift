//
//  CardView.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 23/10/2021.
//

import UIKit

@IBDesignable class CardView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBInspectable var cornerradius:CGFloat = 10
    @IBInspectable var shadowOffsetWidth:CGFloat = 0
    @IBInspectable var shadowOffsetHeight:CGFloat = 3
    @IBInspectable var shadowColor: UIColor = UIColor.init(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.5))
    @IBInspectable var shadowOpacity: CGFloat = 1
    @IBInspectable var borderWidth: CGFloat = 1
    @IBInspectable var borderColor: UIColor = UIColor.clear
    override func layoutSubviews() {
    // Corner..............
            layer.cornerRadius = cornerradius
    // Shadow...........
            layer.shadowColor = shadowColor.cgColor
            layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
    let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradius)
            layer.shadowPath = shadowPath.cgPath
            layer.shadowOpacity = Float(shadowOpacity)
            layer.masksToBounds = false
    // Border.............
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
        }
    }

