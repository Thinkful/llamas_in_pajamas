//
//  CGVectTools.swift
//  Unit1
//
//  Created by Brendon Roberto on 7/7/14.
//  Copyright (c) 2014 Thinkful. All rights reserved.
//

import Foundation
import SpriteKit

@infix func * (left: CGVector, right: CGFloat) -> CGVector {
  var result = left
  result.dx *= right
  result.dy *= right
  return result
}

@infix func * (left: CGFloat, right: CGVector) -> CGVector {
  var result = right
  result.dx *= left
  result.dy *= left
  return result
}

@prefix func - (vector: CGVector) -> CGVector {
  var result = vector
  result.dx = -result.dx
  result.dy = -result.dy
  return result
}

func CGVectorGetMagnitude(vector: CGVector) -> CGFloat {
    return CGFloat(sqrt(pow(CDouble(vector.dx), 2) + pow(CDouble(vector.dy), 2)))
}

func CGVectorNormalizedFromVector(vector: CGVector) -> CGVector {
  let magnitude = CGVectorGetMagnitude(vector)
  var result = vector
  result.dx /= magnitude
  result.dy /= magnitude
  return result
}

func CGVectorMakeRandomFromMagnitude(magnitude: CGFloat) -> CGVector {
  var result: CGVector = CGVectorNormalizedFromVector(CGVectorMake(CGFloat(arc4random_uniform(10)) - 5.0, CGFloat(arc4random_uniform(10)) - 5.0))
  result = result * magnitude
  return result
}

func CGVectorMakeFromCGPoints(#from: CGPoint, #to: CGPoint) -> CGVector {
  var result: CGVector = CGVectorMake(to.x - from.x, to.y - from.y)
  return result;
}