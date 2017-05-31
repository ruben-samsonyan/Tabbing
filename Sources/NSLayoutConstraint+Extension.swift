//
// Created by Ruben Samsonyan on 5/27/17.
// Copyright (c) 2017 Ruben Samsonyan. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    convenience init(item: (Any, NSLayoutAttribute),
         toItem item2: (Any?, NSLayoutAttribute),
         relatedBy relation: NSLayoutRelation = .equal,
         multiplier: CGFloat = 1.0,
         constant c: CGFloat = 0.0) {

        self.init(item: item.0,
                  attribute: item.1,
                  relatedBy: relation,
                  toItem: item2.0,
                  attribute: item2.1,
                  multiplier: multiplier,
                  constant: c)
    }
}
