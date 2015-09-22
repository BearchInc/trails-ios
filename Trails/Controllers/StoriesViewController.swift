import Foundation
import UIKit
import RAMCollectionViewFlemishBondLayout

class StoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, RAMCollectionViewFlemishBondLayoutDelegate {

	@IBOutlet weak var collectionView: UICollectionView! {
		didSet {
			let layout = self.collectionView.collectionViewLayout as! RAMCollectionViewFlemishBondLayout
			layout.delegate = self
		}
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StoryCellIdentifier", forIndexPath: indexPath) as! StoryCell
		cell.render()
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}
	
	func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: RAMCollectionViewFlemishBondLayout!, highlightedCellDirectionForGroup group: Int, atIndexPath indexPath: NSIndexPath!) -> RAMCollectionViewFlemishBondLayoutGroupDirection {
		return indexPath.row % 2 == 0 ? .Left : .Right
	}
	
	
}