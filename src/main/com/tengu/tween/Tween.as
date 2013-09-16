package com.tengu.tween
{
    import com.tengu.tween.api.ITween;
    import com.tengu.tween.easing.Quadratic;

    import flash.utils.Dictionary;
    
    public class Tween implements ITween
    {
        private var completeHandlers:Vector.<Function>  = null;
        private var completeParams:Dictionary           = null;

        protected var next:ITween       = null;

        protected var currentTick:int   = 0;
        protected var ratio:Number      = 0;

        protected var duration:uint         = 0;
        protected var easeMethod:Function   = null;
        protected var tweenTarget:Object    = null;
		
		protected var startParams:Object	= null;
		protected var reverseFlag:Boolean	= false;

        internal var delay:uint = 0;

        public function get target ():Object
        {
            return tweenTarget;
        }

        public function set target (value:Object):void
        {
            tweenTarget = value;
        }

        public function Tween ()
        {
            initialize();
        }

		protected function initialize ():void
        {
            completeHandlers = new Vector.<Function>();
            completeParams = new Dictionary();
            easeMethod = Quadratic.easeOut;
        }

        protected function parse (params:Object, isReverse:Boolean = false):void
        {
//            Abstract
        }
		
		protected function process ():Boolean
		{
			//Abstract
			return false;
		}

        public final function to (params:Object):ITween
        {
			startParams = params;
			reverseFlag = false;
            return this;
        }

        public final function from (params:Object):ITween
        {
			startParams = params;
			reverseFlag = true;
            return this;
        }

        public final function chain (tween:ITween):ITween
        {
            next = tween;
            return this;
        }

        public final function during (duration:uint):ITween
        {
            this.duration = duration * Tweeny.frameRate || 1;
            return this;
        }

        public final function wait (delay:uint):ITween
        {
            this.delay = delay * Tweeny.frameRate;
            return this;
        }

        public final function ease (method:Function):ITween
        {
            easeMethod = method;
            return this;
        }

        public final function onComplete (handler:Function, ...params):ITween
        {
            addCompleteHandler(handler, params);
            return this;
        }

        public final function addCompleteHandler (method:Function, ...params):void
        {
            var args:Array;
            if (params.length == 1 && params[0] is Array)
            {
                args = params[0];
            }
            else
            {
                args = params;
            }
            args.unshift(this);
            if (completeHandlers.indexOf(method) == -1)
            {
                completeHandlers[completeHandlers.length] = method;
                completeParams[method] = args;
            }
        }

        public final function removeCompleteHandler (method:Function):void
        {
            var idx:int = completeHandlers.indexOf(method);
            if (idx != -1)
            {
                completeHandlers.splice(idx, 1);
            }
            delete completeParams[method];
        }

        internal final function tick ():Boolean
        {
            return process();
        }
		
		public function start ():ITween
		{
			if (delay > 0)
			{
				Tweeny.delayedTweens[this] = true;
			}
			else
			{
			    parse(startParams, reverseFlag);
				Tweeny.activeTweens[this] = true;
			}
			return this;
		}

        public function kill (applyHandlers:Boolean = false):void
        {
            var tmpHandlers:Vector.<Function>;

            delete Tweeny.delayedTweens[this];
            delete Tweeny.activeTweens[this];

            if (applyHandlers)
            {
                tmpHandlers = completeHandlers.slice();
                for each (var method:Function in tmpHandlers)
                {
                    method.apply(null, completeParams[method]);
                }
            }

            delay = 0;
            currentTick = 0;
            ratio = 0;
            completeHandlers.length = 0;
            completeParams = new Dictionary();
			startParams = {};
			reverseFlag = false;
            target = null;

            if (next != null)
            {
                next.start();
                next = null;
            }
        }
    }
}