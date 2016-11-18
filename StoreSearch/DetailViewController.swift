//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Hans Ravnaas on 11/18/16.
//  Copyright © 2016 Hans Ravnaas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController
{
	@IBOutlet weak var popupView: UIView!
	@IBOutlet weak var artworkImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var artistNameLabel: UILabel!
	@IBOutlet weak var kindLabel: UILabel!
	@IBOutlet weak var genreLabel: UILabel!
	@IBOutlet weak var priceButton: UIButton!
	
	var searchResult: SearchResult!
	var downloadTask: URLSessionDownloadTask?
	
	@IBAction func close()
	{
		dismiss(animated: true, completion: nil)
	}

	override func viewDidLoad()
	{
		super.viewDidLoad()

		popupView.layer.cornerRadius = 10
		view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
		
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
		gestureRecognizer.cancelsTouchesInView = false
		gestureRecognizer.delegate = self
		view.addGestureRecognizer(gestureRecognizer)
		
		if searchResult != nil
		{
			updateUI()
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		
		modalPresentationStyle = .custom
		transitioningDelegate = self
	}
	
	func updateUI()
	{
		if let largeURL = URL(string: searchResult.artworkLargeURL)
		{
			downloadTask = artworkImageView.loadImage(url: largeURL)
		}
		
		nameLabel.text = searchResult.name
		if searchResult.artistName.isEmpty
		{
			artistNameLabel.text = "Unknown"
		}
		else
		{
			artistNameLabel.text = searchResult.artistName
		}
		
		kindLabel.text = searchResult.kindForDisplay()
		genreLabel.text = searchResult.genre
		
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.currencyCode = searchResult.currency
		let priceText: String
		if searchResult.price == 0
		{
			priceText = "Free"
		}
		else if let text = formatter.string(from: searchResult.price as NSNumber)
		{
			priceText = text
		}
		else
		{
			priceText = ""
		}

		priceButton.setTitle(priceText, for: .normal)
	}
	
	@IBAction func openInStore()
	{
		if let url = URL(string: searchResult.storeURL)
		{
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}
	
	deinit
	{
		print("deinit \(self)")
		downloadTask?.cancel()
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: UIGestureRecognizerDelegate
{
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
	{
		return (touch.view === self.view)
	}
}
