component
	output = false
	hint = "I help inspect the JVM threads."
	{

	/**
	* I initialize the JVM Thread Helper.
	*
	* @output false
	*/
	public any function init() {

		variables.javaManagementFactory = createObject( "java", "java.lang.management.ManagementFactory" );
		variables.threadMXBean = javaManagementFactory.getThreadMXBean();

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I return a full thread-dump of the current JVM state. This will shed light on what
	* each thread in the JVM is doing at roughly this moment.
	*
	* @maxStackDepth I determine how many stack elements should be reported for each thread.
	* @output false
	*/
	public string function getThreadDump( numeric maxStackDepth = 50 ) {

		// Gather the thread meta-data for all current JVM threads.
		// --
		// CAUTION: Since gathering the thread IDs and gathering the meta-data is a two-
		// step action, there is a chance that some of the threads (corresponding to the
		// gathered IDs) will no longer exist at the time the meta-data is gathered. In
		// such cases, the thread meta-data will be undefined in the resulting array.
		var allThreadIDs = threadMXBean.getAllThreadIds();
		var allThreads = threadMXBean.getThreadInfo( allThreadIDs, javaCast( "int", maxStackDepth ) );
		var allThreadsLength = arrayLen( allThreads );

		// Each line of the thread dump is going to be appended to this buffer. This
		// buffer will then be collapsed down into a single string.
		var buffer = [];
		// As an optimization, we can resize the buffer based on the number of threads
		// we've collected. This way, we're not continually changing the size of the
		// buffer as we iterate over the thread info.
		arrayResize( buffer, ( allThreadsLength * ( maxStackDepth + 3 ) ) );

		var newline = chr( 10 );
		var tab = chr( 9 );
		var i = 0;

		// NOTE: In later versions of ColdFusion, undefined array elements are
		// implicitly skipped in a for-in loop. But, in earlier versions of ColdFusion,
		// the iteration variable comes back as undefined.
		for ( var threadInfo in allThreads ) {

			// If the given thread had already been terminated by the time the meta-data
			// was gathered, we need to skip over it.
			if ( isNull( threadInfo ) ) {

				continue;

			}

			buffer[ ++i ] = """#threadInfo.getThreadName()#""";
			buffer[ ++i ] = "#tab#java.lang.Thread.State: #threadInfo.getThreadState().toString()#";

			for ( var element in threadInfo.getStackTrace() ) {

				buffer[ ++i ] = "#tab##tab#at #element.toString()#";

			}

			// Put a spacer in between each thread.
			buffer[ ++i ] = "";

		}

		return( trim( arrayToList( buffer, newline ) ) );

	}

}