/**************************************************************************
 *  $Id$
 *  Release $Name$
 *
 *  File:	ListADTArray.C - Implementation of lists using an linked list
 *
 *  Purpose:	
 *
 *  Author:	Rahul Kumar
 *
 *  Created:    Mon 20-Sep-2020 
 *
 *  Last modified:  
 *
 *  Bugs:	
 *
 *  Change Log:	<Date> <Author>
 *  		<Changes>
 *
 **************************************************************************/
#include "../include/ListADT.h"
#include "../include/ElementType.h"
#include <iostream>
using namespace std;
void List::makeNull() {
  listHead = new CellNode;
  listHead->next = NULL;
}
void List::insert(ElementType x, Position p) {
  Position temp;
  temp = p->next;
  p->next = new cellType;
  p->next->next  = temp;
  p->next->value = x;
}
ElementType List::retrieve(Position p) {
  return(p->next->value);  
}
void List::printList() {
  Position p;
  p = listHead->next;
  while (p != NULL) {
    cout << p->value << " ";
    p = p->next;
  }
  cout << endl;
 }
int List::empty() {
  if (listHead->next == NULL)
    return 1;
  else
    return 0;
}
Position List::end() {
  Position p;
  p = listHead;
  while (p->next != NULL)
    p = p->next;
  return(p);
}
void List::delItem(Position p) {
   p->next = p->next->next;
}
Position List::first() {
  return(listHead);
}
Position List::next(Position p) {
  return (p->next);
}


/**************************************************************************
 * $Log$
 *
 * Local Variables:
 * time-stamp-active: t
 * time-stamp-line-limit: 20
 * time-stamp-start: "Last modified:[ 	]+"
 * time-stamp-format: "%3a %:d-%3b-%:y %02H:%02M:%02S by %u"
 * time-stamp-end: "$"
 * End:
 *                        End of ListADTArray.C
 **************************************************************************/
