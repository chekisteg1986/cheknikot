package cheknikot.messanger;

class MessageBuffer
{
	public var face:String;
	public var message:Array<String>;
	public var answers_texts:Array<Array<String>>;
	public var answers_results:Array<Void->Void>;

	public function new() {}
}
