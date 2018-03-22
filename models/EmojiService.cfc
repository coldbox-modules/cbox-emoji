/**
* Emoji Service
*/
component accessors="true" singleton{

	/**
	 * The emoji map holder
	 */
	property name="emojimap";

	/**
     * regex to parse emoji in a string - finds emoji, e.g. :coffee:
     */
    variables.EMOJI_REGEX = ":([a-zA-Z0-9_\-\+]+):";

    /*
     * Non spacing mark, some emoticons have them. It's the 'Variant Form',
	 * which provides more information so that emoticons can be rendered as
	 * more colorful graphics. FE0E is a unicode text version, where as FE0F
	 * should be rendered as a graphical version. The code gracefully degrades.
	 *
	 * // 65039 - '️' - 0xFE0F;
	 */
    variables.NON_SPACING_MARK = chr( 65039 );

	/**
	* Constructor
	*/
	function init(){
		variables.emojimap = deserializeJSON( 
			fileRead( "emoji.json" )
		);
		return this;
	}

	/**
	 * Pass in the emoji unicode and get the name, else empty string if not found.
	 * @code The emoji unicode
	 * @includeColons Wrap the word in colons or just by key
	 */
	function which( required code, boolean includeColons=false ){
		var results = variables.emojiMap
			.filter( function( key, value ){
				return ( value == stripNSB( code ) );
			} )
			.reduce( function( previous, key, value ){
				return ( includeColons ? ensureColons( key ) : key );
			} );

		return ( results ?: "" );
	}

	/**
	* Returns an emoji code and displays on terminals that support it
	* The emoji can be a direct key or a github flavored markup emoji: http://www.emoji-cheat-sheet.com/)
	* 
	* @emoji The emoji key
	*/
	function get( required emoji ){
		arguments.emoji = stripColons( arguments.emoji );
		return getByKey( arguments.emoji );
	}

	/**
	 * Get an emoji by clean key, if not found, it just returns the key back
	 * This does not use the github flavored markup emoji key.
	 * 
	 * @emoji The emoji key 
	 */
	function getByKey( required emoji ){
		if( variables.emojiMap.keyExists( arguments.emoji ) ){
			return variables.emojiMap[  arguments.emoji ];
		}
		return ensureColons( arguments.emoji );
	}

	/**
	 * Check if an emoji exists in this library either by key name or :name: pattern
	 * @nameOrCode The key name or the :code: name
	 */
	function hasEmoji( required nameOrCode ){
		return hasEmojiByName( arguments.nameOrCode) || hasEmojiByCode( arguments.nameOrCode );
	}

	/**
	 * Check if you have an emoji by key or :key:
	 * @name The name
	 */
	function hasEmojiByName( required name ){
		arguments.name = stripColons( arguments.name );
		return variables.emojiMap.keyExists( arguments.name );
	}

	/**
	 * Check if you have an emoji by code
	 * @code The code
	 */
	function hasEmojiByCode( required code ){
		var results = variables.emojiMap
			.filter( function( key, value ){
				return ( value == stripNSB( code ) );
			} );
		return ( ! results.isEmpty() );
	}

	/**
	 * Takes in a string and replaces :emojikey: inside of it with the right emojis
	 * @target The string to emojify
	 * @onMissing Closure called if the emoji requested does not exist, return what you want to display.
	 */
	function emojify( required target, onMissing ){
		var results = arguments.target;

		reMatch( variables.EMOJI_REGEX, arguments.target )
			.each( function( item ){
				// Do we have an emoji, if not, do we have an on Missing closure?
				if( !hasEmoji( item ) 
					&&
					!isNull( arguments.onMissing ) 
					&&  
					isClosure( arguments.onMissing ) 
				){
					var emoji = arguments.onMissing( item );
				} else {
					// We have it!
					var emoji = get( item );
				}
				results = replaceNoCase( results, item,  emoji & " ", "all" );
			} );

		return results;
	}

	/**
	 * Unemojify a string
	 * @target The string to unemojify
	 */
	function unemojify( required target ){
		return arguments.target
			.listToArray( " " )
			.map( function( word ){
				var key = which( word, true );
				return ( key.len() ? key : word );
			} )
			.toList( " " );
	}

	/**
	 * Get a random emoji
	 *
	 * @return A struct with { key, emoji }
	 */
	struct function random(){
		var aKeys 		= variables.emojiMap.keyArray();
		var randomKey 	= akeys[ randRange( 1, aKeys.len() ) ];

		return { "key" : randomKey, "emoji" : getByKey( randomKey ) };
	}

	/**
	 * Return a struct of potential emoji matches
	 * @target The search string to search
	 */
	struct function search( required target ){
		return variables.emojiMap.filter( function( key, value ){
			return ( findNoCase( target, key ) ? true : false );
		} )
	}

	/******************************** PRIVATE ************************************/

	/**
	 * Remove the non-spacing-mark from the code, never send a stripped version to the client, as it kills graphical emoticons.
	 * @code The code to inspect
	 */
	private function stripNSB( required code ){
		return reReplace( arguments.code, variables.NON_SPACING_MARK, "" );
	}

	/**
	 * Ensure :string: colon patterns are returned
	 * @target the incoming target to wrap in ::
	 */
	private function ensureColons( required target ){
		return ":" & arguments.target & ":";
	}

	/**
	 * Strip :emoji: colons from the text
	 * @target The target string
	 */
	private function stripColons( required target ){
		if( ! find( ":", arguments.target ) ){
			return arguments.target;
		}
		arguments.target = reReplace( arguments.target, "^\:", "" );
		return reReplace( arguments.target, "\:$", "" );
	}

}