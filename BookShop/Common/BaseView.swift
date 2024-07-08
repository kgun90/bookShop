//
//  BaseView.swift
//  BookShop
//
//  Created by gkang on 7/1/24.
//

import UIKit


protocol Base {
    func viewInit()
    func setup()
    func interface()
}

class BaseLabel: UILabel {
    convenience init(
        text: String? = nil,
        size: CGFloat = 15,
        weight: UIFont.Weight = .regular,
        numberOfLines: Int = 0,
        textColor: UIColor = .white,
        alignment: NSTextAlignment = .left
    ) {
        self.init(frame: .zero)
        self.text = text
        self.font = .systemFont(ofSize: size, weight: weight)
        self.textColor = textColor
        self.numberOfLines = numberOfLines

        self.textAlignment = alignment
        self.layer.masksToBounds = true
                
        if #available(iOS 14.0, *) {
            self.lineBreakStrategy = .hangulWordPriority
        } else {
            self.lineBreakMode = .byWordWrapping
        }
    }
}


class BaseView: UIView, Base {
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInit()
    }
    
    func viewInit() {
        setup()
        interface()
    }
    
    func setup() {}
    func interface() {}
}


class BaseTableViewCell: UITableViewCell, Base {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        viewInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        selectionStyle = .none
        viewInit()
    }
        
    func viewInit() {
        setup()
        interface()
    }
    
    func setup() {}
    func interface() {}
}
