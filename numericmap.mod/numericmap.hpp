
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

#ifndef _numericmap_HPP_
#define _numericmap_HPP_

#include <map>
#include <blitz.h>

typedef std::map<int, int> numericmap;

extern "C" {
	numericmap* bmx_numericmap_create();
	void bmx_numericmap_delete(numericmap* nmap);
	
	void bmx_numericmap_clear(numericmap* nmap);
	int bmx_numericmap_size(numericmap const* nmap);
	int bmx_numericmap_isempty(numericmap const* nmap);
	int bmx_numericmap_contains(numericmap const* nmap, int key);
	
	void bmx_numericmap_remove(numericmap* nmap, int key);
	void bmx_numericmap_set(numericmap* nmap, int key, int value);
	int bmx_numericmap_get(numericmap* nmap, int key);
	
	int bmx_numericmap_getlastvalue(numericmap const* nmap);
	int bmx_numericmap_getlastkey(numericmap const* nmap);
	
	numericmap::iterator* bmx_numericmap_iter_first(numericmap* nmap);
	void bmx_numericmap_iter_next(numericmap::iterator* iter);
	int bmx_numericmap_iter_hasnext(numericmap* nmap, numericmap::iterator const* iter);
	int bmx_numericmap_iter_getvalue(numericmap::iterator const* iter);
	int bmx_numericmap_iter_getkey(numericmap::iterator const* iter);
	void bmx_numericmap_iter_delete(numericmap::iterator* iter);
	
	numericmap::reverse_iterator* bmx_numericmap_riter_first(numericmap* nmap);
	void bmx_numericmap_riter_next(numericmap::reverse_iterator* iter);
	int bmx_numericmap_riter_hasnext(numericmap* nmap, numericmap::reverse_iterator const* iter);
	int bmx_numericmap_riter_getvalue(numericmap::reverse_iterator const* iter);
	int bmx_numericmap_riter_getkey(numericmap::reverse_iterator const* iter);
	void bmx_numericmap_riter_delete(numericmap::reverse_iterator* iter);
};

#endif // _numericmap_HPP_

