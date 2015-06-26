//
//  ColumnHeadings.swift
//  Lifespan
//
//  Created by Monsoon Co on 6/8/15.
//  Copyright (c) 2015 Monsoon Co. All rights reserved.
//

import UIKit

class ColumnHeadings: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
        
        
            // variables - user input
            var columnHeadingsFromUser:[String]?
            var columnWidth:CGFloat = 0
    
            // Touches
            var delegateForTouches:BarGraphItemWasTouchedProtocol?
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupCollectionView()
        addGestures()
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
            self .registerClass(ColumnTitleCell.classForCoder(), forCellWithReuseIdentifier: "columnTitleCell")
            
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
            
            if columnHeadingsFromUser == nil { return 0; }
            
            return columnHeadingsFromUser!.count
            
        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let title = columnHeadingsFromUser![indexPath.row] as String!
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("columnTitleCell", forIndexPath: indexPath) as! ColumnTitleCell
            cell.label.attributedText = TextFormatter.createAttributedString(title, withFont: nil, fontSize: 14, fontColor: nil, nsTextAlignmentStyle: NSTextAlignment.Center)

            return cell
        }
        
        
        // MARK: COLLECTION VIEW - LAYOUT
        
        // set size of cell
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

            return CGSizeMake(columnWidth, self.frame.size.height)
            
        }
        
        // set spacing
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            
            return 0
            
        }
    
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            
            return 0
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
        
        // forward info to user
        delegateForTouches?.graphReceivedTouch(touchOrigin: TouchOrigin.columnTitle, touchType: touchType, columnTouched: index!, subCategory: 0, locationOfTouchOnGraph: locationOfTouchInGraph)
        
    }
    
}