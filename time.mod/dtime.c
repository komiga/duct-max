
/*
Copyright (c) 2010 plash <plash@komiga.com>

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

void c_dtime_settz(const char* value) {
	if (value) {
		#ifdef _WIN32
			SetEnvironmentVariable("TZ", value);
		#else
			setenv("TZ", value, 1);
		#endif
	} else {
		#ifdef _WIN32
			SetEnvironmentVariable("TZ", NULL);
			//_putenv("TZ=NULL");
		#else
			unsetenv("TZ");
		#endif
	}
	#ifdef _WIN32
		_tzset();
	#else
		tzset();
	#endif
}

time_t bmx_dtime_totimezone(time_t time, const BBString* tz) {
	if (tz && tz->length > 0) {
		struct tm* tm = localtime(&time);
		char* tzo = getenv("TZ");
		c_dtime_settz(bbTmpCString(tz));
		time = mktime(tm);
		c_dtime_settz(tzo);
	}
	return time;
}

BBString* bmx_dtime_format(time_t time, BBString* fmt, BBString* tz) {
	#define BUFSIZE 512
	char buf[BUFSIZE];
	char* tzo;
	//printf("tzset tz=\"%s\"  tz#%p, empty#%p, null#%p\n", bbTmpCString(tz), tz, &bbEmptyString, &bbNullObject);
	if (tz && tz->length > 0) {
		tzo = getenv("TZ");
		c_dtime_settz(bbTmpCString(tz));
	}
	struct tm* tm = localtime(&time);
	int count = strftime(buf, BUFSIZE, bbTmpCString(fmt), tm);
	if (tz && tz->length > 0) {
		c_dtime_settz(tzo);
	}
	if (count == 0)
		return &bbEmptyString;
	return bbStringFromBytes(buf, count);
}

