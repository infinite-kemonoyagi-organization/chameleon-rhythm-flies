package;

import flixel.math.FlxMath;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import openfl.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.Lib;

using StringTools;

class Menu extends FlxSubState
{
	var pressTxt:FlxText;
	var changelogTxt:FlxText;
	var exitChangelog:FlxText;

	var changelogBG:FlxSprite;
	var changelogContent:FlxText;
	var changelogGrp:FlxSpriteGroup;

	var viewingChangelog:Bool = false;

	var pressed:Bool = false;

	public function new()
	{
		super();

		if (FlxG.save.data.highscore == null)
			FlxG.save.data.highscore = 0;

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

		changelogTxt = new FlxText("CHANGELOG", 24);
		changelogTxt.setFormat(FlxAssets.FONT_DEFAULT, 24, FlxColor.YELLOW, OUTLINE, FlxColor.ORANGE);
		changelogTxt.alpha = 0.6;
		changelogTxt.x = FlxG.width - changelogTxt.width - 25;
		changelogTxt.y = 50;
		add(changelogTxt);

		var title:FlxText = new FlxText("Chameleon, Flies and Rhythm", 20);
		title.setFormat(FlxAssets.FONT_DEFAULT, 20, FlxColor.WHITE, OUTLINE, FlxColor.BLACK);
		title.x = 50;
		title.y = 50;
		add(title);

		var highscore:FlxText = new FlxText('Highscore: ${FlxG.save.data.highscore}pts', 20);
		highscore.setFormat(FlxAssets.FONT_DEFAULT, 20, FlxColor.WHITE, OUTLINE, FlxColor.BLACK);
		highscore.x = 50;
		highscore.y = title.height + title.y;
		add(highscore);

		var credits:FlxText = new FlxText("Creator: Infinite Kemonoyagi \nAnimator & Menu music: FishDev \nMusician: EliAnima", 16);
		credits.setFormat(FlxAssets.FONT_DEFAULT, 16, FlxColor.WHITE, OUTLINE, FlxColor.BLACK);
		credits.x = FlxG.width - credits.width - 50;
		credits.y = FlxG.height - credits.height - 50;
		add(credits);

		var version:FlxText = new FlxText("1.0.1 || Bugfix update", 16);
		version.setFormat(FlxAssets.FONT_DEFAULT, 16, FlxColor.WHITE, OUTLINE, FlxColor.BLACK);
		version.x = FlxG.width - version.width - 50;
		version.y = credits.height + credits.y;
		add(version);

		FlxTween.tween(title, {"scale.x": title.scale.x + 0.2, "scale.y": title.scale.y + 0.2}, 0.6, {
			ease: FlxEase.quadInOut,
			type: PINGPONG
		});

		FlxTween.tween(highscore, {"scale.x": highscore.scale.x + 0.2, "scale.y": highscore.scale.y + 0.2}, 0.6, {
			ease: FlxEase.quadInOut,
			type: PINGPONG
		});

		changelogGrp = new FlxSpriteGroup();
		add(changelogGrp);

		changelogBG = new FlxSprite().makeGraphic(350, 400, FlxColor.BLACK);
		changelogBG.screenCenter();
		changelogGrp.add(changelogBG);

		final content:String = Assets.getText("assets/data/changelog.txt");

		changelogContent = new FlxText(0, 0, changelogBG.width - 10, content);
		changelogContent.setFormat(FlxAssets.FONT_DEFAULT, 16, FlxColor.WHITE, OUTLINE, FlxColor.BLACK);
		changelogContent.x = changelogBG.x + ((changelogBG.width - changelogContent.width) / 2);
		changelogContent.y = changelogBG.y + 5;
		changelogGrp.add(changelogContent);

		exitChangelog = new FlxText("EXIT", 24);
		exitChangelog.setFormat(FlxAssets.FONT_DEFAULT, 24, FlxColor.RED, OUTLINE, 0xFF541118);
		exitChangelog.alpha = 0.6;
		exitChangelog.x = changelogBG.x + ((changelogBG.width - exitChangelog.width) / 2);
		exitChangelog.y = changelogBG.y + changelogBG.height - exitChangelog.height - 5;
		changelogGrp.add(exitChangelog);

		changelogGrp.y = FlxG.height; // ADD THIS LINES WHEN ALL THE STUFF ARE ADDED TO THE GROUP
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (viewingChangelog)
		{
			changelogGrp.y = FlxMath.lerp(changelogGrp.y, 0, elapsed * 6);
			changelogGrp.alpha = FlxMath.lerp(changelogGrp.alpha, 1, elapsed * 6);
		}
		else
		{
			changelogGrp.y = FlxMath.lerp(changelogGrp.y, FlxG.height, elapsed * 6);
			changelogGrp.alpha = FlxMath.lerp(changelogGrp.alpha, 0, elapsed * 6);
		}

		if (Math.abs(FlxG.mouse.wheel) > 0 && viewingChangelog)
		{
			changelogContent.y += FlxG.mouse.wheel * 20;
			if (FlxG.mouse.wheel > 0 && changelogContent.y >= changelogBG.y + 5)
				changelogContent.y = changelogBG.y + 5;
		}

		final changelogRect:FlxRect = new FlxRect(0, changelogBG.y + 5 - changelogContent.y, changelogBG.width + 10, changelogBG.height - 50);

		changelogContent.clipRect = changelogRect;

		function goToPlay():Void
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

		if (FlxG.mouse.overlaps(changelogTxt) && !pressed && !viewingChangelog)
		{
			changelogTxt.alpha = 1;
			Lib.current.stage.window.cursor = POINTER;

			if (FlxG.mouse.justPressed)
			{
				pressed = true;
				viewingChangelog = true;
			}
		}
		else
		{
			changelogTxt.alpha = 0.6;
			Lib.current.stage.window.cursor = DEFAULT;
		}

		if (FlxG.mouse.overlaps(exitChangelog) && viewingChangelog)
		{
			exitChangelog.alpha = 1;
			Lib.current.stage.window.cursor = POINTER;

			if (FlxG.mouse.justPressed)
			{
				pressed = false;
				viewingChangelog = false;
			}
		}
		else
		{
			exitChangelog.alpha = 0.6;
			Lib.current.stage.window.cursor = DEFAULT;
		}

		if (FlxG.mouse.overlaps(pressTxt) && !pressed)
		{
			pressTxt.alpha = 1;
			Lib.current.stage.window.cursor = POINTER;

			if (FlxG.mouse.justPressed)
				goToPlay();
		}
		else
		{
			pressTxt.alpha = 0.6;
			Lib.current.stage.window.cursor = DEFAULT;
		}

		if (FlxG.keys.justPressed.ENTER && !pressed)
			goToPlay();
	}
}
