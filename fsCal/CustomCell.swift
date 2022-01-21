//
//  CustomCell.swift
//  fsCal
//
//  Created by odikk on 19/01/22.
//

import Foundation
import FSCalendar
import UIKit

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}


class CustomCell: FSCalendarCell {
    
    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    
    weak var roundedLayer: CAShapeLayer?
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.systemBlue.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        let roundedLayer = CAShapeLayer()
        roundedLayer.fillColor = UIColor.blue.cgColor
        roundedLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(roundedLayer, below: self.titleLabel?.layer)
        self.roundedLayer = roundedLayer
        
        self.shapeLayer.isHidden = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.circleImageView.frame = self.contentView.bounds
        guard let selectionLayer = selectionLayer, let roundedLayer = roundedLayer else { return }

        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
        self.roundedLayer?.frame = self.contentView.bounds
        
        if selectionType == .middle {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
            self.selectionLayer.fillColor = UIColor.systemBlue.cgColor
            self.roundedLayer?.isHidden = true
        }
        else if selectionType == .leftBorder {
            let selectionRect = selectionLayer.bounds.insetBy(dx: selectionLayer.frame.width / 4, dy: 0.0).offsetBy(dx: selectionLayer.frame.width / 4, dy: 0.0)
            self.selectionLayer?.isHidden = false
            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath
            
            let diameter: CGFloat = min((roundedLayer.frame.height), (roundedLayer.frame.width))
            let rect = CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)
            self.roundedLayer?.isHidden = false
            self.roundedLayer?.path = UIBezierPath(ovalIn: rect).cgPath
        }
        else if selectionType == .rightBorder {
            let selectionRect = selectionLayer.bounds.insetBy(dx: selectionLayer.frame.width / 4, dy: 0.0).offsetBy(dx: -selectionLayer.frame.width / 4, dy: 0.0)
            self.selectionLayer?.isHidden = false
            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath
            
            let diameter: CGFloat = min(roundedLayer.frame.height, roundedLayer.frame.width)
            let rect = CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)
            self.roundedLayer?.isHidden = false
            self.roundedLayer?.path = UIBezierPath(ovalIn: rect).cgPath
        }
        else if selectionType == .single {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
}
