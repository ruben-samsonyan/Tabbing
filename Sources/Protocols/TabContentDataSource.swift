//
// Created by Ruben Samsonyan on 5/26/17.
// Copyright (c) 2017 Ruben Samsonyan. All rights reserved.
//

import Foundation

@objc public protocol TabContentDataSource {
    func menu(_ menuController: TabbedViewController, viewControllerForItemAtIndex index: Int) -> UIView?
}