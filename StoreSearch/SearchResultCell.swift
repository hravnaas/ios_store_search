//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Hans Ravnaas on 11/17/16.
//  Copyright © 2016 Hans Ravnaas. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell
{
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var artistNameLabel: UILabel!
	@IBOutlet weak var artworkImageView: UIImageView!
	
	var downloadTask: URLSessionDownloadTask?
	
    override func awakeFromNib()
	{
        super.awakeFromNib()
		
		let selectedView = UIView(frame: CGRect.zero)
		selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
		selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	func configure(for searchResult: SearchResult)
	{
		nameLabel.text = searchResult.name
		if searchResult.artistName.isEmpty
		{
			artistNameLabel.text = "Unknown"
		}
		else
		{
			artistNameLabel.text = String(format: "%@ (%@)", searchResult.artistName, searchResult.kindForDisplay())
		}
		
		artworkImageView.image = UIImage(named: "Placeholder")
		if let smallURL = URL(string: searchResult.artworkSmallURL)
		{
			downloadTask = artworkImageView.loadImage(url: smallURL)
		}
	}
	
	override func prepareForReuse()
	{
		super.prepareForReuse()
		
		if let currentImageDownload = downloadTask
		{
			//print("Cancelling image download")
			currentImageDownload.cancel()
		}
		//downloadTask?.cancel()
		downloadTask = nil
	}
	
}
