# cbemoji

_simple emoji support for ColdBox projects_

## Installation

To install `cbemoji`, you need [CommandBox](https://www.ortussolutions.com/products/commandbox/) :rocket:

Once you have that set-up, just run `box install cbemoji` in your shell and :boom:

You're now ready to use emoji in your CFML projects! Awesome! :rocket:

## Usage : Emoji Service

There is one model library that will be mapped via WireBox as `EmojiService@cbemoji`, which will give you all the methods you might need for emoji goodness :rocket:


```javascript
// Inject the emoji service
property name="emoji" inject="emojiService@cbemoji";

// Use it

emoji.get( 'coffee' ) // returns the emoji code for coffee (displays emoji on terminals that support it)

emoji.which(emoji.get( 'coffee' )) // returns the string "coffee"

emoji.get( ':fast_forward:' ) // `.get` also supports github flavored markdown emoji (http://www.emoji-cheat-sheet.com/)

emoji.emojify( 'I :heart: :coffee:!' ) // replaces all :emoji: with the actual emoji, in this case: returns "I ❤️ ☕️!"

emoji.random() // returns a random emoji + key, e.g. `{ emoji: '❤️', key: 'heart' }`

emoji.search( 'cof' ) // returns an array of objects with matching emoji's. `[{ emoji: '☕️', key: 'coffee' }, { emoji: ⚰', key: 'coffin'}]`

emoji.unemojify( 'I ❤️ 🍕' ) // replaces the actual emoji with :emoji:, in this case: returns "I :heart: :pizza:"

emoji.hasEmoji( '🍕' ) // Validate if this library knows an emoji like `🍕`

emoji.hasEmoji( 'pizza' ) // Validate if this library knowns a emoji with the name `pizza`
```