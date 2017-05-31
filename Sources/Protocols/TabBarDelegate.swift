//
// Created by Ruben Samsonyan on 5/26/17.
// Copyright (c) 2017 Ruben Samsonyan. All rights reserved.
//

import Foundation

@objc public protocol TabBarDelegate {
    func dimensionOfMenu(_ menuController: TabbedViewController) -> CGFloat
    func menu(_ menuController: TabbedViewController, dimensionForItemAtIndex index: Int) -> CGFloat

    func menu(_ menuController: TabbedViewController, willSelectItemAtIndex: Int)
    func menu(_ menuController: TabbedViewController, didSelectItemAtIndex: Int)
}

extension TabBarDelegate {
    func dimensionOfMenu(_ menuController: TabbedViewController) -> CGFloat {
        return XMenuAutomaticDimension
    }

    func menu(_ menuController: TabbedViewController, dimensionForItemAtIndex index: Int) -> CGFloat {
        return XMenuAutomaticDimension
    }
}