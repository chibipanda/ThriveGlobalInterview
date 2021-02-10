import XCTest
@testable import MovieSearcher

class MovieSearcherTests: XCTestCase {

    var subject = SearchLogicController()
    
    func test_When_example_data_is_parsed_then_results_are_not_nil() {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "example_response", ofType: "json")
        let exampleResponseData = NSData(contentsOfFile: path!)
        let movies = subject.parseMovieSearchResponse(data: Data(exampleResponseData!))
        XCTAssertNotNil(movies)
    }
    
    func test_When_example_data_is_parsed_then_results_match_expected() {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "example_response", ofType: "json")
        let exampleResponseData = NSData(contentsOfFile: path!)
        let movies = subject.parseMovieSearchResponse(data: Data(exampleResponseData!))!
        XCTAssertEqual(movies[0].movieTitle,"The Avengers")
        XCTAssertEqual(movies[1].movieTitle,"The Avengers")
        XCTAssertEqual(movies[2].movieTitle,"Avengers: Age of Ultron")
    }
}
