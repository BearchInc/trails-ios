import Foundation
import UIKit
import RAMCollectionViewFlemishBondLayout

class StoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, RAMCollectionViewFlemishBondLayoutDelegate {

	var story: Story!
//
//	@IBOutlet weak var collectionView: UICollectionView! {
//		didSet {
//			let layout = self.collectionView.collectionViewLayout as! RAMCollectionViewFlemishBondLayout
//			layout.delegate = self
//		}
//	}
//	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		Story.fetchStories { (stories: Story?, errorType: ErrorType?) -> Void in
//			self.story = story
//			self.collectionView.reloadData()
//		}
//	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TrailCellIdentifier", forIndexPath: indexPath) as! TrailCell
		cell.render(story.trails[indexPath.row])
		return cell
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return story.trails.count
	}

	func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: RAMCollectionViewFlemishBondLayout!, highlightedCellDirectionForGroup group: Int, atIndexPath indexPath: NSIndexPath!) -> RAMCollectionViewFlemishBondLayoutGroupDirection {
		return indexPath.row % 2 == 0 ? .Left : .Right
	}

}