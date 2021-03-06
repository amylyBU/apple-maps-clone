//
//  SnapScrollView.swift
//  MapsClone
//
//  Created by Amy Ly on 8/20/17.
//  Copyright © 2017 Amy Ly. All rights reserved.
//

import UIKit

class SnapScrollView: UIScrollView {

  let bounceDeltaY : CGFloat = 15
  let initialHeightOfContentSubview : CGFloat = 100
  let topY : CGFloat = 40
  let middleYOffset : CGFloat = 120

  var bottomY : CGFloat {
    return UIScreen.main.bounds.height - initialHeightOfContentSubview
  }

  var contentSubviewMinY : CGFloat {
    return bottomY - contentOffset.y;
  }

  var middleY : CGFloat {
    return (topY + bottomY) / 2 + middleYOffset
  }

  var middlePoint : CGPoint {
    return CGPoint(x: 0, y: bottomY - middleY)
  }

  var topPoint : CGPoint {
    return CGPoint(x: 0, y: bottomY - topY)
  }

  @IBOutlet weak var contentSubview : UIView!
  @IBOutlet weak var heightConstraint : NSLayoutConstraint!
  @IBOutlet weak var ignoredSubview : UIView!

  override func awakeFromNib() {
    super.awakeFromNib()
    heightConstraint.constant = -initialHeightOfContentSubview
  }

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let hitView = super.hitTest(point, with: event)
    return hitView == ignoredSubview ? nil : hitView
  }

  func scrollContentOutOfView() {
    setContentOffset(CGPoint(x: 0, y: -initialHeightOfContentSubview), animated: false)
  }

  func didScrollAboveScrollView() -> Bool {
    return contentSubviewMinY + bounceDeltaY <= topY
  }

  func didScrollToTopY() -> Bool {
    return contentSubviewMinY <= topY
  }

  func snapToBottomY() {
    setContentOffset(CGPoint.zero, animated: true)
  }

  func snapToMiddleY() {
    setContentOffset(middlePoint, animated: true)
  }

  func snapToTopY() {
    setContentOffset(topPoint, animated: true)
  }

  func pauseScrolling() {
    isScrollEnabled = false
    isScrollEnabled = true
  }

  func snapToPositionWithYVelocity(_ yVelocity : CGFloat) {
    let y = contentSubviewMinY

    if (y < topY) {
      snapToTopY()
    }
    else if (y > topY && y < middleY) {
      if (yVelocity > 0) {
        snapToTopY()
      }
      else if (yVelocity < 0) {
        snapToMiddleY()
      }
      else {
        abs(y - topY) < abs(y - middleY) ? snapToTopY() : snapToMiddleY()
      }
    }
    else if (y > middleY && y < bottomY) {
      if (yVelocity > 0) {
        snapToMiddleY()
      }
      else if (yVelocity < 0) {
        snapToBottomY()
      }
      else {
        abs(y - middleY) < abs(y - bottomY) ? snapToMiddleY() : snapToBottomY()
      }
    }
  }
}
