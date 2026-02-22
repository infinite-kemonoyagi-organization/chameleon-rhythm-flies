package;

import chameleon.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.Assets;
import openfl.Lib;

class PlayState extends FlxState
{
	public static var instance:PlayState;

	private var chameleon:Chameleon;
	private var tongue:Tongue;

	private var flies:FlxTypedGroup<Fly>;
	private var areaFlies:FlxTypedGroup<FlxSprite>;

	private var health:Int = 3;
	private var healthTxt:FlxText /* = "3"*/;

	private var score:Int = 0;
	private var scoreTxt:FlxText /* = "Score: 0"*/;
	private var scoreGrp:FlxTypedGroup<FlxText>;

	private static var started:Bool = true;

	// private var areaReference:FlxSprite;
	// private var level:Int = 1;

	override public function create()
	{
		instance = this;

		if (started)
			openSubState(new Menu());
		else
			FlxG.sound.playMusic("assets/music/Camaleon" + Menu.FILE_EXT);

		FlxG.camera.bgColor = 0xFFFFFFFF;

		super.create();

		var bg = new FlxSprite().loadGraphic("assets/images/Bg.png");
		add(bg);

		chameleon = new Chameleon();
		chameleon.setPosition(FlxG.width - chameleon.width - 50, FlxG.height - chameleon.height - 50);
		add(chameleon);

		add(areaFlies = new FlxTypedGroup());
		add(flies = new FlxTypedGroup());

		tongue = new Tongue();
		tongue.setPosition((chameleon.x - chameleon.width) + 138, (chameleon.y - chameleon.height) + 100);
		add(tongue);

		scoreTxt = new FlxText("Score: 0", 32);
		scoreTxt.setFormat(FlxAssets.FONT_DEFAULT, 32, LEFT, OUTLINE_FAST, FlxColor.BLACK);
		add(scoreTxt);

		healthTxt = new FlxText("3", 32);
		healthTxt.setFormat(FlxAssets.FONT_DEFAULT, 32, FlxColor.RED, LEFT, OUTLINE_FAST, FlxColor.BLACK);
		add(healthTxt);

		scoreTxt.x = FlxG.width - scoreTxt.width - 15;
		scoreTxt.y = 15;

		healthTxt.x = FlxG.width - healthTxt.width - 15;
		healthTxt.y = scoreTxt.y + scoreTxt.height + 15;

		// add(scoreGrp = new FlxTypedGroup());

		// var index = -1;
		// areaReference = new FlxSprite().makeGraphic(Std.int(flies.members[0].width), Std.int(flies.members[0].height), FlxColor.RED);
		// areaReference.alpha = 0.6;
	}

	override function closeSubState()
	{
		super.closeSubState();

		FlxG.sound.playMusic("assets/music/Camaleon" + Menu.FILE_EXT);
		started = false;
	}

	var timer:Float = 0;

	var waitTime:Float = 5.2;
	var waitRandom:Float = 1;

	// var flyIndex:Int = 0;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		scoreTxt.text = "Score: " + score;
		healthTxt.text = "" + health;

		scoreTxt.x = FlxG.width - scoreTxt.width - 15;
		scoreTxt.y = 15;

		healthTxt.x = FlxG.width - healthTxt.width - 15;
		healthTxt.y = scoreTxt.y + scoreTxt.height + 15;

