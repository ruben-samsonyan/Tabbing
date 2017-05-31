//
// Created by Ruben Samsonyan on 5/27/17.
// Copyright (c) 2017 Ruben Samsonyan. All rights reserved.
//

import UIKit

/// Sets all constraints and manipulate them depend on postion and state of tab bar
/// This class has very limitied internal api.
struct TabBarStateMachine {
    
    // Mark: Internal API
    
    /// An instance of TabbedViewController for which this state machin will work
    weak var menuController: TabbedViewController?
    
    /// Current position of tab bar. Should be nil only initialy.
    var position: TabBarPosition? {
        get {
            return _position
        }
        set {
            if newValue != _position {
                guard let newValue = newValue else {
                    _uninstallAllConstraints()
                    return
                }
                
                _position = newValue
                
                if state == nil {
                    _state = .closed
                }
                
                _updatePosition()
                _updateState(animated: false)
            }
        }
    }
    
    /// Current state of tab bar. Should be nil only initialy.
    var state: TabBarState? {
        get {
            return _state
        }
        set {
            if newValue != _state {
                guard let newValue = newValue else {
                    
                    return
                }
                
                _state = newValue
                
                _updateState(animated: true)
            }
        }
    }
    
    /// If true all the components of tab bar having top constaint will be attached to topLayoutGuide
    /// of tabbedViewControlller. On false will attach to top of tabbedViewController.view
    /// Value can be updated with tabbedViewController.attachToTopLayoutGuid if defined and not nil.
    var attachToTopLayoutGuid: Bool = true
    
    /// If true all the components of tab bar having bottom constaint will be attached to bottomLayoutGuide
    /// of tabbedViewControlller. On false will attach to bottom of tabbedViewController.view.
    /// Value can be updated with tabbedViewController.attachToBottomLayoutGuid if defined and not nil.
    var attachToBottomLayoutGuid: Bool = true
    
    /// Insets for tabbedViewController. 
    /// Value can be updated with tabbedViewController.insets if defined and not nil.
    var intsets: UIEdgeInsets = .zero
    
    private var _position: TabBarPosition?
    private var _state: TabBarState?
    
    private var _menuEdgeConstraint: NSLayoutConstraint?
    private var _betweenMenuAndContentConstraint: NSLayoutConstraint?
    private var _contentEdgeConstraint: NSLayoutConstraint?
    
    private var _menuDimensionConstraint: NSLayoutConstraint?
    private var _menuBeforeEdgeConstraint: NSLayoutConstraint?
    private var _menuAfterEdgeConstraint: NSLayoutConstraint?
    private var _contentBeforeEdgeConstraint: NSLayoutConstraint?
    private var _contentAfterEdgeConstraint: NSLayoutConstraint?
    
    private mutating func _updatePosition() {
        guard let _position = _position else {
            return
        }
        
        switch _position {
        case .top:
            _setTop()
        case .bottom:
            _setBottom()
        case .left:
            _setLeft()
        case .right:
            _setRight()
        }
    }
    
    private func _updateState(animated: Bool) {
        guard let _state = _state, let _position = _position else {
            return
        }
        
        var animated = animated
        var sign: CGFloat = 1
        switch _position {
        case .top, .left:
            sign = -1
        default: break
        }
        
        switch _state {
        case .closed:
            _setClosed(sign: sign)
        case .opened:
            animated = false
            _setOpened()
        case .openedOverContent:
            _setOpenedOverContent(sign: sign)
        case .openedSlidingContent:
            _setOpenedSlidingContent(sign: sign)
        }
        
        UIView.animate(withDuration: animated ? XMenuAnimationDuration : 0) {
            self.menuController?.view.layoutIfNeeded()
        }
    }
    
    private func _setOpened() {
        _menuEdgeConstraint?.constant = 0
        _betweenMenuAndContentConstraint?.constant = 0
        _contentEdgeConstraint?.constant = 0
    }
    
    private func _setClosed(sign: CGFloat) {
        _menuEdgeConstraint?.constant = sign * 44
        _betweenMenuAndContentConstraint?.constant = 0
        _contentEdgeConstraint?.constant = 0
    }
    
    private func _setOpenedOverContent(sign: CGFloat) {
        _menuEdgeConstraint?.constant = 0
        _betweenMenuAndContentConstraint?.constant = sign * -44
        _contentEdgeConstraint?.constant = 0
    }
    
    private func _setOpenedSlidingContent(sign: CGFloat) {
        _menuEdgeConstraint?.constant = 0
        _betweenMenuAndContentConstraint?.constant = 0
        _contentEdgeConstraint?.constant = sign * -44
    }
    
    private mutating func _setTop() {
        guard let menuController = menuController else {
            return
        }
        
        let menuView = menuController.menuContainerView.view
        let contentView = menuController.contentContainerView
        
        _uninstallAllConstraints()
        
        let topItem: (Any?, NSLayoutAttribute) = attachToTopLayoutGuid ? (menuController.topLayoutGuide, .bottom) : (menuController.view, .top)
        let bottomItem: (Any?, NSLayoutAttribute) = attachToBottomLayoutGuid ? (menuController.bottomLayoutGuide, .top) : (menuController.view, .bottom)
        
        _menuEdgeConstraint = NSLayoutConstraint(item: (menuView, .top), toItem: topItem)
        _betweenMenuAndContentConstraint = NSLayoutConstraint(item: (menuView, .bottom), toItem: (contentView, .top))
        _contentEdgeConstraint = NSLayoutConstraint(item: (contentView, .bottom), toItem: bottomItem)
        
        _setupConstraintsForHorizontalMenu(for: menuView, contentView: contentView, controller: menuController)
        _installAllConstraint()
    }
    
