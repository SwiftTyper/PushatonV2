// swiftlint:disable all
import Amplify
import Foundation

public enum GameStatus: String, EnumPersistable {
  case waiting = "WAITING"
  case playing = "PLAYING"
  case finished = "FINISHED"
}