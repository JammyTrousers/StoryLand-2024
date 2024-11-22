//
//  StoryLabel.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import UIKit

protocol StoryLabelDelegate {
    func labelDidSelectedLinkText(label: StoryLabel, text: String)
}

class StoryLabel: UILabel {
    
    public var delegate : StoryLabelDelegate?
    
    public static var readTextColour = UIColor(red: 0.192, green: 0.435, blue: 0.682, alpha: 1.0)
    public static var skipTextColour = UIColor(red: 0.392, green: 0.635, blue: 0.882, alpha: 1.0)
    public static var unreadTextColour = UIColor(red: 0.549, green: 0.549, blue: 0.549, alpha: 1.0)
    
    public static var linkTextColor = UIColor(red: 0.192, green: 0.435, blue: 0.682, alpha: 1.0)
    public static var selectedBackgroudColor = UIColor(red: 0.549, green: 0.549, blue: 0.549, alpha: 1.0)
    
    private var selectedRange: NSRange?
    
    private lazy var textStorage = NSTextStorage()
    private lazy var layoutManager = NSLayoutManager()
    private lazy var textContainer = NSTextContainer()

    private var highlightedRange : NSRange?
    
    var storyFragment : StoryFragment? {
        didSet {
            guard let storyFragment = self.storyFragment else {
                self.attributedText = NSAttributedString(string: "")
                return
            }
            self.attributedText = NSAttributedString.make(with: storyFragment)
        }
    }
    
    
    override public var text: String? {
        didSet { updateTextStorage() }
    }
    
    override public var attributedText: NSAttributedString? {
        didSet { updateTextStorage() }
    }
    
    override public var font: UIFont! {
        didSet { updateTextStorage() }
    }
    
    override public var textColor: UIColor! {
        didSet { updateTextStorage() }
    }
    
    private func updateTextStorage() {
        if attributedText == nil {
            attributedText = NSAttributedString(string: text ?? "")
        }
        highlightedRange = nil
        let attrStringM = buildAttributes(attributedText!)
        textStorage.setAttributedString(attrStringM)
        setNeedsDisplay()
    }
    
    public func removeHighlight() {
        guard let highlightedRange = self.highlightedRange else {
            return
        }
        textStorage.removeAttribute(NSAttributedString.Key.backgroundColor, range: highlightedRange)
        setNeedsDisplay()
    }
    
    private func buildAttributes(_ attrString: NSAttributedString) -> NSMutableAttributedString {
        let attrStringM = NSMutableAttributedString(attributedString: attrString)
        
        if attrStringM.length == 0 {
            return attrStringM
        }
        let range = NSRange(location: 0, length: attrString.length)
        //var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        
        attrStringM.addAttributes([NSAttributedString.Key.font: self.font as Any], range: range)
        
        let paragraphStyleM = NSMutableParagraphStyle()
        paragraphStyleM.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyleM.alignment = .center

        
        attrStringM.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyleM], range: range)
        
        return attrStringM
    }
    
    public override func drawText(in rect: CGRect) {
        let range = glyphsRange()
        let offset = glyphsOffset(range)
        let textOffset = glyphsTextOffset(range)
        //draw background
        layoutManager.drawBackground(forGlyphRange: range, at: offset)
        //draw foreground
        layoutManager.drawGlyphs(forGlyphRange: range, at: textOffset)
    }
    
    private func glyphsRange() -> NSRange {
        return NSRange(location: 0, length: textStorage.length)
    }
    
    private func glyphsTextOffset(_ range: NSRange) -> CGPoint {
        let rect = layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
        let height = (bounds.height - rect.height) * 0.5
        return CGPoint(x: 0, y: height)
    }
    
    private func glyphsOffset(_ range: NSRange) -> CGPoint {
        let rect = layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
        let height = (bounds.height - rect.height) * 0.5
        return CGPoint(x: -4, y: height)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let storyFragment = self.storyFragment else {
            return
        }
        
        let range = glyphsRange()
        let textOffset = glyphsTextOffset(range)
        
        guard let touch = touches.first else {
            return
        }
        
        let _point = touch.location(in: self)
        let point = CGPoint(x: _point.x, y: _point.y - textOffset.y)
        
        //根据点来获取该位置glyph的index
        let index = self.layoutManager.glyphIndex(for: point, in: textContainer)
        
        //获取改glyph对应的rect
        let rect = self.layoutManager.boundingRect(forGlyphRange: NSMakeRange(index, 1), in: textContainer)
        
        //最终判断该字形的显示范围是否包括点击的location
        if rect.contains(point) {
            let charIndex = self.layoutManager.characterIndexForGlyph(at: index)
            var attributes = textStorage.attributes(at: charIndex, effectiveRange: nil)
            
            var startIndex = 0
            var endIndex = 0
            var textRange : NSRange?
            for i in 0..<storyFragment.tokenizedContent.count {
                startIndex = endIndex
                endIndex = startIndex + storyFragment.tokenizedContent[i].content.count
                let length = storyFragment.tokenizedContent[i].content.count
                
                print("\(startIndex) - \(endIndex)")
                
                if charIndex >= startIndex && charIndex < endIndex {
                    textRange = NSMakeRange(startIndex, length)
                    self.highlightedRange = textRange
                    self.delegate?.labelDidSelectedLinkText(label: self, text: storyFragment.tokenizedContent[i].content)
                    break
                }
            }
            
            guard let highlightedRange = textRange else {
                return
            }
            
            //attributes[NSAttributedStringKey.foregroundColor] = linkTextColor
            attributes[NSAttributedString.Key.backgroundColor] = UIColor.red.withAlphaComponent(0.1)
            textStorage.addAttributes(attributes, range: highlightedRange)
            
            //selectedRange = !isSet ? nil : selectedRange
            
            //highlightAttribute
            setNeedsDisplay()
        }
        
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        prepareLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareLabel()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }
    
    private func prepareLabel() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        isUserInteractionEnabled = true
        self.font = UIFont.systemFont(ofSize: 34)
    }
    
}
