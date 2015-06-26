//
//  BarGraphContainerWithTouches.swift
//  LifespanPlanning
//
//  Created by Monsoon Co on 6/16/15.
//  Copyright (c) 2015 Monsoon Co. All rights reserved.
//

import UIKit

class InteractiveBarGraph: BarGraphContainer, BarGraphItemWasTouchedProtocol  {

    // THE BAR GRAPH CONTAINER PROVIDES OUR BASIC FUNCTIONALITY AND NOTIFIES US OF INCOMING TOUCHES
    // THE PURPOSE OF THIS SUBCLASS OF BAR GRAPH CONTAINER IS TO ADD / ABSTRACT SOME BASIC INTERACTIVITY
    
    
        var useDefaultTouchHandling = StandardTouchInteractionOptions.doNotUse
        var forwardMessagesToAddressDelegate:BarGraphItemWasTouchedProtocol?
    
    
    // MARK: INTERCEPT LOAD DATA METHOD CALLS SO CAN SETUP DELEGATE
    
    override func loadDataForCollectionView(#array:Array<BarGraphDataItem>, arrayOfCategoryTitles:Array<String>, arrayOfYTitles:Array<Double>){
        
        setupDelegate()
        super.loadDataForCollectionView(array: array, arrayOfCategoryTitles: arrayOfCategoryTitles, arrayOfYTitles: arrayOfYTitles)
    }
    
    override func loadDataForCollectionView(#arraysOfCategoryItemsNestedInsideOneBigArray:Array<Array<BarGraphDataItem>>, arrayOfCategoryTitles:Array<String>, arrayOfYTitles:Array<Double>){
        
        setupDelegate()
        super.loadDataForCollectionView(arraysOfCategoryItemsNestedInsideOneBigArray: arraysOfCategoryItemsNestedInsideOneBigArray, arrayOfCategoryTitles: arrayOfCategoryTitles, arrayOfYTitles: arrayOfYTitles)
    }
    
    func setupDelegate(){
    
        // if the user is using this classes handling, we are going to change the bar graph's delegate to self, and then after this class is done handling it, it will forard it to the user
        
        forwardMessagesToAddressDelegate = delegateForTouches
        delegateForTouches = self
        
    }
    
    
    // MARK: BAR GRAPH - WAS TOUCHED
    
    func graphReceivedTouch(#touchOrigin: TouchOrigin, touchType: TouchType, columnTouched column: Int, subCategory: Int, locationOfTouchOnGraph: CGPoint) {
        
        // forward touch to user - although we will handle the touches here, we will still notify the user
        if forwardMessagesToAddressDelegate == nil {
        
        } else {
            
            forwardMessagesToAddressDelegate!.graphReceivedTouch(touchOrigin: touchOrigin, touchType: touchType, columnTouched: column, subCategory: subCategory, locationOfTouchOnGraph: locationOfTouchOnGraph)
        
        }
        
        println("\(touchOrigin.description()) \(touchType.description()) \(column) \(subCategory) \(locationOfTouchOnGraph)")

        // if not using handling, exit
        if useDefaultTouchHandling == StandardTouchInteractionOptions.doNotUse { return; }
        
        // default handling
        if touchOrigin == TouchOrigin.barGraphItem {
            
            switch touchType {
                
            case TouchType.singleTap: graph_toggleSelection(column: column, subCategory: subCategory)
            case TouchType.doubleTap: graph_toggleSelection(column: column, subCategory: subCategory)
            case TouchType.longPress: graph_toggleSelection(column: column, subCategory: subCategory)
                
            case TouchType.dragStart, TouchType.dragInProgress, TouchType.dragEnd: graph_onDragSelectOrSelectAnythingTouched(touchType: touchType, columnTouched: column, subCategory: subCategory)
            }
        }
    }
    
    func graph_toggleSelection(#column: Int, subCategory: Int) {
        
        // look up data object
        let barItem = readOnly_rawData![subCategory][column]
        barItem.isSelected = !barItem.isSelected
        
        // reload cell
        barGraph.reloadData()
    }
    
    // private variable for use in following method
    private var selectOnMouseOver = true
    
    func graph_onDragSelectOrSelectAnythingTouched(#touchType: TouchType, columnTouched column: Int, subCategory: Int) {
        
        
        // we are going to toggle the selection of the first cell touched
        // and then all other cells will follow suit
        
        
        // look up data object
        let barItem = readOnly_rawData![subCategory][column]
        
        // look at state of first cell and remember
        if touchType == TouchType.dragStart {
            
            selectOnMouseOver = !barItem.isSelected
        }
        
        // for each cell, set the selection state
        barItem.isSelected = selectOnMouseOver
        
        // reload cell
        barGraph.reloadData()
    }
    

    

}
