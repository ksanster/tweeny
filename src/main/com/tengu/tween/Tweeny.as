/**
 * User: tengu
 * Date: 03.07.13
 * Time: 13:13
 */
package com.tengu.tween
{
    import com.tengu.core.errors.StaticClassConstructError;
    import com.tengu.tween.api.ITween;
    import com.tengu.tween.plugins.PropertyTween;

    import flash.display.Shape;
    import flash.events.Event;
    import flash.utils.Dictionary;

    public class Tweeny
    {
        internal static const activeTweens:Dictionary = new Dictionary();
        internal static const delayedTweens:Dictionary = new Dictionary();

        private static var frameRate:uint = 1;

        private static const motor:Shape = function ():Shape
        {
            var result:Shape = new Shape();
            result.addEventListener(Event.ENTER_FRAME, tick);
            return result;
        }();

        public function Tweeny ()
        {
            throw new StaticClassConstructError(this);
        }

        /**
         * If set, all intervals will be set in seconds, else - in frames
         */
        public static function setFramerate (value:uint):void
        {
            frameRate = value || 1;
        }

        public static function create (target:Object, factoryMethod:Function = null):ITween
        {
            var tween:ITween;
            if (factoryMethod == null)
            {
                factoryMethod = PropertyTween.create;
            }

            tween = factoryMethod();
            tween.target = target;
            return tween;
        }

        public static function killOf (target:Object):void
        {
            var tween:ITween = null;
            var o:* = null;
            for (o in activeTweens)
            {
                tween = o as ITween;
                if (tween.target == target)
                {
                    tween.kill();
                }
            }
            for (o in delayedTweens)
            {
                tween = o as ITween;
                if (tween.target == target)
                {
                    tween.kill();
                }
            }
        }

        public static function killAll ():void
        {
            var o:* = null;
            for (o in activeTweens)
            {
                (o as ITween).kill();
            }
            for (o in delayedTweens)
            {
                (o as ITween).kill();
            }
        }

        public static function pauseAll ():void
        {
            if (motor.hasEventListener(Event.ENTER_FRAME))
            {
                motor.removeEventListener(Event.ENTER_FRAME, tick);
            }
        }

        public static function resumeAll ():void
        {
            if (!motor.hasEventListener(Event.ENTER_FRAME))
            {
                motor.addEventListener(Event.ENTER_FRAME, tick);
            }
        }

        private static function tick (event:Event):void
        {
            var tween:Tween = null;
            var o:* = null;
            for (o in activeTweens)
            {
                tween = o as Tween;
                if (tween.tick())
                {
                    tween.kill(true);
                }
            }
            for (o in delayedTweens)
            {
                tween = o as Tween;
                tween.delay--;
                if (tween.delay <= 0)
                {
                    delete delayedTweens[tween];
                    tween.start();
                }
            }
        }

    }
}