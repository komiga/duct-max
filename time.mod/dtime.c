
/*
Copyright (c) 2010 Tim Howard

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

#include "dtime.h"

time_t bmx_dtime_strtotime(const BBString* str, const BBString* fmt) {
	struct tm tm;
	if (!strptime(bbTmpCString(str), bbTmpCString(fmt), &tm))
		return (time_t)-1;
	time_t time = mktime(&tm);
	return time;
}

time_t bmx_dtime_totimezone(time_t time, const BBString* tz) {
	if (tz && tz->length > 0) {
		struct tm* tm = localtime(&time);
		char* tzo = getenv("TZ");
		setenv("TZ", bbTmpCString(tz), 1);
		tzset();
		time = mktime(tm);
		if (tzo)
			setenv("TZ", tzo, 1);
		else
			unsetenv("TZ");
		tzset();
	}
	return time;
}

BBString* bmx_dtime_format(time_t time, BBString* fmt, BBString* tz) {
	#define BUFSIZE 256
	char buf[BUFSIZE];
	char* tzo;
	//printf("tzset tz=\"%s\"  tz#%p, empty#%p, null#%p\n", bbTmpCString(tz), tz, &bbEmptyString, &bbNullObject);
	if (tz && tz->length > 0) {
		tzo = getenv("TZ");
		setenv("TZ", bbTmpCString(tz), 1);
		tzset();
	}
	struct tm* tm = localtime(&time);
	int count = strftime(buf, BUFSIZE, bbTmpCString(fmt), tm);
	if (tz && tz->length > 0) {
		if (tzo)
			setenv("TZ", tzo, 1);
		else
			unsetenv("TZ");
		tzset();
	}
	if (count == 0)
		return &bbEmptyString;
	return bbStringFromBytes(buf, count);
}

/*int unsetenv_(BBString* name) {
	return unsetenv(bbTmpCString(name)) == 0;
}*/

