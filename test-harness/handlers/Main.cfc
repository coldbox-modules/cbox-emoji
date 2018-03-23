component{

	property name="emojiService" inject="emojiService@cbemoji";

	function index( event, rc, prc ){
		return emojiService.emojify( "I :heart: emojis :rocket: :smiley:" );
	}

}