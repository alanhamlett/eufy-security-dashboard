/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

class AlertPopupView: PopupView {
    
    fileprivate var dialogImage: UIImageView?
    fileprivate var titleLabel: UILabel!
    fileprivate var messageTextView: UITextView!
    fileprivate var containerView: UIView!
    fileprivate let kPadding: CGFloat = 12.0
    fileprivate var maxHeight = UIScreen.main.bounds.height
    
    init(image: UIImage?, title: String, message: String) {
        super.init(frame: CGRect.zero)
        
        overlayDismisses = false
        defaultShowType = .normal
        defaultDismissType = .noAnimation
        presentsOverWindow = true
        
        containerView = UIView(frame: CGRect.zero)
        containerView.autoresizingMask = [.flexibleWidth]
        
        if let image = image {
            let di = UIImageView(image: image)
            containerView.addSubview(di)
            dialogImage = di
            dialogImage?.contentMode = .scaleAspectFit
        }
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.roundedFont(ofSize: .title2, weight: .bold)
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        containerView.addSubview(titleLabel)
        
        messageTextView = UITextView(frame: CGRect.zero)
        messageTextView.textColor = UIColor(white: 0, alpha: 0.7)
        messageTextView.textAlignment = .center
        messageTextView.font = UIFont.roundedFont(ofSize: .body, weight: .regular)
        messageTextView.text = message
        messageTextView.isEditable = false
        messageTextView.showsVerticalScrollIndicator = true
        messageTextView.showsHorizontalScrollIndicator = false
        messageTextView.isScrollEnabled = true
        messageTextView.alwaysBounceVertical = true
        messageTextView.backgroundColor = .clear
        containerView.addSubview(messageTextView)
        
        updateSubviews()
        
        setPopupContentView(view: containerView)
        setStyle(popupStyle: .dialog)
        setDialogColor(color: .white)
    }
    
    func updateSubviews() {
        let width: CGFloat = dialogWidth
        
        var imageFrame: CGRect = dialogImage?.frame ?? CGRect.zero
        if let dialogImage = dialogImage {
            imageFrame.origin.x = (width - imageFrame.width) / 2.0
            imageFrame.origin.y = 10
            imageFrame.size.height = min(imageFrame.size.height, 190)
            dialogImage.frame = imageFrame
        }
        
        let titleLabelSize: CGSize = titleLabel.sizeThatFits(CGSize(width: width - kPadding * 3.0, height: CGFloat.greatestFiniteMagnitude))
        var titleLabelFrame: CGRect = titleLabel.frame
        titleLabelFrame.size = titleLabelSize
        titleLabelFrame.origin.x = rint((width - titleLabelSize.width) / 2.0)
        titleLabelFrame.origin.y = imageFrame.maxY + kPadding
        titleLabel.frame = titleLabelFrame
        
        let maxTextHeight = maxHeight - kPadding * 1.5 - titleLabelFrame.maxY - kPadding * 1.5 / 2.0 - 160
        
        var messageTextViewSize: CGSize = messageTextView.sizeThatFits(CGSize(width: width - kPadding * 4.0, height: CGFloat.greatestFiniteMagnitude))
        var messageTextViewFrame: CGRect = messageTextView.frame
        
        messageTextViewSize.height = min(messageTextViewSize.height, maxTextHeight)
        
        messageTextViewFrame.size = messageTextViewSize
        messageTextViewFrame.origin.x = rint((width - messageTextViewSize.width) / 2.0)
        messageTextViewFrame.origin.y = rint(titleLabelFrame.maxY + kPadding * 1.5 / 2.0)
        messageTextView.frame = messageTextViewFrame
        
        var containerViewFrame: CGRect = containerView.frame
        containerViewFrame.size.width = width
        containerViewFrame.size.height = messageTextViewFrame.maxY + kPadding * 1.5
        containerView.frame = containerViewFrame
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        maxHeight = UIScreen.main.bounds.height
        updateSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
