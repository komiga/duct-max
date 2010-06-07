
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

#include "numericmap.hpp"

numericmap* bmx_numericmap_create() {
	return new numericmap();
}

void bmx_numericmap_delete(numericmap* nmap) {
	bmx_numericmap_clear(nmap);
	delete nmap;
}

void bmx_numericmap_clear(numericmap* nmap) {
	nmap->clear();
}

int bmx_numericmap_size(numericmap const* nmap) {
	return (int)nmap->size();
}

int bmx_numericmap_isempty(numericmap const* nmap) {
	return (int)nmap->empty();
}

int bmx_numericmap_contains(numericmap const* nmap, int key) {
	return nmap->end() != nmap->find(key);
}

void bmx_numericmap_remove(numericmap* nmap, int key) {
	nmap->erase(key);
}

void bmx_numericmap_set(numericmap* nmap, int key, int value) {
	(*nmap)[key] = value;
}

int bmx_numericmap_get(numericmap* nmap, int key) {
	return (*nmap)[key];
}

int bmx_numericmap_getlastvalue(numericmap const* nmap) {
	if (!nmap->empty())
		return nmap->rbegin()->second;
	else
		return 0;
}

int bmx_numericmap_getlastkey(numericmap const* nmap) {
	if (!nmap->empty())
		return nmap->rbegin()->first;
	else
		return 0;
}

// Iterator

numericmap::iterator* bmx_numericmap_iter_first(numericmap* nmap) {
	return new numericmap::iterator(nmap->begin());
}

void bmx_numericmap_iter_next(numericmap::iterator* iter) {
	++(*iter);
}

int bmx_numericmap_iter_hasnext(numericmap* nmap, numericmap::iterator const* iter) {
	return *iter != nmap->end() ? 1 : 0;
}

int bmx_numericmap_iter_getvalue(numericmap::iterator const* iter) {
	return (*iter)->second;
}

int bmx_numericmap_iter_getkey(numericmap::iterator const* iter) {
	return (*iter)->first;
}

void bmx_numericmap_iter_delete(numericmap::iterator* iter) {
	delete iter;
}

// Reverse iterator

numericmap::reverse_iterator* bmx_numericmap_riter_first(numericmap* nmap) {
	return new numericmap::reverse_iterator(nmap->rbegin());
}

void bmx_numericmap_riter_next(numericmap::reverse_iterator* iter) {
	++(*iter);
}

int bmx_numericmap_riter_hasnext(numericmap* nmap, numericmap::reverse_iterator const* iter) {
	return *iter != nmap->rend() ? 1 : 0;
}

int bmx_numericmap_riter_getvalue(numericmap::reverse_iterator const* iter) {
	return (*iter)->second;
}

int bmx_numericmap_riter_getkey(numericmap::reverse_iterator const* iter) {
	return (*iter)->first;
}

void bmx_numericmap_riter_delete(numericmap::reverse_iterator* iter) {
	delete iter;
}

