//
//  BarGraphItem.swift
//  Lifespan
//
//  Created by Monsoon Co on 6/2/15.
//  Copyright (c) 2015 Monsoon Co. All rights reserved.
//

import UIKit

class BarGraphDataItem: NSObject {
    
        // in order to allow us to switch between bar graph, line graph, or table view implementations
        // we have corresponding properties for each ???
    
        // in addition, if we wish to display our data simultaneously in a graph and table
        // and to maintain shared selection states and data ordering, have a shared data set simplifies 
        // complicated interactions and data object conversions

        // in a similiar manner, by including a few placeholder values for the view to use, eg scaled height
        // of item, we can avoid creating and maintaining an additional object to store these properties
        // in or having to lookup parent objects and update them
    
        // bar graph
        var value_akaHeightOfBar:CGFloat = 0
        var scaledHeight:CGFloat = 0.0   // layout (for simplicity, will maintain layout properties, rather than subclassing)
        var isSelected = false
        var color:UIColor = UIColor.darkGrayColor()

        var columnName:String!
        var subCategoryName:String!
    


    
    
    init(columnName:String!, subCategoryName:String!, value:CGFloat!, color:UIColor!){
    
        self.columnName = columnName
        self.subCategoryName = subCategoryName
        self.value_akaHeightOfBar = value
        self.color = color
        
    }
    
}
