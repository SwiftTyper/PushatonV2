// swiftlint:disable all
import Amplify
import Foundation

public struct Player: Model {
  public let username: String
  public var currentGameId: String?
  public var position: Position?
  public var highScore: Int
  public var score: Int
  public var isAlive: Bool
  public var isOnline: Bool
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(username: String,
      currentGameId: String? = nil,
      position: Position? = nil,
      highScore: Int,
      score: Int,
      isAlive: Bool,
      isOnline: Bool) {
    self.init(username: username,
      currentGameId: currentGameId,
      position: position,
      highScore: highScore,
      score: score,
      isAlive: isAlive,
      isOnline: isOnline,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(username: String,
      currentGameId: String? = nil,
      position: Position? = nil,
      highScore: Int,
      score: Int,
      isAlive: Bool,
      isOnline: Bool,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.username = username
      self.currentGameId = currentGameId
      self.position = position
      self.highScore = highScore
      self.score = score
      self.isAlive = isAlive
      self.isOnline = isOnline
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}