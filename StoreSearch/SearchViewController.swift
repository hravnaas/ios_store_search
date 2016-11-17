//
//  ViewController.swift
//  StoreSearch
//
//  Created by Hans Ravnaas on 11/16/16.
//  Copyright © 2016 Hans Ravnaas. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
	struct TableViewCellIdentifiers
	{
		static let searchResultCell = "SearchResultCell"
		static let nothingFoundCell = "NothingFoundCell"
	}
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	
	var searchResults: [SearchResult] = []
	var hasSearched = false
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		searchBar.becomeFirstResponder()
		tableView.rowHeight = 80
		tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
		
		// Register cells with real data.
		var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
		
		// Register "not found" cell.
		cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}


}

////////////////// Extensions /////////////////////////

extension SearchViewController: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
	{
		searchBar.resignFirstResponder()
		searchResults = [SearchResult]()
		if searchBar.text! != "justin bieber"
		{
			for i in 0...2
			{
				let searchResult = SearchResult()
				searchResult.name = String(format: "Fake Result %d for", i)
				searchResult.artistName = searchBar.text!
				searchResults.append(searchResult)
			}
		}
		hasSearched = true
		tableView.reloadData()
	}
}

extension SearchViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		if !hasSearched
		{
			return 0
		}
		else if searchResults.count == 0
		{
			return 1
		}
		else
		{
			return searchResults.count
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		if searchResults.count == 0
		{
			return tableView.dequeueReusableCell(
				withIdentifier: TableViewCellIdentifiers.nothingFoundCell,
				for: indexPath)
		}
		else
		{
			let cell = tableView.dequeueReusableCell(
				withIdentifier: TableViewCellIdentifiers.searchResultCell,
				for: indexPath) as! SearchResultCell
			let searchResult = searchResults[indexPath.row]
			cell.nameLabel.text = searchResult.name
			cell.artistNameLabel.text = searchResult.artistName
			return cell
		}
	}
	
	func position(for bar: UIBarPositioning) -> UIBarPosition
	{
		return .topAttached
	}
}

extension SearchViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
	{
		if searchResults.count == 0 {
			return nil
		} else {
			return indexPath
		}
	}
}

