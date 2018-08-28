extension UIView {
    enum MainAnchors {
        case leading
        case trailing
        case top
        case bottom
        case centerX
        case centerY
    }
    
    enum SeparatorType {
        case top
        case bottom
        var tag: Int {
            switch self {
            case .top:
                return 777777
            case .bottom:
                return 666666
            }
        }
    }
    
    func centerAtSuperView() {
        guard let superView = superview else {return}
        superView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        superView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func addFourAnchorsToSuperview(margins: UIEdgeInsets?) {
        guard let superView = superview else {return}
        
        if let margins = margins {
            superView.topAnchor.constraint(equalTo: topAnchor, constant: margins.top).isActive = true
            superView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: margins.bottom).isActive = true
            superView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margins.left).isActive = true
            superView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: margins.right).isActive = true
        } else {
            superView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            superView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            superView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            superView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
    
    @discardableResult
    func addAnchorToSuperview(anchor: MainAnchors, margin: CGFloat) -> UIView {
        guard let superView = superview else {return self}
        
        switch anchor {
        case .leading:
            superView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        case .trailing:
            superView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: margin).isActive = true
        case .top:
            superView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        case .bottom:
            superView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: margin).isActive = true
        case .centerX:
            superView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: margin).isActive = true
        case .centerY:
            superView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: margin).isActive = true
        }
        return self
    }
    
    /// Adds or removes(if exists) the bottom / top separator views.
    func toggleSeparator(_ toggle: Bool, type: SeparatorType, color: UIColor, height: CGFloat, _ leftInsect: CGFloat, _ rightInsect: CGFloat) {
        func removeSeparatorView() {
            for sep in subviews {
                if type == .top && sep.tag == type.tag {sep.removeFromSuperview(); return}
                if type == .bottom && sep.tag == type.tag {sep.removeFromSuperview(); return}
                
            }
        }
        guard toggle else {removeSeparatorView(); return}
        
        removeSeparatorView()
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = color
        separator.tag = type.tag
        
        self.addSubview(separator)
        
        separator.heightAnchor.constraint(equalToConstant: height).isActive = true
        separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInsect).isActive = true
        separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -rightInsect).isActive = true
        if type == .top {
            separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        } else {
            separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
    
    /** Used to round only particular corners for view.
     
     Use this prior to iOS 11.
 
     Usage: view.roundCorners([.topLeft, .bottomRight], radius: 10).
     You must call this at `layoutSubviews`
     
     For iOS 11 there are new `CACornerMask`
     
     Usage: view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
     */
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func dropShadow(offsetX: CGFloat, offsetY: CGFloat, color: UIColor, opacity: Float, radius: CGFloat, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
