//
//  IPadContentVideoPlaylistDataSource.swift
//  MBC
//
//  Created by Tri Vo Minh on 4/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

enum ContentVideoInfoSection: Int {
	case contentInfo = 0
	case description = 1
	case headerComment = 2
	case inputMessage = 3
	case comments = 4
	case loadMoreComment = 5
}

class IPadContentVideoInfoDataSource: NSObject {
	
	private let viewModel: VideoPlaylistViewModel
	
	init(viewModel: VideoPlaylistViewModel) {
		self.viewModel = viewModel
		super.init()
	}

	func registerCell(of tableView: UITableView) {
		tableView.register(R.nib.iPadVideoPlaylistHeaderCell(),
						   forCellReuseIdentifier: R.reuseIdentifier.iPadVideoPlaylistHeaderCell.identifier)
		tableView.register(R.nib.iPadVideoPlaylistDescriptionCell(),
						   forCellReuseIdentifier: R.reuseIdentifier.iPadVideoPlaylistDescriptionCell.identifier)
		tableView.register(R.nib.iPadHeaderCommentCell(),
						   forCellReuseIdentifier: R.reuseIdentifier.iPadHeaderCommentCell.identifier)
		tableView.register(R.nib.inputMessageViewCell(),
						   forCellReuseIdentifier: R.reuseIdentifier.inputMessageViewCell.identifier)
		tableView.register(R.nib.commentViewCell(),
						   forCellReuseIdentifier: R.reuseIdentifier.commentViewCellId.identifier)
	}
	
	func numberOfSections() -> Int {
		return 6
	}
	
	func tableView(numberOfRowsInSection section: Int) -> Int {
		if section == ContentVideoInfoSection.contentInfo.rawValue { return 1 }
		if section == ContentVideoInfoSection.description.rawValue { return 1 }
		if section == ContentVideoInfoSection.headerComment.rawValue { return 1 }
		if section == ContentVideoInfoSection.inputMessage.rawValue { return 1 }
		if section == ContentVideoInfoSection.comments.rawValue { return 1 }
		if section == ContentVideoInfoSection.loadMoreComment.rawValue { return 1 }
		return 0
	}
	
	func cellForIndexPath(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == ContentVideoInfoSection.contentInfo.rawValue {
			return contentInfoCell(tableView, at: indexPath)
		}

		if indexPath.section == ContentVideoInfoSection.description.rawValue {
			return descriptionCell(tableView, at: indexPath)
		}

		if indexPath.section == ContentVideoInfoSection.headerComment.rawValue {
			return headerCommentCell(tableView, at: indexPath)
		}

		if indexPath.section == ContentVideoInfoSection.inputMessage.rawValue {
			return inputMessageCell(tableView, at: indexPath)
		}

		if indexPath.section == ContentVideoInfoSection.comments.rawValue {
			return commentCell(tableView, at: indexPath)
		}
		
		if indexPath.section == ContentVideoInfoSection.loadMoreComment.rawValue {
			return loadMoreCommentCell(tableView, at: indexPath)
		}
		
		return UITableViewCell()
	}
}

// MARK: - Make Cell
extension IPadContentVideoInfoDataSource {
	func contentInfoCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.iPadVideoPlaylistHeaderCell.identifier) as? IPadVideoPlaylistHeaderCell else {
				return UITableViewCell() }
		
		return cell
	}
	
	func descriptionCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.iPadVideoPlaylistDescriptionCell.identifier) as? IPadVideoPlaylistDescriptionCell else {
				return UITableViewCell() }
		
		return cell
	}
	
	func headerCommentCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.inputMessageViewCell.identifier) as? InputMessageViewCell else {
				return UITableViewCell() }
		
		return cell
	}
	
	func inputMessageCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.iPadHeaderCommentCell.identifier) as? HeaderCommentViewCell else {
				return UITableViewCell() }
		
		return cell
	}
	
	func commentCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.commentViewCellId.identifier) as? CommentViewCell else {
				return UITableViewCell() }
		
		return cell
	}
	
	func loadMoreCommentCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.loadMoreCommentCell.identifier) as? LoadMoreCommentCell else {
				return UITableViewCell() }
		
		return cell
	}
}