		if (!started)
		{
			if (timer == 0 && waitTime < 3)
				waitRandom = FlxG.random.float(1, 2);

			timer += elapsed;

			if (timer >= waitTime / waitRandom)
			{
				var fly = new Fly(FlxG.random.float(1, 2.5), this);
				fly.canInteract = fly.active = true;
				// fly.ID;

				// var area = new FlxSprite().makeGraphic(Std.int(fly.width), Std.int(fly.height), 0x8CFF0000);
				var area = new FlxSprite().loadGraphic("assets/images/CURSOR.png");
				area.setGraphicSize(Std.int(fly.width * 1.2));
				// area.setPosition((fly.destiny.x + ((fly.width - area.width) / 2)), (fly.destiny.x + ((fly.height - area.height) / 2)));
				area.setPosition(fly.destiny.x, fly.destiny.y);
				area.offset.x -= 6;
				area.offset.y -= 6;

				fly.area = area;

				areaFlies.add(area);
				flies.add(fly);

				timer = 0;
				if (waitTime >= 0.65)
					waitTime -= 0.1;
			}

			var isCursor:Bool = false;

			for (fly in flies)
			{
				// timer += elapsed * 100;
				// fly.updateBeat(timer);

				if (fly.canInteract && fly.active)
				{
					// fly.area.setPosition(fly.destiny.x, fly.destiny.y);
					// fly.area.visible = true;
					fly.area.alpha += (0.75 - fly.area.alpha) * (elapsed * 6);

					if (FlxG.mouse.overlaps(fly.area))
					{
						isCursor = true;
						// Lib.current.stage.window.cursor = POINTER;
						if (FlxG.mouse.justPressed
							&& fly.x >= (fly.destiny.x - (30 * fly.speed))
							&& fly.y >= (fly.destiny.y - (30 * fly.speed)))
						{
							fly.onFlyHitted();
							chameleon.animation.play("attack", true);
							chameleon.centerOffsets();
							chameleon.offset.x -= 1;
							chameleon.offset.y += 2;

							FlxG.sound.play("assets/sounds/attack" + Menu.FILE_EXT);

							//
							var rating:FlxText = new FlxText("+100");
							rating.setFormat(FlxAssets.FONT_DEFAULT, 32, FlxColor.BLACK, LEFT, OUTLINE_FAST, FlxColor.WHITE);
							rating.y = FlxG.mouse.y - (rating.height / 2);
							rating.x = FlxG.mouse.x - (rating.width / 2);
							add(rating);

							FlxTween.tween(rating, {y: rating.y - 50}, 1, {
								onComplete: (_) ->
								{
									rating.kill();
									remove(rating);
								}
							});

							score += 100;
							if (score > FlxG.save.data.highscore)
								FlxG.save.data.highscore = score;
						}
					}
				}
			}

			for (area in areaFlies)
			{
				area.angle += elapsed * 15;
			}

			if (isCursor)
				Lib.current.stage.window.cursor = POINTER;
			else
				Lib.current.stage.window.cursor = DEFAULT;
		}

		if (chameleon.animation.finished && chameleon.animation.name == "attack")
		{
			chameleon.animation.play("idle");
			chameleon.centerOffsets();
		}

		if (chameleon.animation.name == "attack" && chameleon.animation.frameIndex == 1)
		{
			tongue.visible = true;
			tongue.animation.play("idle", true);
		}

		if (tongue.animation.finished)
			tongue.visible = false;

		if (FlxG.keys.justPressed.R)
			openSubState(new Retry(score));
	}

	public function whenFlyKilled(fly:Fly):Void
	{
		flies.remove(fly);

		areaFlies.remove(fly.area);

		// var rating:FlxText = new FlxText("100");
	}

	public function onFlyFailed(fly:Fly):Void
	{
		var rating:FlxText = new FlxText("-1");
		rating.setFormat(FlxAssets.FONT_DEFAULT, 32, FlxColor.RED, LEFT, OUTLINE_FAST, FlxColor.BLACK);
		rating.y = FlxG.mouse.y - (rating.height / 2);
		rating.x = FlxG.mouse.x - (rating.width / 2);
		add(rating);

		FlxTween.tween(rating, {y: rating.y - 50}, 1, {
			onComplete: (_) ->
			{
				rating.kill();
				remove(rating);
			}
		});

		health--;

		areaFlies.remove(fly.area);
		// flies.remove(fly);

		if (health < 1)
			openSubState(new Retry(score));
	}
}
