package cheknikot.messanger;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author ...
 */
class GameMessage extends FlxTypedGroup<FlxSprite>
{
	public static var messanger:GameMessage;

	private var fon:FlxSprite;
	private var text_tf:MyFlxText;

	public var background:FlxSprite;

	public var face:FlxSprite;
	public var face_back:FlxSprite;

	public static var signal:FlxSignal = new FlxSignal();

	private var answers:Array<AnswerBtn> = new Array();

	private var additional_image:FlxSprite;
	private var additional_image_back:FlxSprite;

	public static var FONT_SIZE:Int = 20;

	public function new()
	{
		super();
		fon = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);

		text_tf = new MyFlxText(5, 5, FlxG.width / 2, ['wow'], FONT_SIZE);

		background = new FlxSprite();

		background.makeGraphic(1, 1, FlxColor.BLACK);

		face = new FlxSprite(0, 0);

		// face.loadGraphic(AssetPaths.orc_faces__png, true, 40, 40);
		// HeroIcon.add_animation(face);

		face_back = new FlxSprite();
		face_back.visible = false;

		additional_image = new FlxSprite();
		additional_image_back = new FlxSprite();

		additional_image.visible = false;
		additional_image_back.visible = false;

		visible = false;

		forEach(function(spr:FlxSprite)
		{
			spr.scrollFactor.set(0, 0);
		});

		if (ok_res == null)
		{
			ok_res = [ok_answer];
		}

		messanger = this;
	}

	public static function ok_answer():Void
	{
		trace('OK ANSWER');
		if (buffer.length > 0)
		{
			trace('buffer', buffer[0]);
			var _b:MessageBuffer = buffer[0];
			messanger.set_text(_b.message, _b.answers_texts, _b.answers_results, _b.face);
			buffer.splice(0, 1);
		}
	}

	private var position:String = 'center';

	public function set_position(pos:String):Void
	{
		position = pos;
	}

	public var dy_from_center:Int = 0;
	public var ok_text:Array<String> = ['OK', 'OK', 'OK'];
	public var ok_res:Array<Void->Void>;

	private function add_objects():Void
	{
		add(fon);
		add(background);
		add(face_back);
		add(face);
		add(text_tf);
		add(additional_image_back);
		add(additional_image);
	}

	public function set_text(t:Array<String>, buttons_texts:Array<Array<String>>, buttons_results:Array<Void->Void>, _face:String = null,
			_addit_image:FlxSprite = null):Void
	{
		if (this.visible)
		{
			trace('Adding message to buffer');
			var _message:MessageBuffer = new MessageBuffer();
			_message.face = _face;
			_message.answers_texts = buttons_texts;
			_message.answers_results = buttons_results;
			_message.message = t;
			buffer.push(_message);
			return;
		}

		clear();
		add_objects();

		if (buttons_texts == null)
		{
			buttons_texts = [ok_text];
		}
		if (buttons_results == null)
			buttons_results = ok_res;

		// ========== making answers ==========
		background.y = 0;
		var n:Int = -1;

		var btn_y:Float = 10;
		var len:Int = buttons_texts.length;

		var btn:AnswerBtn = null;
		var last_y:Float = 0;
		trace('buttons:' + buttons_texts, 'len:' + len);

		while (++n < len)
		{
			if (n < buttons_texts.length)
			{
				var btn_text:Array<String> = buttons_texts[n];
				var btn_res:Void->Void = buttons_results[n];
				trace('btn:' + btn_text);

				if (n >= answers.length)
				{
					// trace('CREATING AnswerBtn');
					btn = new AnswerBtn(this);
					answers.push(btn);
				}

				btn = answers[n];

				add(btn);
				btn.alpha = 0;
				btn.visible = true;
				btn.y = btn_y;
				btn_y += btn.height;
				last_y = btn_y;
				btn.func = btn_res;
				btn.new_text(btn_text);
				FlxTween.tween(btn, {alpha: 1}, 0.1, {onComplete: btn.activate});
			}
			else {}
		}

		// ============== setting text, face
		text_tf.new_text(t);
		var w:Int = cast(text_tf.width + 10, Int);
		var h:Int = cast(text_tf.height + 15 + last_y, Int);

		var face_w:Int = 0;
		if (_face != null)
		{
			_face = AF.removeSpaces(_face);
			_face = AF.removeChar8203(_face);
			// trace('Face:', _face, _face.length);
			// trace(_face.charCodeAt(_face.length - 1));
			face.visible = true;
			face_back.visible = true;
			trace(face.animation.getNameList());
			if (face.animation.getByName(_face) != null)
			{
				trace('Have face');
				face.animation.play(_face, true);
			}
			else
			{
				face.visible = false;
			}

			face_w = face.frameWidth;
			if (h <= face.frameHeight)
				h = face.frameHeight + 1;
		}
		else
		{
			trace('Face NULL');
			face_back.visible = face.visible = false;
		}

		background.makeGraphic(w + face_w, h, FlxColor.WHITE);
		background.updateHitbox();
		FlxSpriteUtil.drawRect(background, 1, 1, background.frameWidth - 2, background.frameHeight - 2, FlxColor.BLACK);
		if (position == 'center')
		{
			background.screenCenter();
		}
		else if (position == 'fixed')
		{
			trace('FIXED');
			background.x = 0;
			background.y = 0;
		}
		else
		{
			background.screenCenter(FlxAxes.X);
			background.y = 40;
		}
		// position = 'center';

		face.x = background.x + 1;
		face.y = background.y + 1;
		face_back.x = face.x + 1;
		face_back.y = face.y + 1;

		text_tf.x = background.x + face_w;
		text_tf.y = background.y;

		// updating buttons x,y

		for (b in answers)
		{
			b.x = background.x + 2 + face_w;
			b.y += background.y + text_tf.height;
			trace('final:', b.x, b.y, b.width, b.scale.x);
		}

		/*if (_addit_image != null)
			{
				additional_image.visible = additional_image_back.visible = true;
				additional_image.scale.set(2, 2);
				additional_image_back.scale.set(2, 2);
				
				additional_image.loadGraphicFromSprite(_addit_image);
				additional_image_back.loadGraphic(AssetPaths.item_back__png);
				
				var frame:Int = _addit_image.animation.frameIndex;
				additional_image.animation.remove('1');
				additional_image.animation.add('1', [frame]);
				additional_image.animation.play('1');
				
				additional_image.y = answers[0].y + additional_image.frameHeight;
				additional_image_back.y = additional_image.y ;
				additional_image.x = answers[0].x +answers[0].width + additional_image.frameWidth;
				additional_image_back.x = additional_image.x;
			}
			else
			{
				additional_image.visible = false;
				additional_image_back.visible = false;
		}*/

		FlxG.state.add(this);
		visible = true;

		// signal = new FlxSignal();
		// signal.addOnce(f);

		forEach(function(spr:FlxSprite)
		{
			spr.scrollFactor.set(0, 0);
		});
		trace('message recieved to game messanger');
	}

	public static var buffer:Array<MessageBuffer> = new Array();

	/*public static function add_text(arr:Array<String>, face:String, _function:Void->Void = null):Void
		{
			var _message:MessageBuffer = new MessageBuffer();	
			if (_function == null)
				buffer.push([arr, face, null]);
			else
				buffer.push([arr, face, [_function]]);
	}*/
	public var always_on_top:Bool = false;

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (always_on_top)
		{
			FlxG.state.remove(this, true);
			FlxG.state.add(this);
		}
		// trace('messanger update')
	}
}
