package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.Lib;

class Menu extends FlxSubState
{
	var pressTxt:FlxText;

	var pressed:Bool = false;

	public function new()
	{
		super();

		FlxG.sound.playMusic("assets/music/Menu.wav");

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		add(bg);

		pressTxt = new FlxText("START", 24);
		pressTxt.setFormat(FlxAssets.FONT_DEFAULT, 24, FlxColor.YELLOW, OUTLINE, FlxColor.ORANGE);
		pressTxt.alpha = 0.6;
		pressTxt.x = 50;
		pressTxt.y = FlxG.height - pressTxt.height - 50;
		add(pressTxt);

		var title:FlxText = new FlxText("Chameleon, Flies and Rhythm", 20);
		title.setFormat(FlxAssets.FONT_DEFAULT, 20, FlxColor.WHITE, OUTLINE, FlxColor.BLACK);
		title.x = 50;
		title.y = 50;
		add(title);

		var credits:FlxText = new FlxText("Creator: Infinite Kemonoyagi \nAnimator & Menu music: FishDev \nMusician: EliAnima", 16);
		credits.setFormat(FlxAssets.FONT_DEFAULT, 16, FlxColor.WHITE, OUTLINE, FlxColor.BLACK);
		credits.x = FlxG.width - credits.width - 50;
		credits.y = FlxG.height - credits.height - 50;
		add(credits);

		FlxTween.tween(title, {"scale.x": title.scale.x + 0.2, "scale.y": title.scale.y + 0.2}, 0.6, {
			ease: FlxEase.quadInOut,
			type: PINGPONG
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(pressTxt) && !pressed)
		{
			pressTxt.alpha = 1;
			Lib.current.stage.window.cursor = POINTER;

			if (FlxG.mouse.justPressed)
			{
				pressed = true;

				// FlxTween.tween(groupStuff, {alpha: 0}, 0.5, {
				// 	onComplete: _ ->
				// 	{
				// 		close();
				// 	}
				// });

				for (stuff in this)
				{
					FlxTween.tween(stuff, {alpha: 0}, 0.5, {
						onComplete: _ ->
						{
							close();
							FlxG.resetState();
						}
					});
				}
			}
		}
		else
		{
			pressTxt.alpha = 0.6;
			Lib.current.stage.window.cursor = DEFAULT;
		}
	}
}
