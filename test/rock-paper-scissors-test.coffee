vows = require 'vows'
assert = require 'assert'

RockPaperScissors = require '../lib/rock-paper-scissors'

getGameInstance = (shufflePlayers) ->
      weaponSet = require '../lib/weapon-sets/traditional-set'
      new RockPaperScissors weaponSet, shufflePlayers

vows
   .describe('RockPaperScissorsTest')
   .addBatch(
      
      'An instance of RockPaperScissors in "no shuffle" mode':
         topic: getGameInstance(false)

         'containing no players to fight':
            topic: (game) ->
               game
                  .clearPlayers()

            'playRound() returns an empty array': (game) ->
               assert.deepEqual game.playRound(), []

            'and outputs an appropriate "everyone died" message': (game) ->
               assert.equal game.playRoundForText(), 'All players have killed each other - nobody wins'

            'and a player is added':
               topic: (game) ->
                  game.addPlayer('Paul Phoenix', 'Paper')

               'playRound() returns an array containing one player': (game) ->
                  assert.deepEqual game.playRound(), [
                     name: 'Paul Phoenix'
                     weapon: 'Paper'
                     alive: true
                  ]

               'and another two players are added':
                  topic: (game) ->
                     game
                        .addPlayer('Prototype Jack', 'Scissors')
                        .addPlayer('Nina Williams', 'Rock')

                  'playRound() returns two players upon being called to fight': (game) ->
                     assert.deepEqual game.playRound(), [
                        name: 'Paul Phoenix'
                        weapon: 'Paper'
                        alive: false
                     ,
                        name: 'Prototype Jack'
                        weapon: 'Scissors'
                        alive: true
                     ]

                  'and post-fight':
                     'playRoundForText() describes the final fight if called to fight again': (game) ->
                        assert.equal game.playRoundForText(), "Nina Williams's Rock crushed Prototype Jack's Scissors"

                     'and finally':
                        'there is only one true victor': (game) ->
                           assert.equal game.playRoundForText(), "Nina Williams has won the game with their Rock"
   
   ).export(module)
