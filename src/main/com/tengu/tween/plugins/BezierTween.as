package com.tengu.tween.plugins
{
    import com.tengu.tween.Tween;

    /**
	 * Последний элемент в массиве контрольных точек будет считаться конечным значением, то есть в массиве должно быть не менее 2 точек 
	 * 
	 * 		  Tweeny
	 *				.create(drop, BezierTween.create)
	 *				.during(80)
	 *				.to(
	 *					{x: [460, 100, 360],
	 *					 y: [125, 285, 450]})
	 *
	 * @author tengu
	 * 
	 */	
    public class BezierTween extends Tween
    {
        private static const tweens:Vector.<BezierTween> = new <BezierTween>[];
		
		private var propPaths:Object = null;
		
		private var initValues:Object = null;
		private var endValues:Object = null;
		private var deltaValues:Object = null;

        public static function create ():BezierTween
        {
            if (tweens.length == 0)
            {
                return new BezierTween();
            }
            else
            {
                return tweens.pop();
            }
        }

        public function BezierTween ()
        {
            super();
        }
		
		private function createPath(propertyName:String, param:Array, isReverse:Boolean):void
		{
			var initValue:Number = 0;
			var endValue:Number  = 0;
			var path:Vector.<Number> = null;
			var count:uint = (param == null) ? 0 : param.length;
			if (!tweenTarget.hasOwnProperty(propertyName) || count < 2)
			{
				return;
			}
			
			if (isReverse)
			{
				param = param.reverse();
				initValue = parseFloat(param.shift());
				endValue  = tweenTarget[propertyName];
				tweenTarget[propertyName] = initValue;
			}
			else
			{
				initValue = tweenTarget[propertyName];
				endValue = parseFloat(param.pop());
			}
			
			initValues[propertyName]  = initValue;
			endValues[propertyName]   = endValue;
			deltaValues[propertyName] = endValue - initValue;
			
			count--;
			path = new Vector.<Number>(count, true); 		
			for (var i:int = 0; i < count; i++) 
			{
				path[i] = parseFloat(param[i]);
			}
			
			propPaths[propertyName] = path;
		}		
		
		protected override function initialize():void
		{
			super.initialize();
			propPaths  = {};
			initValues = {};
			endValues  = {};
			deltaValues = {};
		}
		
		protected override function parse(params:Object, isReverse:Boolean=false):void
		{
			var propName:String = null;
			for (propName in params)
			{
				createPath(propName, params[propName], isReverse);
			}
		}
		
		protected override function process():Boolean
		{
			var propertyName:String;
			var initValue:Number;
			var endValue:Number;
			var deltaValue:Number;
			var index:int;
			var insideIndex:Number;
			var count:uint;
			var p1:Number;
			var p2:Number;
			var path:Vector.<Number>;
			
			currentTick++;
			ratio = easeMethod(currentTick / duration);
			
			if (currentTick == duration)
			{
				for (propertyName in endValues)
				{
					target[propertyName] = endValues[propertyName];
				}
				return true;
			}
			
			for (propertyName in propPaths)
			{
				path = propPaths[propertyName];
				count = path.length;
				initValue = initValues[propertyName];
				endValue = endValues[propertyName];
				deltaValue = deltaValues[propertyName];
				
				if (count == 1)
				{
					tweenTarget[propertyName] = initValue + ratio * (2 * (1 - ratio) * (path[0] -  initValue) + ratio * deltaValue);
				}
				else
				{
					index = Math.floor(count * ratio);
					insideIndex = (ratio - index / count) * count;
					if (index == 0)
					{
						p1 = initValue;
						p2 = (path[0] + path[1]) * .5;
					}
					else if (index == (count - 1))
					{
						p1 = (path[index - 1] + path[index]) * .5;
						p2 = endValue;
					}
					else
					{
						p1 = (path[index - 1] + path[index]) * .5;
						p2 = (path[index] + path[index + 1]) * .5;
					}
					
					tweenTarget[propertyName] = p1 + insideIndex * (2 * (1 - insideIndex) * (path[index] - p1) + insideIndex * (p2 - p1));
				}
					
			}
			
			return (currentTick >= duration);
		}

        public override function kill (applyHandlers:Boolean = false):void
        {
            super.kill(applyHandlers);
			
			propPaths  = {};
			initValues = {};
			endValues  = {};
			deltaValues = {};

            tweens[tweens.length] = this;
        }
    }
}
