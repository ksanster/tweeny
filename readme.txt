Simple, lightweight and extendable as3 tween engine.

Structure:
	Tweeny - main static class to manage tweens
			 can create, remove, pause and resume tweens (all or tweens with concrete target)
			 
	ITween - tween interface
	
Features:

	Global:
			// Set this, if you can set time intervals in seconds. Otherwise time is set in frames
			Tweeny.framerate = <framerate>;
			
			//Pause all tweens
			Tweeny.pauseAll();
			
			//Resume all tweens
			Tweeny.resumeAll();
			
			//Kill all tweens
			Tweeny.killAll();
			
			//Kill tween with target
			Tweeny.killOf(target);
				

	Create tween:
		
		//Tween target.propName from current to <propValue> on <time> 
		Tweeny.create(target)
				.during(<time>)
				.to({propName:propValue, ...})
				.start();
		
		//Tween target.propName from <propValue> to current on <time> 
		Tweeny.create(target)
				.during(<time>)
				.from({propName:propValue, ...})
				.start();
		
		//Start tween with delay
		Tweeny.create(target)
				.during(<time>)
				.wait(<delay>)
				.to({...})
				.start();
		
		
		//Use custom easing:
		Tweeny.create(target)
				.ease(<ease method>)
				.during(<time>)
				.to({...}).start();
		
		
		//Complete handler (first param in handler always is ITween instance)
		Tweeny.create(target)
				.during(<time>)
				.to({...})
				.onComplete(hander, ...params)
				.start();
				
				
		//Tween sequence
			Tweeny.create(target)
					.during(<time>)
					.to({...})
					.chain( 
						Tweeny.create(target)
							  .during(<time1>)
							  .to({...}))
					.start();
					
					
		//Use plugin for custom tweens:
		//tweenFactoryMethod must return instance of ITween and with base class Tween
					
		Tweeny.create(target, <tweenFactoryMethod>)
				.during(<time>)
				.to({...})
				.onComplete(hander, ...params)
				.start();
				
		//Has three tween variants:
			- PropertyTween (default)
			- DisplayCoordsTween. Target is DisplayObject and changes only x and y properties
			- BezierTween. Use Bezier curves to tweening properties.
			  Syntax (last elements of array are the endpoints of properties, others are control points of bezier curve):
	 		  
		 		  Tweeny.create(drop, BezierTween.create)
		 				.during(80)
		 				.to(
		 					{x: [460, 100, 360],
		 					 y: [125, 285, 450]})
		 				.start();	 
			  
			    
				
					
				  