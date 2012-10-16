shuffleArray = (arr) ->
    i = arr.length
    if i is 0 then return false
    while --i
        j = Math.floor(Math.random() * (i+1))
        [arr[i], arr[j]] = [arr[j], arr[i]] # use pattern matching to swap

class RockPaperScissors

  ## constants

  @DefaultWeaponSet: module.require('./weapon-sets/traditional-set')

  ## methods

  constructor: (@weapons = @DefaultWeaponSet, @shuffle = true) ->
    @players = []

  getWeapons: ->
    Object.keys @weapons

  addPlayer: (playerName, weapon) ->
    @players.push
      name: playerName
      weapon: weapon
      alive: true
    @

  clearPlayers: ->
    @players = []
    @

  playRound: ->
    # shuffle the array here
    if @players.length >= 2
      shuffleArray @players if @shuffle
      
      [ player1, player2 ] = [ @players.shift(), @players.shift() ]

      player1.alive = false if Object.keys( @weapons[player2.weapon] ).indexOf( player1.weapon ) > -1
      player2.alive = false if Object.keys( @weapons[player1.weapon] ).indexOf( player2.weapon ) > -1

      @players.push(player1) unless not player1.alive
      @players.push(player2) unless not player2.alive
      
      [ player1, player2 ]
    else
      @players

  playRoundForText: ->
    result = @playRound()
    
    if result.length is 0
      "All players have killed each other - nobody wins"
    else if result.length is 1
      "#{result[0].name} has won the game with their #{result[0].weapon}"
    else
      [ player1, player2 ] = [ result[0], result[1] ]
      
      player1Full = player1.name + "'s " + player1.weapon
      player2Full = player2.name + "'s " + player2.weapon
      
      if player1.alive and player2.alive
        "#{player1Full} drew against #{player2Full}"
      else if player1.alive and not player2.alive
        "#{player1Full} #{@weapons[player1.weapon][player2.weapon]} #{player2Full}"
      else if player2.alive and not player1.alive
        "#{player2Full} #{@weapons[player2.weapon][player1.weapon]} #{player1Full}"
      else # both players are dead
        "#{player1Full} and #{player2Full} killed each other"

  isGameOver: ->
    result.length <= 1 or ( result.length is 2 and result[0].alive and result[1].alive )

module.exports = RockPaperScissors
