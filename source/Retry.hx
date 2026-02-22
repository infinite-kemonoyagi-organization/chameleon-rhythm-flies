package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.Lib;

class Retry extends FlxSubState
{
	var pressTxt:FlxText;
	var menuTxt:FlxText;
	var highscore:FlxText;

	public function new(score:Int)
	{
		super();

		FlxG.sound.music.stop();
		FlxG.sound.playMusic("assets/music/Menu.wav");

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		add(bg);

		pressTxt = new FlxText("Retry?", 32);
		pressTxt.setFormat(FlxAssets.FONT_DEFAULT, 32, FlxColor.YELLOW, OUTLINE, FlxColor.ORANGE);
		pressTxt.alpha = 0.6;
		// pressTxt.x = 50;
		pressTxt.screenCenter(X);
		pressTxt.y = FlxG.height - pressTxt.height - 50;
		add(pressTxt);

		menuTxt = new FlxText("Go to Menu?", 32);
		menuTxt.setFormat(FlxAssets.FONT_DEFAULT, 32, FlxColor.YELLOW, OUTLINE, FlxColor.ORANGE);
		menuTxt.alpha = 0.6;
		// pressTxt.x = 50;
		menuTxt.screenCenter(X);
		menuTxt.y = pressTxt.y + pressTxt.height;
		add(menuTxt);

		var title:FlxText = new FlxText("Best Score: " + score, 20);
		title.setFormat(FlxAssets.FONT_DEFAULT, 20, FlxColor.YELLOW, OUTLINE, FlxColor.ORANGE);
		title.screenCenter(X);
		title.y = 50;
		add(title);

		highscore = new FlxText('Highscore: ${FlxG.save.data.highscore}pts (press R to reset highscore)', 20);
		highscore.setFormat(FlxAssets.FONT_DEFAULT, 20, FlxColor.WHITE, OUTLINE, FlxColor.BLACK);
		highscore.x = 50;
		highscore.y = title.height + title.y;
		add(highscore);

		FlxTween.tween(title, {"scale.x": title.scale.x + 0.2, "scale.y": title.scale.y + 0.2}, 0.6, {
			ease: FlxEase.quadInOut,
			type: PINGPONG
		});

		FlxTween.tween(highscore, {"scale.x": highscore.scale.x + 0.2, "scale.y": highscore.scale.y + 0.2}, 0.6, {
			ease: FlxEase.quadInOut,
			type: PINGPONG
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(pressTxt))
		{
			pressTxt.alpha = 1;
			Lib.current.stage.window.cursor = POINTER;

			if (FlxG.mouse.justPressed)
			{
				FlxG.resetState();

				FlxG.sound.music.stop();
				FlxG.sound.playMusic("assets/music/Camaleon.mp3");
			}
		}
		else
		{
			pressTxt.alpha = 0.6;
			Lib.current.stage.window.cursor = DEFAULT;
		}

		if (FlxG.mouse.overlaps(menuTxt))
		{
			menuTxt.alpha = 1;
			Lib.current.stage.window.cursor = POINTER;

			if (FlxG.mouse.justPressed)
			{
				PlayState.instance.openSubState(new Menu());
			}
		}
		else
		{
			menuTxt.alpha = 0.6;
			Lib.current.stage.window.cursor = DEFAULT;
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.resetState();
		}

		if (FlxG.keys.justPressed.R)
		{
			FlxG.save.data.highscore = 0;
			highscore.text = 'Highscore: ${FlxG.save.data.highscore}pts (press R to reset highscore)';
		}
	}
}
