
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

intmap* bmx_intmap_create() {
	return new intmap();
}

void bmx_intmap_delete(intmap* imap) {
	bmx_intmap_clear(imap);
	delete imap;
}

void bmx_intmap_clear(intmap* imap) {	
	intmap::iterator p;
	for (p = imap->begin(); p != imap->end(); ++p) {
		BBObject* obj = (*imap)[p->first];
		if (obj) {
			if (obj != &bbNullObject)
				BBRELEASE(obj);
			(*imap)[p->first] = 0;
		}
	}
	imap->clear();
}

int bmx_intmap_size(intmap const* imap) {	
	return (int)imap->size();
}

int bmx_intmap_isempty(intmap const* imap) {
	return (int)imap->empty();
}

int bmx_intmap_contains(intmap const* imap, int key) {
	return imap->end() != imap->find(key);
}

void bmx_intmap_remove(intmap* imap, int key) {
	imap->erase(key);
}

void bmx_intmap_set(intmap* imap, int key, BBObject* obj) {
	if (obj == &bbNullObject) {
		imap->erase(key);
	} else {
		BBObject* value = (*imap)[key];
		if (value)
			BBRELEASE(value);
		BBRETAIN(obj);
		(*imap)[key] = obj;
	}
}

BBObject* bmx_intmap_get(intmap* imap, int key) {
	BBObject* obj = (*imap)[key];
	//return obj ? obj : &bbNullObject;
	return obj;
}

BBObject* bmx_intmap_getlastobj(intmap const* imap) {
	if (!imap->empty())
		return imap->rbegin()->second;
	else
		return &bbNullObject;
}

int bmx_intmap_getlastkey(intmap const* imap) {
	if (!imap->empty())
		return imap->rbegin()->first;
	else
		return 0;
}

// Iterator

intmap::iterator* bmx_intmap_iter_first(intmap* imap) {
	return new intmap::iterator(imap->begin());
}

void bmx_intmap_iter_next(intmap::iterator* iter) {
	++(*iter);
}

int bmx_intmap_iter_hasnext(intmap* imap, intmap::iterator const* iter) {
	return *iter != imap->end() ? 1 : 0;
}

BBObject* bmx_intmap_iter_getobject(intmap::iterator const* iter) {
	return (*iter)->second;
}

int bmx_intmap_iter_getkey(intmap::iterator const* iter) {
	return (*iter)->first;
}

void bmx_intmap_iter_delete(intmap::iterator* iter) {
	delete iter;
}

// Reverse iterator

intmap::reverse_iterator* bmx_intmap_riter_first(intmap* imap) {
	return new intmap::reverse_iterator(imap->rbegin());
}

void bmx_intmap_riter_next(intmap::reverse_iterator* iter) {
	++(*iter);
}

int bmx_intmap_riter_hasnext(intmap* imap, intmap::reverse_iterator const* iter) {
	return *iter != imap->rend() ? 1 : 0;
}

BBObject* bmx_intmap_riter_getobject(intmap::reverse_iterator const* iter) {
	return (*iter)->second;
}

int bmx_intmap_riter_getkey(intmap::reverse_iterator const* iter) {
	return (*iter)->first;
}

void bmx_intmap_riter_delete(intmap::reverse_iterator* iter) {
	delete iter;
}

