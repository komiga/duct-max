
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

#include "intmap.hpp"

intmap * bmx_intmap_create() {
	return new intmap();
}

void bmx_intmap_delete(intmap * imap) {
	bmx_intmap_clear(imap);
	delete imap;
}

void bmx_intmap_clear(intmap * imap) {	
	intmap::iterator p;
	for(p = imap->begin(); p != imap->end(); ++p)
	{
		BBObject * obj = (*imap)[p->first];
		if (obj) {
			BBRELEASE(obj);
			(*imap)[p->first] = 0;
		}
	}
	imap->clear();
}

int bmx_intmap_size(intmap const * imap) {	
	return int(imap->size());
}

int bmx_intmap_contains(intmap const * imap, int key) {
	return imap->end() != imap->find(key);
}

void bmx_intmap_remove(intmap * imap, int key) {
	imap->erase(key);
}

void bmx_intmap_set(intmap * imap, int key, BBObject * obj) {
	BBObject * value = (*imap)[key];
	if (value) {
		BBRELEASE(value);
	}
	
	// Null checks are now on the Max-side, this is just a sanity check
	if (obj != &bbNullObject) {
		BBRETAIN(obj);
	}
	//else {
	//	obj = 0;
	//}
	
	(*imap)[key] = obj;
}

BBObject * bmx_intmap_get(intmap * imap, int key) {
	BBObject * obj = (*imap)[key];
	//return obj ? obj : &bbNullObject;
	return obj;
}

intmap::iterator * bmx_intmap_iter_first(intmap * imap) {
	return new intmap::iterator(imap->begin());
}

intmap::iterator * bmx_intmap_iter_next(intmap::iterator * iter) {
	++(*iter);
	return iter;
}

int bmx_intmap_iter_hasnext(intmap * imap, intmap::iterator * iter) {
	return imap->end() != *iter ? 1 : 0;
}

BBObject * bmx_intmap_iter_getobject(intmap::iterator * iter) {
	return (*iter)->second;
}

void bmx_intmap_iter_delete(intmap::iterator * iter) {
	delete iter;
}

