//
//  ScrollImageCell.swift
//  ScrollImageTest2
//
//  Created by DejingMa on 16/9/8.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
	/** 按比例缩放 */
	func ratioSize(ratio: CGFloat) -> CGSize {
		return CGSizeMake(self.width / ratio, self.height / ratio)
	}
}

protocol ScrollImageCellDelegate: NSObjectProtocol {
	func afterSingleTap(cell: ScrollImageCell)
}

class ScrollImageCell: UICollectionViewCell {
    
	lazy var m_scrollView: UIScrollView = {
		var tempScrollView = UIScrollView(frame: self.contentView.bounds)
		
		tempScrollView.delegate = self
		tempScrollView.backgroundColor = UIColor.whiteColor()
		
		tempScrollView.maximumZoomScale = 2
		tempScrollView.minimumZoomScale = 1
		tempScrollView.showsVerticalScrollIndicator = false
		tempScrollView.showsHorizontalScrollIndicator = false
		
		return tempScrollView
	}()
	
	lazy var m_imageView: UIImageView = {
		var tempImgView = UIImageView(frame: self.m_scrollView.bounds)
		
		tempImgView.contentMode = .ScaleAspectFit
		tempImgView.backgroundColor = UIColor.grayColor()
		tempImgView.userInteractionEnabled = true
		
		return tempImgView
	}()
	
	weak var m_delegate: ScrollImageCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let singleTap = UITapGestureRecognizer(target: self, action: #selector(ScrollImageCell.singleTap(_:)))
		singleTap.numberOfTapsRequired = 1
		singleTap.numberOfTouchesRequired = 1
		
		let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ScrollImageCell.doubleTap(_:)))
		doubleTap.numberOfTapsRequired = 2
		doubleTap.numberOfTouchesRequired = 1
		
		singleTap.requireGestureRecognizerToFail(doubleTap)
		
		self.m_scrollView.addGestureRecognizer(singleTap)
		self.m_scrollView.addGestureRecognizer(doubleTap)
		
		self.m_scrollView.addSubview(self.m_imageView)
		self.contentView.addSubview(self.m_scrollView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
    func updateViewWithData(image: UIImage) {
        self.m_imageView.image = image
        
        self.imageResize()
    }
    
    static func getCellIdentifier() -> String {
        return "ScrollImageCell"
    }
}

extension ScrollImageCell {
	func imageResize() {
        self.m_scrollView.zoomScale = 1
        
        guard let img = self.m_imageView.image else { return }
        
        let imgSize = img.size
        let widthRatio = imgSize.width / kScreenWidth
        
        let newSize = CGSizeMake(imgSize.width / widthRatio, imgSize.height / widthRatio)
        self.m_imageView.frame.size = newSize
        
        if (newSize.height <= self.m_scrollView.frame.size.height) {
            self.m_imageView.center = self.m_scrollView.center
        } else {
            self.m_imageView.frame.origin = CGPointZero
        }
        
        self.m_scrollView.contentOffset = CGPointZero
        self.m_scrollView.contentSize = CGSizeMake(kScreenWidth, max(kScreenHeight, self.m_imageView.frame.size.height))
	}
    
    // 把从scrollView里截取的矩形区域缩放到整个scrollView当前可视的frame里面。获取所要放大的内容的rect，以点击点为中心。因为放大scale倍，所以截取内容宽高为scrollview的1/scale。
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect: CGRect = CGRectZero
        
        //大小
        zoomRect.size.height = self.m_scrollView.frame.size.height/scale;
        zoomRect.size.width = self.m_scrollView.frame.size.width/scale;
        //原点
        zoomRect.origin.x = center.x - zoomRect.size.width/2;
        zoomRect.origin.y = center.y - zoomRect.size.height/2;
        
        return zoomRect;
    }
}

extension ScrollImageCell {
	func singleTap(ges: UITapGestureRecognizer) {
		self.m_delegate?.afterSingleTap(self)
	}
	
	func doubleTap(ges: UITapGestureRecognizer) {
        let newScale: CGFloat
        
        if self.m_scrollView.zoomScale == 1 {
            newScale = self.m_scrollView.maximumZoomScale
        } else {
            newScale = 1
        }
        
        let newRect = self.zoomRectForScale(newScale, center: ges.locationInView(self.m_imageView))
        self.m_scrollView.zoomToRect(newRect, animated: true)
    }
}

extension ScrollImageCell: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.m_imageView
    }
	
    func scrollViewDidZoom(scrollView: UIScrollView) {
        var xcenter = scrollView.center.x
        var ycenter = scrollView.center.y
        
        // ScrollView中内容的大小和ScrollView本身的大小，哪个大取哪个的中心
        let contentWidthLarger: Bool = scrollView.contentSize.width > scrollView.frame.size.width
        let contentHeightLarger: Bool = scrollView.contentSize.height > scrollView.frame.size.height
        
        xcenter = contentWidthLarger ? scrollView.contentSize.width/2 : xcenter
        ycenter = contentHeightLarger ? scrollView.contentSize.height/2 : ycenter
        self.m_imageView.center = CGPointMake(xcenter, ycenter)
    }
}
