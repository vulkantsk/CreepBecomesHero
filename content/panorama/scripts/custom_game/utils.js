function SubscribeNetTable( tableName, keyName, subFunc ) {
	var data = CustomNetTables.GetTableValue( tableName, keyName )

	if ( data ) {
		subFunc( data )
	}

	CustomNetTables.SubscribeNetTableListener( tableName, function( t, k, v ) {
		if ( keyName == k ) {
			subFunc( v )
		}
	} )
}