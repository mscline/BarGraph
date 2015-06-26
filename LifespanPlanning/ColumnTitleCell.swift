//
//  ColumnTitleCellCollectionViewCell.swift
//  Lifespan
//
//  Created by Monsoon Co on 6/8/15.
//  Copyright (c) 2015 Monsoon Co. All rights reserved.
//

import UIKit

class ColumnTitleCell: UICollectionViewCell {
    
    
        var title = ""
        var label = UILabel(frame: CGRectMake(0, 0, 0, 0))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        abort()  // will be created programmatically
    }
    
    func setup(){
    
        // add label 1
        label = UILabel(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.ByCharWrapping
        contentView.addSubview(label)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
      
    }
    
}
