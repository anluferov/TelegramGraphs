//
//  Animator.swift
//  TelegramGraphs
//
//  Created by AP Andrey Luferau on 2/16/20.
//  Copyright © 2020 AP Andrey Luferau. All rights reserved.
//

import Foundation
import UIKit

class Animator {

    //animate changing path (position of graphs)
    func animateChangingPath(from oldValue: CGPath, to newValue: CGPath, on layer: CAShapeLayer) {
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = oldValue
        pathAnimation.toValue = newValue
        pathAnimation.duration = 0.5

        layer.add(pathAnimation, forKey: "pathAnimation")
//        layer.path = newValue
    }

    func animateDisappear(on layer: CAShapeLayer) {
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        opacityAnimation.duration = 0.5

        layer.add(opacityAnimation, forKey: "opacityAnimation")
//        layer.opacity = 0.0
    }

    func animateAppear(on layer: CAShapeLayer) {
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 0.0
        opacityAnimation.toValue = 1.0
        opacityAnimation.duration = 0.5

        layer.add(opacityAnimation, forKey: "opacityAnimation")
//        layer.opacity = 1.0
    }

    func startGroupAnimation(_ group:CAAnimationGroup, on layer: CALayer) {
        group.duration = 1.5
        layer.add(group, forKey: nil)
    }
}


