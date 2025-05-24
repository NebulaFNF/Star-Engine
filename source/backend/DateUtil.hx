package backend;

import StringTools;

/**
 * Utilities for performing operations on dates.
 */
class DateUtil
{
	public static function generateTimestamp(?date:Date = null):String
	{
		if (date == null)
			date = Date.now();

		return '${DateTools.format(date, '%B %d, %Y')} at ${DateTools.format(date, '%I:%M %p')}';
	}

	public static function generateCleanTimestamp(?date:Date = null):String
	{
		if (date == null)
			date = Date.now();

		return '${DateTools.format(date, '%B %d, %Y')} at ${DateTools.format(date, '%I:%M %p')}';
	}
}
