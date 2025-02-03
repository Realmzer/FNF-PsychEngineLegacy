package states;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		if(!ClientPrefs.data.preciseDiscordRPC)
		{
		DiscordClient.changePresence("In the Menus", null);
		}
		if(ClientPrefs.data.preciseDiscordRPC) 
		{
		DiscordClient.changePresence("Outdated version detected!", null);
		}
		#end

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"It appears that your're running an   \n
			outdated version of Psych Engine Legacy (" + MainMenuState.psychEngineLegacyVersion + "),\n
			please update to " + TitleState.updateVersion + "!\n
			Press ESCAPE to proceed anyway.\n
			\n
			Thank you for using the Engine!",
			32);
		warnText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				CoolUtil.browserLoad("https://github.com/Realmzer/FNF-PsychEngineLegacy/releases");
			}
			else if(controls.BACK) {
				leftState = true;
			}

			if(leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
