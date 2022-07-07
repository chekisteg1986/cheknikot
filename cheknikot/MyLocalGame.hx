package cheknikot;

class MyLocalGame extends MenuBase
{
	public static var state:MyLocalGame;

	override public function new()
	{
		super();
		state = this;
	}

	override function show()
	{
		super.show();
	}
}
