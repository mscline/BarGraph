//
//  BarGraphColumnCell.swift
//  Lifespan
//
//  Created by Monsoon Co on 6/3/15.
//  Copyright (c) 2015 Monsoon Co. All rights reserved.
//

import UIKit

class BarGraphColumnCell: UICollectionViewCell {
    
    var title = ""
    var label = UILabel(frame: CGRectMake(0, 0, 0, 0))
    var bottomLabel = UILabel(frame: CGRectMake(0, 0, 0, 0))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        abort()  // will be created programmatically
    }
    
    func setup(){
        
        backgroundColor = UIColor.clearColor()
        label.backgroundColor = UIColor.clearColor()
        bottomLabel.backgroundColor = UIColor.clearColor()
        
        label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        label.textAlignment = NSTextAlignment.Center
        self.contentView.addSubview(label)
        
        // add label 2
        bottomLabel.frame = CGRectMake(0, self.frame.size.height - 14, self.frame.size.width, 14)
        bottomLabel.textAlignment = NSTextAlignment.Center
        bottomLabel.numberOfLines = 2
        bottomLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
        contentView.addSubview(bottomLabel)
       // bottomLabel.backgroundColor = UIColor.purpleColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("in")
        label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        bottomLabel = UILabel(frame: CGRectMake(0, self.frame.size.height - 14, self.frame.size.width, 14))

    
    }
    
    
}
