import UIKit
import SwiftyDropbox
import Koloda
import pop
import ObjectMapper

private let frameAnimationSpringBounciness:CGFloat = 9
private let frameAnimationSpringSpeed:CGFloat = 16

class HomeViewController: UIViewController {
	
	@IBOutlet weak var kolodaView: TrailView!
	@IBOutlet weak var toggleDropboxLink: UIBarButtonItem!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	var trailDataSource = TrailDataSource()
	var tutorialDataSource = TutorialDataSource()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupKolodaView()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		if verifyDropboxAuthorization() {
			setupTrailDataSource()
		} else {
			setupTutorialDataSource()
		}
	}
	
	private func setupTrailDataSource() {
		kolodaView.dataSource = trailDataSource
		kolodaView.resetCurrentCardNumber()
		fetchNextEvaluation()
	}
	
	private func setupTutorialDataSource() {
		kolodaView.dataSource = tutorialDataSource
		activityIndicator.stopAnimating()
	}
	
	private func fetchNextEvaluation() {
		activityIndicator.startAnimating()
		trailDataSource.fetchNext(dataSourceFetchSuccess, failure: dataSourceFetchFailure)
	}
	
	private func dataSourceFetchFailure() {
		self.activityIndicator.stopAnimating()
	}
	
	private func dataSourceFetchSuccess() {
		self.activityIndicator.stopAnimating()
		self.kolodaView.reloadData()
	}
	
	private func setupKolodaView() {
		kolodaView.delegate = self
		kolodaView.alphaValueSemiTransparent = 0.1
		kolodaView.countOfVisibleCards = 6
		self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
	}
	
	private func isShowingTutorial() -> Bool {
		return kolodaView.dataSource is TutorialDataSource
	}
	
	func verifyDropboxAuthorization() ->  Bool {
		if let authorizedClient = Dropbox.authorizedClient {
			let dropboxAccessTokens = DropboxAuthManager.sharedAuthManager.getAllAccessTokens().keys
			
			if dropboxAccessTokens.count > 0 {
				let userId = dropboxAccessTokens.reverse().first!
				let authToken = DropboxAuthManager.sharedAuthManager.getAccessToken(userId)
				
				Account.instance.registerDropbox(userId, accessToken: authToken!.description)
				authorizedClient.usersGetCurrentAccount().response { response, error in
					if let account = response {
						Account.instance.update(account)
					} else {
						print(error!)
					}
				}
				
				return true
			} else {
				Dropbox.unlinkClient()
				return verifyDropboxAuthorization()
			}
		}
		return false
	}
	
	private func didSwipeTrailAtIndex(index: Int, direction: SwipeResultDirection) {
		let trail = trailDataSource.trails[index]
		switch direction {
		case .Right:
			trail.didLikeItem()
		default:
			trail.didDislikeItem()
		}
	}
	
	@IBAction func storiesTouched(sender: AnyObject) {
	}
	
	@IBAction func leftButtonTapped() {
		kolodaView?.swipe(SwipeResultDirection.Left)
	}
	
	@IBAction func rightButtonTapped() {
		kolodaView?.swipe(SwipeResultDirection.Right)
	}
	
	@IBAction func undoButtonTapped() {
		kolodaView?.revertAction()
	}
	
	@IBAction func didTapDropboxLink(sender: AnyObject) {
		if let _ = Dropbox.authorizedClient {
			Dropbox.unlinkClient()
			verifyDropboxAuthorization()
		} else {
			Dropbox.authorizeFromController(self)
		}
	}
}

extension HomeViewController: KolodaViewDelegate {
	
	func kolodaDidSwipedCardAtIndex(koloda: KolodaView, index: UInt, direction: SwipeResultDirection) {
		if !isShowingTutorial() {
			let numberOfCards = trailDataSource.kolodaNumberOfCards(kolodaView)
			guard index < numberOfCards - 1 else {
				print("Index out of bounds benchod!")
				return
			}
			
			didSwipeTrailAtIndex(Int(index), direction: direction)
		} else {
			let numberOfCards = tutorialDataSource.kolodaNumberOfCards(kolodaView)
			if index == numberOfCards - 2 {
				toggleDropboxLink.enabled = true
			}
		}
	}
	
	func kolodaDidRunOutOfCards(koloda: KolodaView) {
		if isShowingTutorial() {
			kolodaView.resetCurrentCardNumber()
		} else {
			fetchNextEvaluation()
		}
	}
	
	func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
		print("Selected card at index \(index)")
	}
	
	func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
		return true
	}
	
	func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
		return false
	}
	
	func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
		return false
	}
	
	func kolodaBackgroundCardAnimation(koloda: KolodaView) -> POPPropertyAnimation? {
		let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
		animation.springBounciness = frameAnimationSpringBounciness
		animation.springSpeed = frameAnimationSpringSpeed
		return animation
	}

}
