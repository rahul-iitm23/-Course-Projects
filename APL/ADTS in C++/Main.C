/**************************************************************************
 *  $Id$
 *  Release $Name$
 *
 *  File:	main.C - User Defined ElementType
 *
 *  Purpose:	Illustration of Queue ADT
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

int main() {
  Queue q;
  char opr;
  int numElements, numOpr;
  int flag;
  int i;
  ElementType x, y;
  cin >> numElements >> numOpr;
  q.makeNull();
  for (i = 0; i < numElements; i++)
    q.enQueue((ElementType)(i));
  for (i = 0; i < numOpr; i++) {
    cin >> opr;
    switch (opr) {
    case 'q': {
      cin >> x;
      q.enQueue(x);break;
    }
    case 'd': {
      y = q.deQueue();
      cout <<"Dequeued value: "<< y <<endl;
      break;
    }
    case 'f':   {
      y = q.front();
      cout <<"Front value: "<< y << endl ;
      break;
    }
    case 'e':   {
      flag = q.emptyQueue();
      cout <<"Is the queue empty? "<< flag<<endl;
      break;
    }
    default: ; break;
    }
   
      
  }
  
  cout << "Remaining elements in the queue: ";
  if (q.emptyQueue()){
    cout<<"The queue is empty.";
  }
  else{
    while (!q.emptyQueue()) {
      x = q.deQueue();
      cout << x << " ";
    }
 
  }
 
  
  return 0;
  }
