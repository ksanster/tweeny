package com.tengu.tween.plugins
{
    import com.tengu.tween.Tween;

    public class PropertyTween extends Tween
    {
        private static const tweens:Vector.<PropertyTween> = new Vector.<PropertyTween>();

        public static function create ():PropertyTween
        {
            var tween:PropertyTween = null;
            if (tweens.length == 0)
            {
                tween = new PropertyTween();
            }
            else
            {
                tween = tweens.shift();
            }
            return tween;
        }

        public static function clearCache ():void
        {
            tweens.length = 0;
        }

        private var initValues:Object = null;
        private var endValues:Object = null;
        private var deltaValues:Object = null;

        private var tickMethod:Function = null;

        public function PropertyTween ()
        {
            super();
        }

        protected override function parse (params:Object, isReverse:Boolean = false):void
        {
            super.parse(params);
            var propertyName:String;
            var initValue:Number = 0;
            var endValue:Number  = 0;
            initValues  = {};
            endValues   = {};
            deltaValues = {};
            if (!isReverse)
            {
                for (propertyName in params)
                {
                    if (target.hasOwnProperty(propertyName))
                    {
                        initValue = target[propertyName];
                        endValue  = params[propertyName];

                        initValues[propertyName]  = initValue
                        endValues[propertyName]   = endValue;
                        deltaValues[propertyName] = (endValue - initValue);
                    }
                }
            }
            else
            {
                for (propertyName in params)
                {
                    if (target.hasOwnProperty(propertyName))
                    {
                        initValue = params[propertyName];
                        endValue  = target[propertyName];

                        target[propertyName] = initValue;

                        initValues[propertyName]  = initValue
                        endValues[propertyName]   = endValue;
                        deltaValues[propertyName] = (endValue - initValue);
                    }
                }
            }
            ratio = 0;
        }

        protected override function process():Boolean
        {
            var propertyName:String = null;
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
			
            for (propertyName in endValues)
            {
                target[propertyName] = initValues[propertyName] + ratio * deltaValues[propertyName];
            }
            return false;
        }

        public override function kill (applyHandlers:Boolean = false):void
        {
            super.kill(applyHandlers);
            initValues = {};
            endValues = {};
            deltaValues = {};
            tweens[tweens.length] = this;
        }
    }
}