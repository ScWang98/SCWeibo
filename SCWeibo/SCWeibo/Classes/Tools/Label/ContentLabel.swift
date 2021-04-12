//
//  ContentLabel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/12.
//

import UIKit

protocol ContentLabelDelegate: class {
    func contentLabel(label: ContentLabel, didTapSchema: String)
}

public class ContentLabelTextModel {
    var text: NSMutableAttributedString
    var schemas = [SchemaModel]()

    init(text: NSMutableAttributedString) {
        self.text = text
    }

    class SchemaModel {
        var range: NSRange
        var schema: String

        init(range: NSRange, schema: String) {
            self.range = range
            self.schema = schema
        }
    }
}

public class ContentLabel: UILabel {
    weak var delegate: ContentLabelDelegate?

    public var linkTextColor = UIColor.sc.color(with: 0x647CADFF)
    public var selectedBackgroudColor = UIColor.lightGray

    public var textModel: ContentLabelTextModel? {
        didSet {
            parseTextModel()
        }
    }

    // MARK: - upadte text storage and redraw text

    override public func drawText(in rect: CGRect) {
        let range = glyphsRange()
        let offset = glyphsOffset(range)

        layoutManager.drawBackground(forGlyphRange: range, at: offset)
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint.zero)
    }

    private func glyphsRange() -> NSRange {
        return NSRange(location: 0, length: textStorage.length)
    }

    private func glyphsOffset(_ range: NSRange) -> CGPoint {
        let rect = layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
        let height = (bounds.height - rect.height) * 0.5

        return CGPoint(x: 0, y: height)
    }

    private func modifySelectedAttribute(_ range: NSRange, _ selected: Bool) {
        var attributes = textStorage.attributes(at: 0, effectiveRange: nil)
        attributes[NSAttributedString.Key.foregroundColor] = linkTextColor
        attributes[NSAttributedString.Key.backgroundColor] = selected ? selectedBackgroudColor : UIColor.clear

        textStorage.addAttributes(attributes, range: range)

        setNeedsDisplay()
    }

    private func hyperLinkSchema(at location: CGPoint) -> ContentLabelTextModel.SchemaModel? {
        guard let textModel = textModel,
              textStorage.length != 0 else {
            return nil
        }

        let offset = glyphsOffset(glyphsRange())
        let point = CGPoint(x: offset.x + location.x, y: offset.y + location.y)
        let index = layoutManager.glyphIndex(for: point, in: textContainer)

        for schema in textModel.schemas {
            let range = schema.range
            if index >= range.location && index <= range.location + range.length {
                return schema
            }
        }

        return nil
    }

    // MARK: - init functions

    override public init(frame: CGRect) {
        super.init(frame: frame)

        prepareLabel()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        prepareLabel()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        textContainer.size = bounds.size
    }

    private func prepareLabel() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(hyperLinkDidTap(tap:)))
        tap.delegate = self
        addGestureRecognizer(tap)
    }

    // MARK: lazy properties
    private lazy var textStorage = NSTextStorage()
    private lazy var layoutManager = NSLayoutManager()
    private lazy var textContainer = NSTextContainer()
}

// MARK: - Touch Event

extension ContentLabel: UIGestureRecognizerDelegate {
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let tap = gestureRecognizer as? UITapGestureRecognizer {
            let location = tap.location(in: self)
            return hyperLinkSchema(at: location) != nil
        }
        return true
    }

    @objc func hyperLinkDidTap(tap: UITapGestureRecognizer) {
        let location = tap.location(in: self)
        guard let schema = hyperLinkSchema(at: location) else {
            return
        }

        modifySelectedAttribute(schema.range, true)
        delegate?.contentLabel(label: self, didTapSchema: schema.schema)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.modifySelectedAttribute(schema.range, false)
        }
    }
}

// MARK: - Link attribute

private extension ContentLabel {
    func addLinkAttribute(_ attrStringM: NSMutableAttributedString) {
        guard let textModel = textModel,
              attrStringM.length != 0 else {
            return
        }

        var range = NSRange(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)

        attributes[NSAttributedString.Key.font] = font
        attributes[NSAttributedString.Key.foregroundColor] = textColor
        attrStringM.addAttributes(attributes, range: range)

        attributes[NSAttributedString.Key.foregroundColor] = linkTextColor

        for schema in textModel.schemas {
            let range = schema.range
            attrStringM.setAttributes(attributes, range: range)
        }
    }

    private func parseTextModel() {
        guard let textModel = textModel else {
            return
        }

        let attrString = NSMutableAttributedString(attributedString: textModel.text)
        addLinkAttribute(attrString)

        textStorage.setAttributedString(attrString)
        attributedText = attrString
    }
}
