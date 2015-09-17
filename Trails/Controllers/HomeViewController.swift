import UIKit
import SwiftyDropbox
import Koloda
import pop
import ObjectMapper

private let frameAnimationSpringBounciness:CGFloat = 9
private let frameAnimationSpringSpeed:CGFloat = 16

class HomeViewController: UIViewController, KolodaViewDelegate {
    
    @IBOutlet weak var kolodaView: TrailView!
    @IBOutlet weak var toggleDropboxLink: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var trailDataSource = TrailDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKolodaView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if verifyDropboxAuthorization() {
            kolodaView.dataSource = trailDataSource
            fetchNextEvaluation()
        } else {
            
            activityIndicator.stopAnimating()
        }
    }
    
    func fetchNextEvaluation() {
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
    
    func setupKolodaView() {
        kolodaView.delegate = self
        kolodaView.alphaValueSemiTransparent = 0.1
        kolodaView.countOfVisibleCards = 6
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
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
    
    
    func kolodaDidSwipedCardAtIndex(koloda: KolodaView, index: UInt, direction: SwipeResultDirection) {
        if Int(index) >= trailDataSource.trails.count {
            print("What the fuck is happening!!")
            return
        }
        
        let trail = trailDataSource.trails[Int(index)]
        switch direction{
        case .Right:
            trail.didLikeItem()
        case .Left:
            trail.didDislikeItem()
            
        default:
            print("Are you serious?")
        }
    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        fetchNextEvaluation()
    }
    
    func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
        //do something magical here
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
    
    func verifyDropboxAuthorization() ->  Bool {
        if let authorizedClient = Dropbox.authorizedClient {
            toggleDropboxLink.enabled = false
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
        toggleDropboxLink.enabled = true
        return false
    }
    
    @IBAction func didTapDropboxLink(sender: AnyObject) {
        if let _ = Dropbox.authorizedClient {
            Dropbox.unlinkClient()
            verifyDropboxAuthorization()
        } else {
           Dropbox.authorizeFromController(self)
        }
    }
    
    @IBAction func linkButtonPressed(sender: AnyObject) {
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
        }
    }
}
