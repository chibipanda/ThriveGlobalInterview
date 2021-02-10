import UIKit

class MovieCell: UITableViewCell {
    static let reuseId = String(describing: self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: MovieCell.reuseId)
        
        imageView?.contentMode = .scaleAspectFit
        textLabel?.textAlignment = .left
        detailTextLabel?.textAlignment = .left
        detailTextLabel?.lineBreakMode = .byTruncatingTail
        detailTextLabel?.lineBreakMode = .byWordWrapping
        detailTextLabel?.numberOfLines = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(movie: Movie) {
        detailTextLabel?.text = movie.movieSummary
        textLabel?.text = movie.movieTitle
        
        guard let imageURL = movie.imageURL else { return }
        ImageCache.shared.getImage(from: imageURL) { [weak self] image in
            self?.imageView?.image = image
        }
    }
}


