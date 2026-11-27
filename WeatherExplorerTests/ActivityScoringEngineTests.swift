//
//  ActivityScoringEngineTests.swift
//  WeatherExplorerTests
//
//  Created by Saurabh Goyal on 27/11/26.
//

import XCTest
@testable import WeatherExplorer

final class ActivityScoringEngineTests: XCTestCase {

    private let engine = ActivityScoringEngine()

    /// Ek din banane ka shortcut. Defaults = mild, dry, calm, barf-rahit din.
    private func makeDay(tempMax: Double = 22, tempMin: Double = 12,
                         condition: WeatherCondition = .clear,
                         rainProb: Double = 0, rainSum: Double = 0,
                         snow: Double = 0, wind: Double = 10,
                         snowDepth: Double? = nil) -> DailyForecast {
        DailyForecast(date: Date(), tempMax: tempMax, tempMin: tempMin, condition: condition,
                      precipitationProbability: rainProb, precipitationSum: rainSum,
                      snowfallSum: snow, windSpeedMax: wind, snowDepthMax: snowDepth)
    }

    /// Perfect ski din: thanda, 80cm base, taaza snow, shaant hawa.
    private var perfectSkiDay: DailyForecast {
        makeDay(tempMax: -3, tempMin: -10, snow: 10, wind: 10, snowDepth: 0.8)
    }

    // MARK: Skiing

    func test_skiing_isZero_whenWarm_evenWithSnowOnGround() {
        let day = makeDay(tempMax: 17, tempMin: 5, snowDepth: 1.0)
        XCTAssertEqual(engine.dayScore(.skiing, day: day, elevation: 2000), 0)
    }

    func test_skiing_isZero_whenColdButNoSnow() {
        let day = makeDay(tempMax: -5, tempMin: -10, snow: 0, snowDepth: 0)
        XCTAssertEqual(engine.dayScore(.skiing, day: day, elevation: 2000), 0)
    }

    func test_skiing_isExcellent_whenColdSnowyAndCalm() {
        let score = engine.dayScore(.skiing, day: perfectSkiDay, elevation: 2000)!
        XCTAssertGreaterThanOrEqual(score, 9)
    }

    func test_skiing_usesSnowfallFallback_whenDepthMissing() {
        let withSnowfall = makeDay(tempMax: -3, tempMin: -10, snow: 15, wind: 10, snowDepth: nil)
        let noSnowfall = makeDay(tempMax: -3, tempMin: -10, snow: 0, wind: 10, snowDepth: nil)
        XCTAssertGreaterThanOrEqual(engine.dayScore(.skiing, day: withSnowfall, elevation: nil)!, 9)
        XCTAssertEqual(engine.dayScore(.skiing, day: noSnowfall, elevation: nil), 0)
    }

    // MARK: Outdoor / Indoor

    func test_outdoor_isHigh_onMildDryDay() {
        let score = engine.dayScore(.outdoorSightseeing, day: makeDay(rainProb: 5), elevation: nil)!
        XCTAssertGreaterThanOrEqual(score, 8)
    }

    func test_thunderstorm_crushesOutdoor_andBoostsIndoor() {
        let storm = makeDay(condition: .thunderstorm, rainProb: 90, rainSum: 20, wind: 50)
        let outdoor = engine.dayScore(.outdoorSightseeing, day: storm, elevation: nil)!
        let indoor = engine.dayScore(.indoorSightseeing, day: storm, elevation: nil)!
        XCTAssertLessThan(outdoor, 2)
        XCTAssertGreaterThan(indoor, 9)
    }

    // MARK: Surfing (estimate)

    func test_surfing_isNil_whenInlandOrElevationUnknown() {
        XCTAssertNil(engine.dayScore(.surfing, day: makeDay(wind: 25), elevation: 500))
        XCTAssertNil(engine.dayScore(.surfing, day: makeDay(wind: 25), elevation: nil))
    }

    func test_surfing_isCappedAtSeven_onIdealCoastalDay() {
        let day = makeDay(tempMax: 28, wind: 22)
        let score = engine.dayScore(.surfing, day: day, elevation: 5)!
        XCTAssertEqual(score, 7, accuracy: 0.01)
    }

    func test_surfing_isZero_whenFlat() {
        XCTAssertEqual(engine.dayScore(.surfing, day: makeDay(tempMax: 28, wind: 2), elevation: 5), 0)
    }

    // MARK: Ranking & aggregation

    func test_ranking_putsNotApplicableLast_andSortsDescending() {
        let forecast = (0..<7).map { _ in makeDay() }
        let ranked = engine.rankedScores(forecast: forecast, elevation: 500)   // inland

        XCTAssertEqual(ranked.last?.activity, .surfing)
        XCTAssertNil(ranked.last?.score)
        let scores = ranked.compactMap(\.score)
        XCTAssertEqual(scores, scores.sorted(by: >))
    }

    func test_sevenDayScore_isAverageOfDays() {
        // 3 garam din (0) + 4 perfect ski din (10) -> average ~5.7
        let warm = makeDay(tempMax: 17, tempMin: 5, snowDepth: 1.0)
        let forecast = [warm, warm, warm] + Array(repeating: perfectSkiDay, count: 4)
        let ski = engine.rankedScores(forecast: forecast, elevation: 2000)
            .first { $0.activity == .skiing }!
        XCTAssertEqual(ski.score!, 5.7, accuracy: 0.2)
    }

    // MARK: Score text

    func test_scoreText_hidesDecimalForWholeNumbers() {
        func text(_ s: Double?) -> String {
            ActivityScore(activity: .skiing, score: s, summary: "").scoreText
        }
        XCTAssertEqual(text(9.0), "9 / 10")
        XCTAssertEqual(text(0), "0 / 10")
        XCTAssertEqual(text(9.2), "9.2 / 10")
        XCTAssertEqual(text(8.96), "9 / 10")     // round hokar whole ban gaya
        XCTAssertEqual(text(nil), "N/A")
    }
}
