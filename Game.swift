// swiftlint:disable all
import Amplify
import Foundation

public struct Game: Model {
  public let id: String
  public var player1Id: String
  public var player2Id: String?
  public var player1Score: Int
  public var player2Score: Int
  public var status: GameStatus?
  public var lastUpdateTime: Temporal.DateTime?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      player1Id: String,
      player2Id: String? = nil,
      player1Score: Int,
      player2Score: Int,
      status: GameStatus? = nil,
      lastUpdateTime: Temporal.DateTime? = nil) {
    self.init(id: id,
      player1Id: player1Id,
      player2Id: player2Id,
      player1Score: player1Score,
      player2Score: player2Score,
      status: status,
      lastUpdateTime: lastUpdateTime,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      player1Id: String,
      player2Id: String? = nil,
      player1Score: Int,
      player2Score: Int,
      status: GameStatus? = nil,
      lastUpdateTime: Temporal.DateTime? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.player1Id = player1Id
      self.player2Id = player2Id
      self.player1Score = player1Score
      self.player2Score = player2Score
      self.status = status
      self.lastUpdateTime = lastUpdateTime
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}