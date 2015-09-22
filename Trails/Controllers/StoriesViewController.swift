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
		fillStories()
	}
	
	private func fillStories() {
		let urls = ["/Camera Uploads/2013-02-24 15.47.44.mov",
			"/Camera Uploads/2013-02-24 15.55.31.jpg",
			"/Camera Uploads/2013-02-24 18.32.33.jpg",
			"/Camera Uploads/2013-03-01 12.38.58.jpg",
			"/Camera Uploads/2013-03-01 18.29.19.jpg",
			"/Camera Uploads/2013-03-02 11.05.37.jpg",
			"/Camera Uploads/2013-02-24 15.47.44.mov",
			"/Camera Uploads/2013-02-24 15.55.31.jpg",
			"/Camera Uploads/2013-02-24 18.32.33.jpg",
			"/Camera Uploads/2013-03-01 12.38.58.jpg",
			"/Camera Uploads/2013-03-01 18.29.19.jpg",
			"/Camera Uploads/2013-03-02 11.05.37.jpg"]
		
		for (index, url) in urls.enumerate() {
			let story = Story()
			story.title = ":) \(index)"
			story.imagePath = url
			story.trails = []
			let trail = Trail()
			trail.mediaPath = url
			
			story.trails.append(trail)
			story.trails.append(trail)
			story.trails.append(trail)
			
			stories.append(story)
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