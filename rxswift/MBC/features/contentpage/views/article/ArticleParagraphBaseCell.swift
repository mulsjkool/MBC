//
//  ArticleParagraphBaseCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/25/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

class ArticleParagraphBaseCell: BaseTableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var descriptionLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var titleLabelTopConstraint: NSLayoutConstraint!
    private let titleLabelTopMargin: CGFloat = 16.0
    private let descriptionLabelTopMargin: CGFloat = 24.0
    
    var paragraph: Paragraph!
    var author: Author?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindData(paragraph: Paragraph, numberOfItem: Int, paragraphViewOption: ParagraphViewOptionEnum) {
        self.paragraph = paragraph
        descriptionLabel.from(html: paragraph.description)
        if let text = descriptionLabel.text {
            descriptionLabel.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        descriptionLabel.setLineSpacing(lineSpacing: 0,
                        lineHeightMultiple: Constants.DefaultValue.descriptionLineHeightMultiple)
        if numberOfItem == 1 {
            titleLabel.text = paragraph.title
        } else {
            if paragraphViewOption == ParagraphViewOptionEnum.numbered {
                titleLabel.text = (paragraph.title.isEmpty) ? "\(tag + 1)." : "\(tag + 1). \(paragraph.title)"
            } else if paragraphViewOption == ParagraphViewOptionEnum.countdown {
                let number = numberOfItem - tag
                titleLabel.text = (paragraph.title.isEmpty) ? "\(number)." : "\(number). \(paragraph.title)"
            } else {
                titleLabel.text = paragraph.title
            }
        }
        titleLabel.setLineSpacing(lineSpacing: 0,
                                  lineHeightMultiple: Constants.DefaultValue.descriptionLineHeightMultiple)
        
        if let descriptionLabelTopConstraint = descriptionLabelTopConstraint, let text = descriptionLabel.text {
            descriptionLabelTopConstraint.constant = text.isEmpty ? 0 : descriptionLabelTopMargin
        }
        
        if let titleLabelTopConstraint = titleLabelTopConstraint, let text = titleLabel.text {
            if text.isEmpty {
                titleLabelTopConstraint.constant = 0
                descriptionLabelTopConstraint.constant = 0
            } else {
                titleLabelTopConstraint.constant = titleLabelTopMargin
            }
        }
    }
}

extension ArticleParagraphBaseCell: IAnalyticsTrackingCell {

    func getTrackingObjects() -> [IAnalyticsTrackingObject] {
        guard let media = paragraph.media  else { return [] }

        return [AnalyticsContent(media: media,
                                       author: author?.name ?? "",
                                       index: tag)]
    }

}
