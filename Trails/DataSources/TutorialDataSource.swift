import Foundation
import Koloda

class TutorialDataSource: KolodaViewDataSource {
	
	var tutorialCards = [UIImage(named: "Card1")!,
		UIImage(named: "Card2")!,
		UIImage(named: "Card3")!,
		UIImage(named: "Card4")!,
		UIImage(named: "Card5")!]
	
	func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
		return UInt(tutorialCards.count)
	}
	
	func kolodaViewForCardAtIndex(koloda: KolodaView, index: UInt) -> UIView {
		let cardView = getViewFromNibNamed("CardView") as! CardView
		cardView.render(tutorialCards[Int(index)])
		return cardView
	}
	
	func kolodaViewForCardOverlayAtIndex(koloda: KolodaView, index: UInt) -> OverlayView? {
		return getViewFromNibNamed("CustomOverlayView") as? OverlayView
	}
	
	private func getViewFromNibNamed(name: String) -> UIView {
		return NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)[0] as! UIView
	}
}
