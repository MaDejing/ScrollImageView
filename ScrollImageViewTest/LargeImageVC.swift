//
//  LargeImageVC.swift
//  ScrollImageTest2
//
//  Created by DejingMa on 16/9/8.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import Foundation
import UIKit

let kScreenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
let kScreenHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)

class LargeImageVC: UIViewController {
    @IBOutlet weak var m_collectionView: UICollectionView!
	
	@IBOutlet weak var m_topView: UIView!
	
    lazy var m_arr: [String] = {
        var tempArr: [String] = []
        
        for i in 0...4 {
            tempArr.append("image0\(i+1)")
        }
        return tempArr
    }()
    
    lazy var m_colors: [UIColor] = [UIColor.yellowColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.darkGrayColor(), UIColor.grayColor()]
    
    let m_minLineSpace: CGFloat = 10.0
    let m_minItemSpace: CGFloat = 0.0
    let m_collectionTop: CGFloat = 0
    let m_collectionLeft: CGFloat = 0
    let m_collectionBottom: CGFloat = 0
    let m_collectionRight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.m_collectionView.backgroundColor = UIColor.blackColor()
		
		self.m_collectionView.registerClass(ScrollImageCell.self, forCellWithReuseIdentifier: ScrollImageCell.getCellIdentifier())

    }
	
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension LargeImageVC {
    @IBAction func backClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension LargeImageVC: ScrollImageCellDelegate {
	func afterSingleTap(cell: ScrollImageCell) {
		UIView.animateWithDuration(0.5) { 
			self.m_topView.hidden = !self.m_topView.hidden
		}
	}
}

extension LargeImageVC: UIScrollViewDelegate {
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView == self.m_collectionView {
            targetContentOffset.memory = scrollView.contentOffset
            
            let pageWidth = CGRectGetWidth(scrollView.frame) + self.m_minLineSpace
            
            var assistanceOffset: CGFloat = pageWidth / 2.0
            
            if velocity.x < 0 {
                assistanceOffset = -assistanceOffset
            }
            
            let assistedScrollPosition = (scrollView.contentOffset.x + assistanceOffset) / pageWidth
            
            var cellToScroll = Int(round(assistedScrollPosition))
            if (cellToScroll < 0) {
                cellToScroll = 0
            } else if (cellToScroll >= self.m_collectionView.numberOfItemsInSection(0)) {
                cellToScroll = self.m_collectionView.numberOfItemsInSection(0) - 1
            }
            
            self.m_collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forItem: cellToScroll, inSection: 0), atScrollPosition: .Left, animated: true)
        }
    }
}

extension LargeImageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.m_arr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ScrollImageCell), forIndexPath: indexPath) as! ScrollImageCell

        cell.updateViewWithData(UIImage(named: self.m_arr[indexPath.row])!)
		cell.m_delegate = self
        
        return cell
    }
	
	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		if let cell = cell as? ScrollImageCell {
			cell.imageResize()
		}
	}
	
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.m_minLineSpace
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.m_minItemSpace
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(self.m_collectionTop, self.m_collectionLeft, self.m_collectionBottom, self.m_collectionRight)
    }
}
