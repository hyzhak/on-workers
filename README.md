on-workers
==========

High level DSL API for Adobe Workers. Based on fluent interfaces. 

There I call Adobe Workers as Bundlers in OSGI. Because its more hightlevel concept. Thant can be not only Worker but just separate FlexModule, or other piece of code.

Example
=======

'''actionscript

//Create Bundle Bridge Builder

//One side

bridgeBuilder = BundleBridges.onWorkers()
					.newBundleBridgeBuilder()
						.fromCurrent()
						.toNewBundleFromBytes(loaderInfo.bytes);

//Other Side

bridgeBuilder = BundleBridges.onWorkers()
					.newBundleBridgeBuilder()
						.fromCurrent()
						.toMain();


//Create Bundle Bridge

bridge = bridgeBuilder.buildBridge();

//Invoke Method

bridge.invoke("methodName")
	.withParam("some param name", "1")
	.withParam("another param name", "2");

//Handle Method Invocation

bridge.onInvoke("three", function(response : BundleResponse) : void{
	response.getParam("some param name");
	response.getParam("another param name");
});

'''