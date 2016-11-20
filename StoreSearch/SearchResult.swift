import Foundation

class SearchResult
{
	var name = ""
	var artistName = ""
	var artworkSmallURL = ""
	var artworkLargeURL = ""
	var storeURL = ""
	var kind = ""
	var currency = ""
	var price = 0.0
	var genre = ""
	
	func kindForDisplay() -> String
	{
		switch kind
		{
			// TODO: Localize remaining case statements.
			// The actual translation happens in file Localizable.strings.
			case "album": return "Album"
			case "audiobook": return "Audio Book"
			case "book": return "Book"
			case "ebook": return "E-Book"
			case "feature-movie": return "Movie"
			case "music-video": return "Music Video"
			case "podcast": return "Podcast"
			case "software":
				return NSLocalizedString("App", comment: "Localized kind: Software")
			case "song":
				return NSLocalizedString("Song", comment: "Localized kind: Song")
			case "tv-episode": return "TV Episode"
			default: return kind
		}
	}
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool
{
	return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}
