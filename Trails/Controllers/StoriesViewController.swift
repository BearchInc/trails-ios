import Foundation
import UIKit
import RAMCollectionViewFlemishBondLayout

class StoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, RAMCollectionViewFlemishBondLayoutDelegate {
	
	var stories = [Story]()

	@IBOutlet weak var collectionView: UICollectionView! {
		didSet {
			let layout = self.collectionView.collectionViewLayout as! RAMCollectionViewFlemishBondLayout
			layout.delegate = self
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		Story.fetchStories { (stories: [Story]?, errorType: ErrorType?) -> Void in
			
			guard errorType == nil else {
				return
			}
			
			self.stories += stories!
			self.collectionView.reloadData()
		}
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StoryCellIdentifier", forIndexPath: indexPath) as! StoryCell
		cell.render(stories[indexPath.row])
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return stories.count
	}
	
	func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: RAMCollectionViewFlemishBondLayout!, highlightedCellDirectionForGroup group: Int, atIndexPath indexPath: NSIndexPath!) -> RAMCollectionViewFlemishBondLayoutGroupDirection {
		return indexPath.row % 2 == 0 ? .Left : .Right
	}
	
	
	
}