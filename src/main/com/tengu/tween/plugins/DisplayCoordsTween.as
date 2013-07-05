package com.tengu.tween.plugins
{
    import com.tengu.tween.Tween;

    import flash.display.DisplayObject;


    public class DisplayCoordsTween extends Tween
    {
        private static const tweens:Vector.<DisplayCoordsTween> = new Vector.<DisplayCoordsTween>();

        public static function create ():DisplayCoordsTween
        {
            var tween:DisplayCoordsTween = null;
            if (tweens.length == 0)
            {
                tween = new DisplayCoordsTween();
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


        private var startX:Number = 0;
        private var deltaX:Number = 0;

        private var startY:Number = 0;
        private var deltaY:Number = 0;

        private var displayTarget:DisplayObject = null;

        public function DisplayCoordsTween ()
        {
            super();
        }

        protected override function parse (params:Object, isReverse:Boolean = false):void
        {
            super.parse(params);

            displayTarget = target as DisplayObject;

            startX = displayTarget.x;
            startY = displayTarget.y;

            if (!isReverse)
            {
                deltaX = params.hasOwnProperty("x") ? parseFloat(params["x"]) - startX : 0;
                deltaY = params.hasOwnProperty("y") ? parseFloat(params["y"]) - startY : 0;
            }
            else
            {
                if (params.hasOwnProperty("x"))
                {
                    startX = parseFloat(params["x"]);
                    deltaX = displayTarget.x - startX;
                }

                if (params.hasOwnProperty("y"))
                {
                    startY = parseFloat(params["y"]);
                    deltaY = displayTarget.y - startY;
                }
            }
        }

		protected override function process ():Boolean
        {
            currentTick++;
            ratio = easeMethod(currentTick / duration);

            displayTarget.x = startX + ratio * deltaX;
            displayTarget.y = startY + ratio * deltaY;

            return (currentTick == duration);
        }

        public override function kill (applyHandlers:Boolean = false):void
        {
            super.kill(applyHandlers);
            tweens.push(this);
        }

    }
}