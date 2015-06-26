//
//  yValues.swift
//  Lifespan
//
//  Created by Monsoon Co on 6/8/15.
//  Copyright (c) 2015 Monsoon Co. All rights reserved.
//

import UIKit

class YValues: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    
        // this is a collection view
        // the height of each cell corresponds to the y value
        // because the text label/view is in the view, need to adjust the collection view up a little, so that it will be properly centered (refactor if allow to change font sizes) 
        // will also move it a little right, so can add a "-" in the text field to give a cross hatch 
    
        var yScaleFactor:CGFloat = 1.0
        var yValuesInReverseOrderForDisplay:[Double]?

        // Touches
        var delegateForTouches:BarGraphItemWasTouchedProtocol?
    
        // user inputs an array, but will reorder and store as different variable before use
        var yValues:[Double]? {
                
                didSet {
                    yValuesInReverseOrderForDisplay = reverseOrderOfArray(yValues!)
                }
            }
    
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        // adjust frame up a little (see discussion, above)
        var adjustedFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.width, frame.height)

        super.init(frame: frame, collectionViewLayout: layout)
        
        setupCollectionView()
        addGestures()
        scrollEnabled = false
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        abort()  // will be created in code
    }
    
    // MARK: COLLECTION VIEW - SETUP
    
    func setupCollectionView(){
        
        dataSource = self
        delegate = self
        
        // register collection view cell so can create programatically
        self.registerClass(YAxisCell.classForCoder(), forCellWithReuseIdentifier: "yAxisCell")
        
        // set direction of layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical  // a horizontal scroll gives you a vertical layout !!!
        collectionViewLayout = layout  // this will automatically set the flowLayout delegate to be the same as the collectionView.delegate
    }

    
    // MARK: COLLECTION VIEW - DATASOURCE
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1;
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if yValues == nil { return 0; }
 
        return yValues!.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        // build text string
        var text:NSAttributedString?
        let title = yValuesInReverseOrderForDisplay![indexPath.row]
        
        // if the title value = 0, then just display the title, but need to add placeholder (clear text) to keep alignment even with other text
        if title == 0.0 {
        
            let baseString = TextFormatter.createAttributedString(String("\(title) "), withFont: nil, fontSize: nil, fontColor: UIColor.blackColor(), nsTextAlignmentStyle: NSTextAlignment.Right)
            let clearPlaceHolder = TextFormatter.createAttributedString("-", withFont: nil, fontSize: nil, fontColor: UIColor.clearColor(), nsTextAlignmentStyle: NSTextAlignment.Right)
            text = TextFormatter.combineAttributedStrings([baseString, clearPlaceHolder])
        
        // otherwise, add a cross hatch
        } else {

            text = TextFormatter.createAttributedString(String("\(title) -"), withFont: nil, fontSize: nil, fontColor: UIColor.blackColor(), nsTextAlignmentStyle: NSTextAlignment.Right)
        
        }

        // update cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("yAxisCell", forIndexPath: indexPath) as! YAxisCell
        cell.label.attributedText = text
        
        return cell
    }
    
    
    // MARK: COLLECTION VIEW - LAYOUT
    
    // set size of cell
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(self.frame.size.width, findScaledHeightForCellAtIndex(index: indexPath))
        
    }
    
    // set spacing
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
    }

    
    // MARK: DATA PROCESSING

    func reverseOrderOfArray<T>(array:[T]) -> [T] {
    
        var outputArray = [T]()
        
        for var x = array.count - 1; x > -1; x-- {
        
            let objectFromArray = array[x]
            outputArray.append(objectFromArray)
        }
        
        return outputArray
    }
    
    func findScaledHeightForCellAtIndex(#index:NSIndexPath) -> CGFloat {
    

        let y_thisCell = yValuesInReverseOrderForDisplay![index.row]
        
        // if last cell
        if index.row == yValuesInReverseOrderForDisplay!.count - 1 {
        
            return CGFloat(20)
        
        }
        
        // find distance between current cell and next
        // dy = y(n) - y(n+1)
        let y_nextCell = yValuesInReverseOrderForDisplay![index.row + 1]
        
        // this is the height of our cell
        let changeInY = CGFloat(y_thisCell - y_nextCell)
 
        // then multiply it by our scale factor
        let scaledY = changeInY * yScaleFactor
        
        return scaledY
        
    }

    
    // MARK: SETUP GESTURES
    
    func addGestures() {
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        addGestureRecognizer(tapGestureRecognizer)
        
        var doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleDoubleTap:"))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGestureRecognizer)
        
        var longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("handleLongTap:"))
        addGestureRecognizer(longPressGestureRecognizer)
        
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        addGestureRecognizer(panGestureRecognizer)
        
        
        tapGestureRecognizer.requireGestureRecognizerToFail(doubleTapGestureRecognizer)
        tapGestureRecognizer.requireGestureRecognizerToFail(longPressGestureRecognizer)
        tapGestureRecognizer.requireGestureRecognizerToFail(panGestureRecognizer)
        
    }
    
    func handleTap(sender:UIGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.Ended
        {
            forwardGestureToUser(sender, touchType: TouchType.singleTap)
        }
    }
    
    func handleDoubleTap(sender:UITapGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.Ended
        {
            forwardGestureToUser(sender, touchType: TouchType.doubleTap)
        }
        
    }
    
    func handleLongTap(sender:UILongPressGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.Ended {
            
            forwardGestureToUser(sender, touchType: TouchType.longPress)
        }
        
    }
    
    func handlePan(sender:UIPanGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.Began {
            
            forwardGestureToUser(sender, touchType: TouchType.dragStart)
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            forwardGestureToUser(sender, touchType: TouchType.dragInProgress)
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            forwardGestureToUser(sender, touchType: TouchType.dragEnd)
        }
        
    }
    
    
    // MARK: HANDLE GESTURES
    
    func forwardGestureToUser(sender:UIGestureRecognizer, touchType:TouchType){
        
        let pointTouched = sender.locationInView(self)
        let locationOfTouchInGraph = sender.locationInView(self.superview)
        
        // get index corresponding to touch
        let index = self.indexPathForItemAtPoint(pointTouched)?.row

        // if invalid touch, exit
        if index == nil {
            
            delegateForTouches?.graphReceivedTouch(touchOrigin: TouchOrigin.outOfBounds, touchType: touchType, columnTouched: 0, subCategory: 0, locationOfTouchOnGraph: locationOfTouchInGraph)
            return
            
        }

        // the user provide the index in the reverse order that they are displayed, fix it
        let trueIndex = yValuesInReverseOrderForDisplay!.count - index!
        
        // forward info to user
        delegateForTouches?.graphReceivedTouch(touchOrigin: TouchOrigin.columnTitle, touchType: touchType, columnTouched: index!, subCategory: 0, locationOfTouchOnGraph: locationOfTouchInGraph)
        
    }
    

}
