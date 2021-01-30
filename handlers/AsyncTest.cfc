
/**
 * My Event Handler Hint
 */
component extends="coldbox.system.EventHandler"{

	property name="asyncManager" inject="asyncManager@coldbox";
	property name="logger" inject="logbox:logger:{this}";

	private query function getData() {
		var timer1 = getTickCount();
		var result = queryExecute("select 1", {}, {datasource = "MyDatasource"});
		var execTime = (getTickCount() - timer1) * 0.001;
		logger.debug("Executed getData() in #execTime# seconds");
		return result;
	}

	/**
	 * Index
	 */
	any function index( event, rc, prc ){

		try {
		var myExecuter = asyncManager.getExecutor("my-executor");
		var loadAppContext = false;
		var futures = [
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext ),
			asyncManager.newFuture( value = function() { return getData(); },executor =  myExecuter, loadAppContext = loadAppContext )
		];

		var myFuture = asyncManager.all( futures );
		//Wait 2 seconds
		sleep(2000);
		//Then get a thread dump to see what is going on
		jvmThreadHelper = new models.util.JvmThreadHelper();
		var threadDump = jvmThreadHelper.getThreadDump();
		//wait for results
		var results = myFuture.get();

		// writeDump(results);abort;

		//Output thread dump
		return "<pre>#threadDump#</pre>";

		} catch (any e) {
			writeDump(e);abort;
		}


	}

}