    private mutating func _setBottom() {
        guard let menuController = menuController else {
            return
        }
        
        let menuView = menuController.menuContainerView.view
        let contentView = menuController.contentContainerView
        
        _uninstallAllConstraints()
        
        let topItem: Any = attachToTopLayoutGuid ? menuController.topLayoutGuide : menuController.view
        let bottomItem: Any = attachToBottomLayoutGuid ? menuController.bottomLayoutGuide : menuController.view
        
        _menuEdgeConstraint = NSLayoutConstraint(item: (menuView, .bottom), toItem: (bottomItem, .top))
        _betweenMenuAndContentConstraint = NSLayoutConstraint(item: (menuView, .top), toItem: (contentView, .bottom))
        _contentEdgeConstraint = NSLayoutConstraint(item: (contentView, .top), toItem: (topItem, .bottom))
        
        _setupConstraintsForHorizontalMenu(for: menuView, contentView: contentView, controller: menuController)
        _installAllConstraint()
    }
    
    private mutating func _setLeft() {
        guard let menuController = menuController else {
            return
        }
        
        let menuView = menuController.menuContainerView.view
        let contentView = menuController.contentContainerView
        
        _uninstallAllConstraints()
        
        _menuEdgeConstraint = NSLayoutConstraint(item: (menuView, .left), toItem: (menuController.view, .left))
        _betweenMenuAndContentConstraint = NSLayoutConstraint(item: (menuView, .right), toItem: (contentView, .left))
        _contentEdgeConstraint = NSLayoutConstraint(item: (contentView, .right), toItem: (menuController.view, .right))
        
        _setupConstraintsForVerticalMenu(for: menuView, contentView: contentView, controller: menuController)
        _installAllConstraint()
    }
    
    private mutating func _setRight() {
        guard let menuController = menuController else {
            return
        }
        
        let menuView = menuController.menuContainerView.view
        let contentView = menuController.contentContainerView
        
        _uninstallAllConstraints()
        
        _menuEdgeConstraint = NSLayoutConstraint(item: (menuView, .right), toItem: (menuController.view, .right))
        _betweenMenuAndContentConstraint = NSLayoutConstraint(item: (menuView, .left), toItem: (contentView, .right))
        _contentEdgeConstraint = NSLayoutConstraint(item: (contentView, .left), toItem: (menuController.view, .left))
        
        _setupConstraintsForVerticalMenu(for: menuView, contentView: contentView, controller: menuController)
        _installAllConstraint()
    }
    
    private mutating func _setupConstraintsForHorizontalMenu(for menuView: UIView, contentView: UIView, controller: UIViewController) {
        _menuDimensionConstraint = NSLayoutConstraint(item: (menuView, .height), toItem: (nil, .notAnAttribute), constant: 44)
        _menuBeforeEdgeConstraint = NSLayoutConstraint(item: (menuView, .left), toItem: (controller.view, .left))
        _menuAfterEdgeConstraint = NSLayoutConstraint(item: (menuView, .right), toItem: (controller.view, .right))
        _contentBeforeEdgeConstraint = NSLayoutConstraint(item: (contentView, .left), toItem: (controller.view, .left))
        _contentAfterEdgeConstraint = NSLayoutConstraint(item: (contentView, .right), toItem: (controller.view, .right))
    }
    
    private mutating func _setupConstraintsForVerticalMenu(for menuView: UIView, contentView: UIView, controller: UIViewController) {
        let topItem: (Any?, NSLayoutAttribute) = attachToTopLayoutGuid ? (controller.topLayoutGuide, .bottom) : (controller.view, .top)
        let bottomItem: (Any?, NSLayoutAttribute) = attachToBottomLayoutGuid ? (controller.bottomLayoutGuide, .top) : (controller.view, .bottom)
        
        _menuDimensionConstraint = NSLayoutConstraint(item: (menuView, .width), toItem: (nil, .notAnAttribute), constant: 44)
        _menuBeforeEdgeConstraint = NSLayoutConstraint(item: (menuView, .top), toItem: topItem)
        _menuAfterEdgeConstraint = NSLayoutConstraint(item: (menuView, .bottom), toItem: bottomItem)
        _contentBeforeEdgeConstraint = NSLayoutConstraint(item: (contentView, .top), toItem: topItem)
        _contentAfterEdgeConstraint = NSLayoutConstraint(item: (contentView, .bottom), toItem: bottomItem)
    }
    
    private func _uninstallAllConstraints() {
        _menuEdgeConstraint?.isActive = false
        _betweenMenuAndContentConstraint?.isActive = false
        _contentEdgeConstraint?.isActive = false
        _menuDimensionConstraint?.isActive = false
        _menuBeforeEdgeConstraint?.isActive = false
        _menuAfterEdgeConstraint?.isActive = false
        _contentBeforeEdgeConstraint?.isActive = false
        _contentAfterEdgeConstraint?.isActive = false
    }
    
    private func _installAllConstraint() {
        guard let menuController = menuController else {
            return
        }
        
        let menuView = menuController.menuContainerView.view
        
        let constraints = [
            _menuEdgeConstraint,
            _betweenMenuAndContentConstraint,
            _contentEdgeConstraint,
            _menuBeforeEdgeConstraint,
            _menuAfterEdgeConstraint,
            _contentBeforeEdgeConstraint,
            _contentAfterEdgeConstraint
            ].flatMap { $0 }
        
        menuController.view.addConstraints(constraints)
        
        if let _menuDimensionConstraint = _menuDimensionConstraint {
            menuView.addConstraint(_menuDimensionConstraint)
        }
    }
}
