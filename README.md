# AC-Resolve
A game resolution mechanic to potentially be used with the AttaCard project.

In part, this is also an excuse to experiment with [Elixir](http://elixir-lang.org/) to see if it's a viable platform for other work down the line.

The specific idea is a simple library module that can resolve actions for roleplaying-style games using a straightforward, flexible mechanism.

## API

The library is packed into the `Resolve` module and has only two methods that need to be exposed, `action/4` and `action/5`.  The others are internal support.

As the internal routines rely on pseudo-random numbers, programs using `Resolve` should execute `:random.seed(:os.timestamp)` beforehand.  Doing so inside of `Resolve` was considered, but abandoned under the assumption that a program might use other random numbers as well, putting seeding into conflict.

The two forms of `action` are very similar, in that they take the same four arguments to begin with, elements of each action:

 - __Aim__:  The degree to which a character (or other actor) is able to approach a desired target.

 - __Force__:  The strength that a character can put behind accomplishing a desired goal.

 - __Evade__:  The opposite of __Aim__, the ability to avoid __Aim__ in a character or resistance to __Aim__ in another target.

 - __Defend__:  The opposite of __Force__, the degree to which a character or other target can tolerate __Force__.

Obviously, the terminology is evocative of physical combat, but `Resolve` is designed to be sufficiently general to be used for any task.

With these parameters, `action/4` returns the magnitude of effect.

However, `action/5` takes a fifth parameter:

 - __Outcomes__:  A _map_ with four elements, `none:`, `minor:`, `half`, and `full`.

Based on the result that would otherwise be returned by `action/4`, `action/5` returns the appropriate element from `outcomes`.

## Example

To see how `Resolve` might be used in action, `game1.ex` uses the resolution mechanism along with the generated card data snagged from my earlier [AttaCard Generator](https://github.com/jcolag/AttaCard-Generator) project to simulate a two-player card game where no skill is involved.

In the game, each player is dealt a hand of cards.  The values of the cards are tallied to create a "character," and those characters attack each other until one's "health" is reduced to zero or the number of turns expires.

The result of calling `Game1.go()` is a list of names representing which player won or if the fight was a draw.  `Game1.go()` can also be called with parameters to replace the card file (though the format is fixed, because this is _just an example_) and change the hand size.

This _might_ serve as a useful basis for anybody who wants to go further.  Or it might serve to illustrate that I'm a terrible Elixir programmer.  But it does work, either way.

