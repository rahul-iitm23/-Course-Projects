/**************************************************************************
 *  $Id$
 *  Release $Name$
 *
 *  File:	ListADT.C - User Defined ElementType
 *
 *  Purpose:	Implementation of Function from ListADT.h
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
#include "../include/QueueADT.h"
#include <iostream>
using namespace std;
ElementType Queue::front() {
  
  
    if(l.empty()) return (ElementType)-1;
    return(l.retrieve(l.first())); 
}
ElementType Queue::deQueue() {
  
  
    if(l.empty()) return (ElementType)-1;
    Position temp = l.first();
    ElementType x = l.retrieve(temp);
    l.delItem(temp);
    return x;
}
void Queue::enQueue(ElementType x) {
  
  Position temp = l.end();
    l.insert(x, temp);
}
void Queue::makeNull() {
  
  
    l.makeNull();
}
int Queue::emptyQueue() {
  
  
    return l.empty();
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
