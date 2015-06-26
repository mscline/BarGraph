//
//  BarGraphFacade.swift
//  Lifespan
//
//  Created by Monsoon Co on 6/3/15.
//  Copyright (c) 2015 Monsoon Co. All rights reserved.
//

import UIKit


// HOW TO:
//
// step 1: add a UIView in Storyboard and change class to BarGraphFacade 
//        (or do it programatically)
//
// step 2: use your facade to create data objects for your graph (see the 
//         createBarGraphDataItem function, below)
//
//         NOTE: the height of your graph will be based on your last y-axis value (ie, your biggest)
//               the column width will be autocalculated to take up the full width of our graph
//
// step 3: set graph display options / properties if needed
//
// step 4: load data
//
//  option a) if you have a simple graph, you can just load an array of bar 
//            graph items
//
//  option b) if you want to show a stacked graph (ie, create an array 
//            containing barGraphItems for each of your categories that you 
//            want to track, put them all in a big array, and load them)
//
//          for exampel, if I want to track how much money I make selling 
//          lemonade and how much money I make selling cookies by month, 
//          create an array and load it
//
//          [ [$_lemonade_month_1, $_lemonade_month_2],
//            [$_cookies_month_1, $_cookies_month_2] ]
//
// step 5: set delegate use delegate methods to respond to user touches, if desired
//         or use default handling by setting: useDefaultTouchHandling:StandardTouchInteractionOptions
//


// A. RESPOND TO TOUCHES DELEGATE METHODS

// to use default handling, set eg, useDefaultTouchHandling = StandardTouchInteractionOptions.selectOnTouch
enum StandardTouchInteractionOptions {
    
    case doNotUse, selectOnTouch
    
}

// or take care of it on your own
enum TouchOrigin {

    case barGraphItem, aboveBarGraphColumn, columnTitle, yAxisValue, outOfBounds  // outOfBounds may occur if drag item out of graph
}

enum TouchType {

    case singleTap, doubleTap, longPress, dragStart, dragInProgress, dragEnd

}

protocol BarGraphItemWasTouchedProtocol {
    
    // find the location of the object in your input array / matrix
    func graphReceivedTouch(#touchOrigin:TouchOrigin, touchType:TouchType, columnTouched column:Int, subCategory:Int, locationOfTouchOnGraph:CGPoint)  }

        // note: when touch the y-Axis, column 0, would correspond to the cell between 0 and 50 ????  (should change???)


// B. THE BAR GRAPH CLASS (WHICH IMPLEMENTS THE GRAPH INTERFACE PROTOCOL)

protocol GraphInterfaceProtocol {
    
    func loadDataForCollectionView(#array:Array<BarGraphDataItem>, arrayOfCategoryTitles:Array<String>, arrayOfYTitles:Array<Double>)
    
    func loadDataForCollectionView(#arraysOfCategoryItemsNestedInsideOneBigArray:Array<Array<BarGraphDataItem>>, arrayOfCategoryTitles:Array<String>, arrayOfYTitles:Array<Double>)
}

class BarGraphFacade: InteractiveBarGraph {
 
    // var delegateForTouches:BarGraphItemWasTouchedProtocol?   // in superclass
    
    func createBarGraphDataItem(#columnName:String!, subCategoryName:String!, value:CGFloat!, color:UIColor!) -> BarGraphDataItem {
        
            return BarGraphDataItem(columnName: columnName, subCategoryName: subCategoryName, value: value, color: color)
    }

}

/* C. OPTIONAL DISPLAY SETTINGS / PROPERTIES (FROM SUPERCLASS)


// useDefaultTouchHandling:StandardTouchInteractionOptions


// UI settings
var showColumnTotals:Bool = true
var showColumnSubTotals:Bool = true
var autoCalcYAxisPadding:Bool = false
var paddingBetweenXAxisAndColumnTitles:CGFloat = 6

var leftPadding:CGFloat = 50   // the user may specify default, but if the text will not fit, it will be automatically adjusted, turn on autoCalcYAsixPadding
var bottomPadding:CGFloat = 20
var topPadding:CGFloat = 10

// THE BAR GRAPH FACADE IS A VIEW WHICH CONTAINS THREE COLLECTION VIEWS AND LINES FOR THE X AND Y AXIS
// YOU MAY ACCESS THEM DIRECTLY, IF WANT TO EG, CHANGE COLORS
var barGraph:BarGraph!
var yValues:YValues!
var columnHeadings:ColumnHeadings!

// other screen elements
var yAxis:UIView!
var xAxis:UIView!

*/



extension TouchOrigin
{
    // to log enum, use myEnum.description()
    func description() -> String {
        switch self {
        case TouchOrigin.barGraphItem: return "barGraphItem"
        case TouchOrigin.aboveBarGraphColumn: return "aboveBarGraphColumn"
        case TouchOrigin.columnTitle: return "columnTitle"
        case TouchOrigin.yAxisValue: return "yAxisValue"
        case TouchOrigin.outOfBounds: return "outOfBounds"
        }
    }
}

extension TouchType
{
    // to log enum, use myEnum.description
    func description() -> String {
        switch self {
        case TouchType.singleTap: return "singleTap"
        case TouchType.doubleTap: return "doubleTap"
        case TouchType.longPress: return "longPress"
        case TouchType.dragStart: return "dragStart"
        case TouchType.dragInProgress: return "dragInProgress"
        case TouchType.dragEnd: return "dragEnd"
            
        }
    }
}
