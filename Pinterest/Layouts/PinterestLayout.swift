/// Copyright (c) 2 Reiwa Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CoreGraphics

protocol PinterestLayoutDelegate {
  func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
  var delegate: PinterestLayoutDelegate!
  
  var numberOfColumns = 1
  
  private var cache = [UICollectionViewLayoutAttributes]()
  private var contentHeight: CGFloat = 0
  private var contentWidth: CGFloat {
    get {
      return collectionView!.bounds.width
    }
  }
//  private var contentWidth: CGFloat {
//    guard let collectionView = collectionView else {
//      return 0
//    }
//    let insets = collectionView.contentInset
//    return collectionView.bounds.width - (insets.left + insets.right)
//  }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func prepare() {
    print(collectionView!.contentInset)
    // 1
    guard
      cache.isEmpty,
      let collectionView = collectionView
      else {
        return
    }
    
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffset = [CGFloat]()
    for column in 0..<numberOfColumns {
      xOffset.append(CGFloat(column) * columnWidth)
      
      
    }
    var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
    var currentColumn = 0
    
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)
      let height = delegate.collectionView(collectionView: collectionView, heightForItemAtIndexPath: indexPath as NSIndexPath)
      let frame = CGRect(x: xOffset[currentColumn], y: yOffset[currentColumn], width: columnWidth, height: height)
      
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = frame
      cache.append(attributes)
      contentHeight = max(contentHeight, frame.maxY)
      
      yOffset[currentColumn] += height
      
      currentColumn = currentColumn < (numberOfColumns - 1) ? (currentColumn + 1) : 0
      
    }
    
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    for attribute in cache {
      if attribute.frame.intersects(rect) {
        layoutAttributes.append(attribute)
      }
    }
    return layoutAttributes
  }
  
}


