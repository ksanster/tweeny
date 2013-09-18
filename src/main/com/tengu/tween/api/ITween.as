package com.tengu.tween.api
{
    public interface ITween
    {
        function get target ():Object;
        function set target (value:Object):void;

        function from (params:Object):ITween;
        function to (params:Object):ITween;

        function during (duration:Number):ITween;
        function wait (delay:Number):ITween;

        function ease (method:Function):ITween;

        function chain (tween:ITween):ITween;

        function onComplete (handler:Function, ...params):ITween;

		function start ():ITween;
        function kill (applyHandlers:Boolean = false):void;
    }
}
